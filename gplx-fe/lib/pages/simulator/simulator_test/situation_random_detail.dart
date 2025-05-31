import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gplx/entities/Simulator.dart';
import 'package:gplx/entities/TestSimulatorDetail.dart';
import 'package:gplx/models/base_url.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SituationRandomDetailPage extends StatefulWidget {
  final List<Simulator> situations; // Danh sách các tình huống
  final int initialIndex; // Vị trí tình huống ban đầu
  final int testId; // ID của bài thi
  final int testPassedScore; // Điểm tối thiểu để đạt

  const SituationRandomDetailPage({
    Key? key,
    required this.situations,
    required this.initialIndex,
    required this.testId,
    required this.testPassedScore,
  }) : super(key: key);

  @override
  _SituationRandomDetailPageState createState() => _SituationRandomDetailPageState();
}

class _SituationRandomDetailPageState extends State<SituationRandomDetailPage> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  int? _flaggedSecond;
  bool isCheckFlag = false;
  bool _showGuide = false;

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

  // Biến trạng thái cho bài thi
  bool _isTestFinished = false; // Mặc định là false khi khởi tạo mới
  bool _hasPreviousResult = false; // Mặc định là false khi khởi tạo mới
  Map<int, int?> scores = {}; // Lưu điểm của từng tình huống
  Map<int, bool> criticalFailures = {}; // Lưu trạng thái điểm liệt

  // Đồng hồ đếm ngược
  Timer? _timer;
  int _remainingTime = 0; // Thời gian còn lại (tính bằng giây)

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    videoLength = widget.situations[currentIndex].videoLength;
    dangerSecond = widget.situations[currentIndex].dangerSecond;
    _initializeVideoPlayer();
    _initializeColorMap();
    _loadPreviousResult();
    _fetchTestTimeAndStartTimer(); // Lấy testTime từ API và khởi động đồng hồ
  }

  // Lấy testTime từ API và khởi động đồng hồ
  Future<void> _fetchTestTimeAndStartTimer() async {
    try {
      final List<TestSimulatortDetail> testDetails = await findByTestId(widget.testId);
      if (testDetails.isNotEmpty) {
        // Giả định testTime là trường trong TestSimulatorDetail (có thể cần điều chỉnh)
        int timeInMinutes = testDetails[0].testTime ?? 30; // Lấy testTime, mặc định 30 nếu null
        setState(() {
          _remainingTime = timeInMinutes * 60; // Chuyển thành giây
        });
        _startTimer(); // Khởi động đồng hồ
      } else {
        setState(() {
          _remainingTime = 30 * 60; // Mặc định 30 phút nếu không lấy được
        });
        _startTimer();
      }
    } catch (e) {
      print("Lỗi khi lấy testTime: $e");
      setState(() {
        _remainingTime = 30 * 60; // Mặc định 30 phút nếu có lỗi
      });
      _startTimer();
    }
  }

  // Hàm lấy dữ liệu từ API (dựa trên đoạn code bạn cung cấp)
  Future<List<TestSimulatortDetail>> findByTestId(int id) async {
    var response = await http.get(Uri.parse(BaseUrl.url + "testSimulatorDetails/findByTestId/" + id.toString()));
    if (response.statusCode == 200) {
      List<dynamic> res = jsonDecode(utf8.decode(response.bodyBytes));
      return res.map((e) => TestSimulatortDetail.fromMap(e)).toList();
    } else {
      throw Exception("Bad request");
    }
  }

  // Khởi động đồng hồ đếm ngược
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
        if (!_isTestFinished) {
          _finishTest(); // Tự động nộp bài khi hết thời gian
        }
      }
    });
  }

  // Định dạng thời gian mm:ss
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Hàm tải kết quả trước đó từ SharedPreferences
  Future<void> _loadPreviousResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? correct = prefs.getInt('test_${widget.testId}_correct');
    if (correct != null) {
      setState(() {
        _hasPreviousResult = true;
        _isTestFinished = false; // Khi có kết quả trước, vẫn cho phép nộp lại
      });

      // Tải danh sách điểm từng câu từ SharedPreferences
      List<String>? savedScores = prefs.getStringList('test_${widget.testId}_scores');
      if (savedScores != null) {
        for (int i = 0; i < savedScores.length; i++) {
          scores[i] = savedScores[i] == "null" ? null : int.parse(savedScores[i]);
        }
        _score = scores[currentIndex]; // Cập nhật điểm cho tình huống hiện tại
      }
    } else {
      // Nếu không có kết quả trước, đặt trạng thái ban đầu là chưa hoàn thành
      setState(() {
        _isTestFinished = false;
        _hasPreviousResult = false;
      });
    }
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
    _timer?.cancel(); // Hủy timer khi dispose
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
        return 0;
    }
  }

  void _flagCurrentPosition() {
    if (!isCheckFlag) {
      final position = _controller.value.position.inSeconds;
      final clampedPosition = position.clamp(0, videoLength - 1);
      final score = _calculateScore(clampedPosition);
      final isCriticalFailure = score == 0;

      print('Người dùng gắn cờ tại: $clampedPosition giây -> Điểm: $score');

      setState(() {
        isCheckFlag = true;
        _flaggedSecond = clampedPosition;
        _score = score;
        scores[currentIndex] = score;
        criticalFailures[currentIndex] = isCriticalFailure;
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
    _score = scores[currentIndex]; // Giữ điểm đã lưu
  }

  // Hàm chấm điểm và kết thúc bài thi
  void _finishTest() async {
    setState(() {
      _isTestFinished = true;
      _timer?.cancel(); // Dừng đồng hồ
    });

    // Tính tổng điểm
    int totalScore = 0;
    for (int i = 0; i < widget.situations.length; i++) {
      final score = scores[i] ?? 0;
      totalScore += score;
    }

    // Lưu điểm từng câu và tổng điểm vào SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> scoresToSave = List.generate(widget.situations.length, (index) {
      return scores[index]?.toString() ?? "0";
    });
    await prefs.setStringList('test_${widget.testId}_scores', scoresToSave);
    await prefs.setInt('test_${widget.testId}_totalScore', totalScore);
    await prefs.setInt('test_${widget.testId}_correct', scores.values.where((score) => score != null && score > 0).length);
    await prefs.setBool('test_${widget.testId}_hasFailedCriticalQuestion', criticalFailures.values.any((failed) => failed == true));

    // Hiển thị kết quả
    _showResultDialog(totalScore);
  }

  // Hàm làm lại bài thi
  void _restartTest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('test_${widget.testId}_scores');
    await prefs.remove('test_${widget.testId}_totalScore');
    await prefs.remove('test_${widget.testId}_correct');
    await prefs.remove('test_${widget.testId}_hasFailedCriticalQuestion');

    setState(() {
      _hasPreviousResult = false;
      _isTestFinished = false;
      currentIndex = widget.initialIndex;
      scores.clear();
      criticalFailures.clear();
      _resetVideo();
      _fetchTestTimeAndStartTimer(); // Khởi động lại đồng hồ với testTime mới
    });
  }

  // Hiển thị dialog kết quả
  void _showResultDialog(int totalScore) {
    bool isPassed = totalScore >= widget.testPassedScore;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          isPassed ? 'ĐẬU' : 'KHÔNG ĐẠT',
          style: TextStyle(
            color: isPassed ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tổng điểm: $totalScore'),
            Text('Điểm tối thiểu để đạt: ${widget.testPassedScore}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng dialog
              Navigator.pop(context); // Quay lại trang trước
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
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
            icon: (!_isTestFinished && !_hasPreviousResult) ? Icon(Icons.done_all) : Icon(Icons.refresh),
            onPressed: (!_isTestFinished && !_hasPreviousResult) ? _finishTest : _restartTest,
            tooltip: (!_isTestFinished && !_hasPreviousResult) ? 'Nộp bài' : 'Làm lại',
          ),
        ],
      ),
      body: Column(
        children: [
          // Hiển thị đồng hồ đếm ngược
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, size: 20),
                SizedBox(width: 4),
                Text(
                  _formatTime(_remainingTime),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
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
          // Nút điều khiển video
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay),
                onPressed: null, // Disable nút reload
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: _togglePlayPause,
              ),
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: null, // Disable nút menu
              ),
            ],
          ),
          // Nút điều hướng và gắn cờ
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
                            Text(
                              "Điểm của bạn: $_score",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
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