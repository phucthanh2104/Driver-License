import 'package:flutter/material.dart';
import 'package:gplx/models/base_url.dart';
import 'package:gplx/models/question_api.dart'; // Import QuestionAPI
import 'package:gplx/entities/Question.dart'; // Giả sử bạn đã có model Question

class ReviewAllQuestionPage extends StatefulWidget {
  final String categoryTitle; // Tiêu đề của bộ đề

  ReviewAllQuestionPage({
    required this.categoryTitle,
  });

  @override
  _ReviewAllQuestionPageState createState() => _ReviewAllQuestionPageState();
}

class _ReviewAllQuestionPageState extends State<ReviewAllQuestionPage> {
  int currentQuestionIndex = 0; // Chỉ số câu hỏi hiện tại
  int? selectedAnswer; // Đáp án được chọn
  bool showResult = false; // Hiển thị kết quả sau khi kiểm tra
  late Future<List<Question>> questionsFuture; // Future để gọi API
  final QuestionAPI api = QuestionAPI(); // Khởi tạo QuestionAPI
  late ScrollController _scrollController; // Controller để điều khiển thanh trượt

  @override
  void initState() {
    super.initState();
    // Gọi API để lấy toàn bộ câu hỏi
    questionsFuture = api.findAll();
    // Khởi tạo ScrollController
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Giải phóng ScrollController
    super.dispose();
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
        selectedAnswer = null;
        showResult = false;
        _scrollToCurrentQuestion(); // Cuộn đến câu hỏi hiện tại
      }
    });
  }

  void previousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        selectedAnswer = null;
        showResult = false;
        _scrollToCurrentQuestion(); // Cuộn đến câu hỏi hiện tại
      }
    });
  }

  // Hàm cuộn đến câu hỏi hiện tại
  void _scrollToCurrentQuestion() {
    if (_scrollController.hasClients) {
      final itemWidth = 80.0; // Chiều rộng của mỗi item (ước lượng, có thể điều chỉnh)
      final scrollPosition = currentQuestionIndex * itemWidth;
      _scrollController.animateTo(
        scrollPosition,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Danh sách câu hỏi sẽ được tạo từ dữ liệu API
  late List<Map<String, dynamic>> questions;

  // Chuyển đổi Question thành định dạng của questions
  List<Map<String, dynamic>> convertQuestionsToMap(List<Question> questionList) {
    return questionList.map((question) {
      return {
        'question': question.content ?? 'Câu hỏi không có nội dung',
        'answers': question.answers?.map((answer) => answer.content ?? '').toList() ?? [],
        'correctAnswer': question.answers?.indexWhere((answer) => answer.correct ?? false) ?? 0,
        'explanation': question.explain ?? 'Không có giải thích',
        'image': question.image != null ? BaseUrl.imageUrl + question.image! : null, // Xử lý trường image
      };
    }).toList();
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
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                currentQuestionIndex = 0;
                selectedAnswer = null;
                showResult = false;
                questionsFuture = api.findAll(); // Refresh dữ liệu
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Question>>(
        future: questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có câu hỏi nào để hiển thị.'));
          }

          // Khi dữ liệu đã sẵn sàng, chuyển đổi thành danh sách questions
          questions = convertQuestionsToMap(snapshot.data!);
          final currentQuestion = questions[currentQuestionIndex];

          return Column(
            children: [
              // Thanh trượt ngang cho danh sách câu hỏi
              Container(
                height: 50, // Chiều cao của thanh trượt
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
                            selectedAnswer = null;
                            showResult = false;
                            _scrollToCurrentQuestion(); // Cuộn đến câu hỏi được chọn
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: currentQuestionIndex == index ? Colors.teal : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Câu ${index + 1}',
                            style: TextStyle(
                              color: currentQuestionIndex == index ? Colors.white : Colors.black,
                            ),
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
                          height: 100, // Điều chỉnh kích thước ảnh nếu cần
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
                              color: showResult && index == currentQuestion['correctAnswer']
                                  ? Colors.green
                                  : (showResult &&
                                  selectedAnswer == index &&
                                  selectedAnswer != currentQuestion['correctAnswer']
                                  ? Colors.red
                                  : Colors.black),
                            ),
                          ),
                          value: index,
                          groupValue: selectedAnswer,
                          onChanged: (value) {
                            setState(() {
                              selectedAnswer = value;
                              showResult = false;
                            });
                          },
                        ),
                      ),
                      if (showResult && selectedAnswer != null) ...[
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(8),
                          color: selectedAnswer == currentQuestion['correctAnswer']
                              ? Colors.green[100]
                              : Colors.red[100],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedAnswer == currentQuestion['correctAnswer']
                                    ? 'Đáp án đúng!'
                                    : 'Đáp án sai!',
                                style: TextStyle(
                                  color: selectedAnswer == currentQuestion['correctAnswer']
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
            onPressed: previousQuestion,
            child: Icon(Icons.arrow_left),
          ),
          FloatingActionButton(
            heroTag: 'check',
            onPressed: selectedAnswer != null ? checkAnswer : null,
            child: Icon(Icons.check),
            backgroundColor: selectedAnswer != null ? Colors.green : Colors.grey,
          ),
          FloatingActionButton(
            heroTag: 'next',
            onPressed: nextQuestion,
            child: Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }
}