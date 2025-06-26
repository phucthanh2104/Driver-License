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
  double itemWidth = 85.0; // Chiều rộng cố định của mỗi item
  late List<Map<String, dynamic>> questions;

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
      }
    });
  }

  void previousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        selectedAnswer = null;
        showResult = false;
      }
    });
  }

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

  // Hàm hiển thị menu khi nhấp vào icon menu
  void _showMenu() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tất cả câu hỏi'),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nút Reload
                ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('Làm mới kết quả'),
                  textColor: Colors.green,
                  onTap: () {
                    Navigator.pop(context); // Đóng dialog
                    setState(() {
                      currentQuestionIndex = 0;
                      selectedAnswer = null;
                      showResult = false;
                      questionsFuture = api.findAll(); // Refresh dữ liệu
                    });
                  },
                ),
                // Danh sách câu hỏi
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text('Câu ${index + 1}'),
                        title: Text(
                          questions[index]['question'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.pop(context); // Đóng dialog
                          setState(() {
                            currentQuestionIndex = index;
                            selectedAnswer = null;
                            showResult = false;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
              },
              child: Text('Đóng'),
            ),
          ],
        );
      },
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
            icon: Icon(Icons.menu), // Thay bằng icon menu
            onPressed: _showMenu, // Hiển thị menu khi nhấp
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
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          width: itemWidth, // Đảm bảo chiều rộng cố định
                          decoration: BoxDecoration(
                            color: currentQuestionIndex == index ? Colors.teal : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
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
              ),
              // Nội dung câu hỏi với vùng cuộn dọc
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CÂU HỎI ${currentQuestionIndex + 1}:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        currentQuestion['question'],
                        style: TextStyle(fontSize: 16),
                      ),
                      if (currentQuestion['image'] != null) ...[
                        SizedBox(height: 16),
                        Image.network(
                          currentQuestion['image'],
                          height: 100, // Điều chỉnh kích thước ảnh nếu cần
                          errorBuilder: (context, error, stackTrace) => Text(''),
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
              // Ô chứa các nút điều hướng
              Container(
                padding: const EdgeInsets.all(8.0),

                child: Row(
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
              ),
            ],
          );
        },
      ),
    );
  }
}