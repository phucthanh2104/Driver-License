import 'package:flutter/material.dart';
import 'package:gplx/entities/Simulator.dart';
import 'package:video_player/video_player.dart';

class SituationDetailPage extends StatefulWidget {
  final List<Simulator> situations; // Danh sách các tình huống
  final int initialIndex; // Vị trí tình huống ban đầu

  const SituationDetailPage({
    Key? key,
    required this.situations,
    required this.initialIndex,
    required int testId,
    required int testPassedScore,
  }) : super(key: key);

  @override
  _SituationDetailPageState createState() => _SituationDetailPageState();
}

class _SituationDetailPageState extends State<SituationDetailPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  int? _flaggedSecond;
  bool isCheckFlag = false;
  bool _showGuide = false;
  bool _isMenuOpen = false; // Trạng thái mở/đóng menu

  late int videoLength;
  late int dangerSecond;
  late int currentIndex; // Theo dõi tình huống hiện tại

  int? _score;

  final String fiveScore = "green";
  final String fourScore = "blue";
  final String threeScore = "yellow";
  final String twoScore = "orange";
  final String oneScore = "red";
  final String zeroScore = "black";

  late Map<int, String> colorMap;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex; // Khởi tạo chỉ số tình huống
    videoLength = widget.situations[currentIndex].videoLength;
    dangerSecond = widget.situations[currentIndex].dangerSecond;
    _initializeVideoPlayer();
    _initializeColorMap();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.network(
      widget.situations[currentIndex].videoLink,
    )..initialize().then((_) {
      setState(() {});
      _controller.setLooping(true);
    });
  }

  void _initializeColorMap() {
    colorMap = {};
    List<String> colors = [oneScore, twoScore, threeScore, fourScore, fiveScore];
    int j = 0;
    for (int i = dangerSecond; i > (dangerSecond - 5); i--) {
      j++;
      colorMap[i] = colors[j - 1];
    }
    for (int i = 0; i < videoLength; i++) {
      if (!colorMap.containsKey(i)) {
        colorMap[i] = zeroScore;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  int _calculateScore(int flaggedSecond) {
    final color = colorMap[flaggedSecond];
    switch (color) {
      case 'green':
        return 5;
      case 'blue':
        return 4;
      case 'yellow':
        return 3;
      case 'orange':
        return 2;
      case 'red':
        return 1;
      default:
        return 0; // black hoặc null đều được xem là 0 điểm
    }
  }

  void _flagCurrentPosition() {
    if (!isCheckFlag) {
      final position = _controller.value.position.inSeconds;
      final clampedPosition = position.clamp(0, videoLength - 1);
      final score = _calculateScore(clampedPosition);

      print('Người dùng gắn cờ tại: $clampedPosition giây -> Điểm: $score');

      setState(() {
        isCheckFlag = true;
        _flaggedSecond = clampedPosition;
        _score = score;
      });
    }
  }

  void _toggleGuideVisibility() {
    setState(() {
      _showGuide = !_showGuide;
    });
  }

  void _previousSituation() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _resetVideo();
      });
    }
  }

  void _nextSituation() {
    if (currentIndex < widget.situations.length - 1) {
      setState(() {
        currentIndex++;
        _resetVideo();
      });
    }
  }

  void _resetVideo() {
    _controller.dispose();
    videoLength = widget.situations[currentIndex].videoLength;
    dangerSecond = widget.situations[currentIndex].dangerSecond;
    _initializeVideoPlayer();
    _initializeColorMap();
    _isPlaying = false;
    _flaggedSecond = null;
    isCheckFlag = false;
    _showGuide = false;
    _score = null;
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  void _selectSituation(int index) {
    setState(() {
      currentIndex = index;
      _resetVideo();
      _isMenuOpen = false; // Đóng menu sau khi chọn
    });
  }

  @override
  Widget build(BuildContext context) {
    final simulator = widget.situations[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(simulator.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _toggleMenu,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
              VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: Colors.red,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.grey[300]!,
                ),
              ),
              isCheckFlag
                  ? ScoreProgressBar(
                videoLength: videoLength,
                colorMap: colorMap,
                controller: _controller,
                flaggedSecond: _flaggedSecond,
              )
                  : const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay),
                    onPressed: () {
                      _controller.seekTo(Duration.zero);
                      _controller.play();
                      setState(() {
                        _isPlaying = true;
                        _flaggedSecond = null;
                        isCheckFlag = false;
                        _score = null;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: _togglePlayPause,
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: _toggleGuideVisibility,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: currentIndex > 0 ? _previousSituation : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentIndex > 0 ? Colors.yellow : Colors.grey,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Câu trước"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _flagCurrentPosition,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Gắn cờ"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: currentIndex < widget.situations.length - 1 ? _nextSituation : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: currentIndex < widget.situations.length - 1 ? Colors.yellow : Colors.grey,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Câu sau"),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                simulator.title,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              if (_score != null)
                                Text("Điểm của bạn: $_score", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(
                                simulator.description,
                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            child: Visibility(
                              visible: _showGuide,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Hướng dẫn:",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    simulator.guideDescription,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  Image.network(
                                    simulator.guideImage,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Text("Không thể tải hình ảnh hướng dẫn");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Panel menu bên phải
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            right: _isMenuOpen ? 0 : -300, // Chiều rộng panel là 300
            top: 0,
            bottom: 0,
            child: Container(
              width: 300,
              color: Colors.white,
              child: Column(
                children: [
                  AppBar(
                    title: Text('Danh sách tình huống'),
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.blue,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.situations.length,
                      itemBuilder: (context, index) {
                        final situation = widget.situations[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: index == currentIndex ? Colors.green : Colors.blue,
                            child: Text(situation.id.toString() ),
                          ),
                          title: Text(situation.description ?? 'Không có mô tả'),
                          onTap: () => _selectSituation(index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScoreProgressBar extends StatelessWidget {
  final int videoLength;
  final Map<int, String> colorMap;
  final VideoPlayerController controller;
  final int? flaggedSecond;

  const ScoreProgressBar({
    Key? key,
    required this.videoLength,
    required this.colorMap,
    required this.controller,
    this.flaggedSecond,
  }) : super(key: key);

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      case 'black':
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, VideoPlayerValue value, child) {
          final screenWidth = MediaQuery.of(context).size.width;
          final currentSecond = value.position.inSeconds.clamp(0, videoLength - 1);
          const spacing = 0.1;
          final baseSegmentWidth = screenWidth / videoLength;
          final adjustedSegmentWidth = baseSegmentWidth - spacing;

          return SizedBox(
            width: screenWidth,
            height: 45,
            child: Stack(
              alignment: Alignment.topLeft,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 25,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: List.generate(videoLength, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: spacing / 2),
                        child: Container(
                          width: adjustedSegmentWidth,
                          height: 10,
                          color: _getColor(colorMap[index] ?? 'black'),
                        ),
                      );
                    }),
                  ),
                ),
                if (flaggedSecond != null)
                  Positioned(
                    left: (flaggedSecond! * baseSegmentWidth),
                    top: -8,
                    child: const Icon(
                      Icons.flag,
                      color: Colors.purpleAccent,
                      size: 40,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}