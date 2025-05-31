import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gplx/models/base_url.dart';
import 'package:gplx/models/testDetails_api.dart';
import 'package:gplx/entities/TestDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestQuestionPage extends StatefulWidget {
  final String categoryTitle; // Tiêu đề của bài thi
  final int testId; // ID của bài test để gọi API

  TestQuestionPage({
    required this.categoryTitle,
    required this.testId,
  });

  @override
  _TestQuestionPageState createState() => _TestQuestionPageState();
}

class _TestQuestionPageState extends State<TestQuestionPage> {
  int currentQuestionIndex = 0; // Chỉ số câu hỏi hiện tại
  List<int?> selectedAnswers = []; // Danh sách đáp án đã chọn cho từng câu hỏi
  bool showResult = false; // Hiển thị kết quả sau khi kiểm tra từng câu
  late Future<List<TestDetail>> testDetailsFuture; // Future để gọi API
  final TestDetailsAPI api = TestDetailsAPI();
  late ScrollController _scrollController; // Controller để điều khiển thanh trượt
  List<Map<String, dynamic>> questions = []; // Danh sách câu hỏi
  Timer? _timer; // Timer cho đồng hồ đếm ngược
  int _remainingTime = 0; // Thời gian còn lại (tính bằng giây)
  bool _isTestFinished = false; // Trạng thái bài thi đã kết thúc
  int _correctAnswers = 0; // Số câu trả lời đúng
  int _wrongAnswers = 0; // Số câu trả lời sai
  bool _hasFailedCriticalQuestion = false; // Có câu điểm liệt sai không
  bool _hasPreviousResult = false; // Kiểm tra xem bài thi đã làm trước đó chưa
  int? _passedScore; // Điểm tối thiểu để đạt

  @override
  void initState() {
    super.initState();
    // Gọi API để lấy danh sách TestDetail
    testDetailsFuture = api.findByTestId(widget.testId);
    // Khởi tạo ScrollController
    _scrollController = ScrollController();
    // Kiểm tra xem bài thi đã được làm trước đó chưa
    _loadPreviousResult();
  }

  // Hàm tải kết quả trước đó từ SharedPreferences
  Future<void> _loadPreviousResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? correct = prefs.getInt('test_${widget.testId}_correct');
    if (correct != null) {
      // Nếu đã có kết quả trước đó
      setState(() {
        _hasPreviousResult = true;
        _isTestFinished = false; // Đánh dấu bài thi đã hoàn thành
      });

      // Tải danh sách đáp án đã chọn từ SharedPreferences
      List<String>? savedAnswers = prefs.getStringList('test_${widget.testId}_answers');
      if (savedAnswers != null) {
        setState(() {
          selectedAnswers = savedAnswers.map((answer) => answer == "null" ? null : int.parse(answer)).toList();
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel(); // Hủy timer khi dispose
    super.dispose();
  }

  // Hàm khởi động đồng hồ đếm ngược
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
        _finishTest(); // Kết thúc bài thi khi hết thời gian
      }
    });
  }

  // Hàm định dạng thời gian (mm:ss)
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void checkAnswer() {
    setState(() {
      showResult = true;
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        showResult = false;
        _scrollToCurrentQuestion();
      }
    });
  }

  void previousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        showResult = false;
        _scrollToCurrentQuestion();
      }
    });
  }

  // Hàm cuộn đến câu hỏi hiện tại
  void _scrollToCurrentQuestion() {
    if (_scrollController.hasClients) {
      final itemWidth = 80.0; // Chiều rộng của mỗi item (ước lượng)
      final scrollPosition = currentQuestionIndex * itemWidth;
      _scrollController.animateTo(
        scrollPosition,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Chuyển đổi TestDetail thành định dạng của questions
  List<Map<String, dynamic>> convertTestDetailsToQuestions(List<TestDetail> testDetails) {
    return testDetails.asMap().entries.map((entry) {
      final index = entry.key;
      final testDetail = entry.value;
      final question = testDetail.question;
      return {
        'question': question?.content ?? 'Câu hỏi không có nội dung',
        'answers': question?.answers?.map((answer) => answer.content ?? '').toList() ?? [],
        'correctAnswer': question?.answers?.indexWhere((answer) => answer.correct ?? false) ?? 0,
        'explanation': question?.explain ?? 'Không có giải thích',
        'image': question?.image != null ? BaseUrl.imageUrl + question!.image! : null,
        'isCritical': question?.failed ?? false, // Câu điểm liệt (failed = true)
        'index': index, // Lưu chỉ số để theo dõi
      };
    }).toList();
  }

  // Hàm chấm điểm và kết thúc bài thi
  // Hàm chấm điểm và kết thúc bài thi
  void _finishTest() async {
    setState(() {
      _isTestFinished = true;
      _timer?.cancel(); // Dừng đồng hồ

      // Tính điểm
      _correctAnswers = 0;
      _wrongAnswers = 0;
      _hasFailedCriticalQuestion = false;

      for (int i = 0; i < questions.length; i++) {
        if (selectedAnswers[i] == null) continue; // Bỏ qua câu chưa làm
        if (selectedAnswers[i] == questions[i]['correctAnswer']) {
          _correctAnswers++;
        } else {
          _wrongAnswers++;
          if (questions[i]['isCritical']) {
            _hasFailedCriticalQuestion = true; // Sai câu điểm liệt
          }
        }
      }
    });

    // Lưu kết quả vào SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('test_${widget.testId}_correct', _correctAnswers);

    await prefs.setInt('test_${widget.testId}_wrong', _wrongAnswers);
    await prefs.setBool('test_${widget.testId}_hasFailedCriticalQuestion', _hasFailedCriticalQuestion); // Lưu hasFailedCriticalQuestion
    // Lưu danh sách đáp án đã chọn
    List<String> answersToSave = selectedAnswers.map((answer) => answer?.toString() ?? "null").toList();
    await prefs.setStringList('test_${widget.testId}_answers', answersToSave);

    // Hiển thị kết quả
    _showResultDialog();
  }

  // Hàm làm lại bài thi
  // Hàm làm lại bài thi
  void _restartTest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Xóa dữ liệu cũ trong SharedPreferences
    await prefs.remove('test_${widget.testId}_correct');
    await prefs.remove('test_${widget.testId}_wrong');
    await prefs.remove('test_${widget.testId}_hasFailedCriticalQuestion'); // Xóa hasFailedCriticalQuestion
    await prefs.remove('test_${widget.testId}_answers');

    setState(() {
      _hasPreviousResult = false;
      _isTestFinished = false;
      currentQuestionIndex = 0;
      selectedAnswers = List<int?>.filled(questions.length, null);
      showResult = false;
      _remainingTime = (questions.isNotEmpty ? (questions[0]['time'] ?? 30) : 30) * 60; // Reset thời gian
      _startTimer();
    });
  }

  // Hiển thị dialog kết quả
  void _showResultDialog() {
    bool isPassed = !_hasFailedCriticalQuestion && _correctAnswers >= (_passedScore ?? 21);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          _hasFailedCriticalQuestion
              ? 'KHÔNG ĐẠT: Câu điểm liệt trúng!'
              : (isPassed ? 'ĐẠT' : 'KHÔNG ĐẠT: Không đủ điểm!'),
          style: TextStyle(
            color: _hasFailedCriticalQuestion || !isPassed ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 30),
                    Text('$_correctAnswers', style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.cancel, color: Colors.red, size: 30),
                    Text('$_wrongAnswers', style: TextStyle(fontSize: 20)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.warning, color: Colors.yellow, size: 30),
                    Text('${questions.length - _correctAnswers - _wrongAnswers}', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('Tổng số câu: ${questions.length}'),
            Text('Điểm tối thiểu để đạt: ${_passedScore ?? 21}'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: _hasPreviousResult ? Icon(Icons.refresh) : Icon(Icons.done_all),
            onPressed: _hasPreviousResult ? _restartTest : (_isTestFinished ? null : _finishTest),
            tooltip: _hasPreviousResult ? 'Làm lại' : 'Chấm điểm',
          ),
        ],
      ),
      body: FutureBuilder<List<TestDetail>>(
        future: testDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có câu hỏi nào để hiển thị.'));
          }

          // Khi dữ liệu đã sẵn sàng, chuyển đổi thành danh sách questions
          questions = convertTestDetailsToQuestions(snapshot.data!);

          // Lấy passedScore từ TestDetail đầu tiên (giả sử tất cả TestDetail có cùng passedScore)
          _passedScore = snapshot.data!.isNotEmpty ? snapshot.data![0].passedScore : 21;

          // Khởi tạo selectedAnswers và timer nếu chưa có kết quả trước đó
          if (!_hasPreviousResult && selectedAnswers.isEmpty) {
            selectedAnswers = List<int?>.filled(questions.length, null);
            int timeInMinutes = snapshot.data!.isNotEmpty ? (snapshot.data![0].time ?? 30) : 30;
            _remainingTime = timeInMinutes * 60; // Chuyển phút thành giây
            _startTimer();
          }

          // Kiểm tra nếu questions rỗng
          if (questions.isEmpty) {
            return Center(child: Text('Không có câu hỏi nào để hiển thị.'));
          }

          final currentQuestion = questions[currentQuestionIndex];

          return Column(
            children: [
              // Thanh trạng thái bài thi
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.timer, size: 20),
                        SizedBox(width: 4),
                        Text(
                          _formatTime(_remainingTime),
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 20),
                        SizedBox(width: 4),
                        Text(
                          '${selectedAnswers.where((answer) => answer != null).length}/${questions.length}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.red, size: 20),
                        SizedBox(width: 4),
                        Text(
                          'Câu ${currentQuestionIndex + 1}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Thanh trượt ngang cho danh sách câu hỏi
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      questions.length,
                          (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            currentQuestionIndex = index;
                            showResult = false;
                            _scrollToCurrentQuestion();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: currentQuestionIndex == index
                                ? Colors.teal
                                : (selectedAnswers[index] != null ? Colors.green[200] : Colors.grey[300]),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Câu ${index + 1}',
                                style: TextStyle(
                                  color: currentQuestionIndex == index ? Colors.white : Colors.black,
                                ),
                              ),
                              if (selectedAnswers[index] != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Icon(
                                    _hasPreviousResult
                                        ? (selectedAnswers[index] == questions[index]['correctAnswer']
                                        ? Icons.check_circle
                                        : Icons.cancel)
                                        : Icons.check,
                                    color: _hasPreviousResult
                                        ? (selectedAnswers[index] == questions[index]['correctAnswer']
                                        ? Colors.green
                                        : Colors.red)
                                        : Colors.green,
                                    size: 16,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Nội dung câu hỏi
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CÂU HỎI ${currentQuestionIndex + 1}:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        currentQuestion['question'],
                        style: TextStyle(fontSize: 18),
                      ),
                      if (currentQuestion['image'] != null) ...[
                        SizedBox(height: 16),
                        Image.network(
                          currentQuestion['image'],
                          height: 100,
                          errorBuilder: (context, error, stackTrace) => Text('Không thể tải hình ảnh'),
                        ),
                      ],
                      SizedBox(height: 16),
                      ...List.generate(
                        currentQuestion['answers'].length,
                            (index) => RadioListTile<int>(
                          title: Text(
                            '${index + 1}. ${currentQuestion['answers'][index]}',
                            style: TextStyle(
                              color: _hasPreviousResult
                                  ? (index == currentQuestion['correctAnswer']
                                  ? Colors.green
                                  : (selectedAnswers[currentQuestionIndex] == index &&
                                  selectedAnswers[currentQuestionIndex] != currentQuestion['correctAnswer']
                                  ? Colors.red
                                  : Colors.black))
                                  : (showResult && index == currentQuestion['correctAnswer']
                                  ? Colors.green
                                  : (showResult &&
                                  selectedAnswers[currentQuestionIndex] == index &&
                                  selectedAnswers[currentQuestionIndex] != currentQuestion['correctAnswer']
                                  ? Colors.red
                                  : Colors.black)),
                            ),
                          ),
                          value: index,
                          groupValue: selectedAnswers[currentQuestionIndex],
                          onChanged: _isTestFinished
                              ? null
                              : (value) {
                            setState(() {
                              selectedAnswers[currentQuestionIndex] = value;
                              showResult = false;
                            });
                          },
                        ),
                      ),
                      if (_hasPreviousResult || (showResult && selectedAnswers[currentQuestionIndex] != null)) ...[
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(8),
                          color: selectedAnswers[currentQuestionIndex] == currentQuestion['correctAnswer']
                              ? Colors.green[100]
                              : Colors.red[100],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedAnswers[currentQuestionIndex] == currentQuestion['correctAnswer']
                                    ? 'Đáp án đúng!'
                                    : 'Đáp án sai!',
                                style: TextStyle(
                                  color: selectedAnswers[currentQuestionIndex] == currentQuestion['correctAnswer']
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Giải thích đáp án:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(currentQuestion['explanation']),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            heroTag: 'previous',
            onPressed: _isTestFinished ? null : previousQuestion,
            child: Icon(Icons.arrow_left),
          ),
          FloatingActionButton(
            heroTag: 'next',
            onPressed: _isTestFinished ? null : nextQuestion,
            child: Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }
}