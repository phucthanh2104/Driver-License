import 'package:flutter/material.dart';
import 'package:gplx/entities/Answer.dart';
import 'package:gplx/entities/Question.dart';
import 'package:gplx/models/base_url.dart';
import 'package:gplx/models/question_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewFailedListPage extends StatefulWidget {
  @override
  _ReviewFailedListPageState createState() => _ReviewFailedListPageState();
}

class _ReviewFailedListPageState extends State<ReviewFailedListPage> {
  final QuestionAPI questionAPI = QuestionAPI();
  late Future<List<Question>> questionsFuture;
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  bool showResult = false;
  late ScrollController _scrollController;
  List<Map<String, dynamic>> questions = [];
  String searchQuery = "";
  List<Map<String, dynamic>> filteredQuestions = [];
  String rankTitle = 'Câu điểm liệt GPLX 2025'; // Giá trị mặc định

  @override
  void initState() {
    super.initState();
    _loadRankTitle(); // Tải tiêu đề rank khi khởi tạo
    questionsFuture = loadFailedQuestions();
    _scrollController = ScrollController();
  }

  // Lấy rankId và cập nhật tiêu đề
  Future<void> _loadRankTitle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? rankId = prefs.getInt('rankID');
    setState(() {
      rankTitle = _getRankTitle(rankId); // Cập nhật tiêu đề dựa trên rankId
    });
  }

  // Hàm ánh xạ rankId thành tên rank
  String _getRankTitle(int? rankId) {
    switch (rankId) {
      case 1:
        return 'Câu điểm liệt GPLX - Hạng A1';
      case 2:
        return 'Câu điểm liệt GPLX - Hạng A';
      case 3:
        return 'Câu điểm liệt GPLX - Hạng B';
      case 4:
        return 'Câu điểm liệt GPLX - Hạng C1';
      case 5:
        return 'Câu điểm liệt GPLX - Hạng C';
      case 6:
        return 'Câu điểm liệt GPLX - Hạng D1';
      case 7:
        return 'Câu điểm liệt GPLX - Hạng D2';
      case 8:
        return 'Câu điểm liệt GPLX - Hạng D';
      case 9:
        return 'Câu điểm liệt GPLX - Hạng BE';
      case 10:
        return 'Câu điểm liệt GPLX - Hạng C1E';
      case 11:
        return 'Câu điểm liệt GPLX - Hạng CE';
      case 12:
        return 'Câu điểm liệt GPLX - Hạng D1E';
      case 13:
        return 'Câu điểm liệt GPLX - Hạng D2E';
      case 14:
        return 'Câu điểm liệt GPLX - Hạng DE';
      default:
        return 'Câu điểm liệt GPLX 2025'; // Giá trị mặc định nếu rankId không khớp
    }
  }

  // Tải danh sách câu điểm liệt dựa trên rankId
  Future<List<Question>> loadFailedQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? rankId = prefs.getInt('rankID');
    if (rankId == 1 || rankId == 2) {
      return await questionAPI.findAllFailedByRankA();
    } else {
      return await questionAPI.findAllFailed();
    }
  }

  // Chuyển đổi Question thành định dạng của questions
  List<Map<String, dynamic>> convertQuestionsToMap(List<Question> questions) {
    return questions.map((question) {
      return {
        'question': question.content ?? 'Câu hỏi không có nội dung',
        'answers': question.answers?.map((answer) => answer.content ?? '').toList() ?? [],
        'correctAnswer': question.answers?.indexWhere((answer) => answer.correct ?? false) ?? 0,
        'explanation': question.explain ?? 'Không có giải thích',
        'image': question.image != null && question.image!.isNotEmpty ? BaseUrl.imageUrl + question.image! : null,
      };
    }).toList();
  }

  void checkAnswer() {
    setState(() {
      showResult = true;
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < filteredQuestions.length - 1) {
        currentQuestionIndex++;
        selectedAnswer = null;
        showResult = false;
        _scrollToCurrentQuestion();
      }
    });
  }

  void previousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        selectedAnswer = null;
        showResult = false;
        _scrollToCurrentQuestion();
      }
    });
  }

  void _scrollToCurrentQuestion() {
    if (_scrollController.hasClients) {
      final itemWidth = 80.0;
      final scrollPosition = currentQuestionIndex * itemWidth;
      _scrollController.animateTo(
        scrollPosition,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Lọc câu hỏi theo nội dung
  void filterQuestions(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredQuestions = List.from(questions);
      } else {
        filteredQuestions = questions.where((question) {
          return question['question'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      currentQuestionIndex = 0;
      selectedAnswer = null;
      showResult = false;
      _scrollToCurrentQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(rankTitle), // Sử dụng tiêu đề động từ rankTitle
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
                questionsFuture = loadFailedQuestions();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     onChanged: (query) => filterQuestions(query),
          //     decoration: InputDecoration(
          //       hintText: 'Tìm kiếm nội dung câu hỏi',
          //       prefixIcon: Icon(Icons.search),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(8.0),
          //       ),
          //     ),
          //   ),
          // ),
          // Nội dung câu hỏi
          Expanded(
            child: FutureBuilder<List<Question>>(
              future: questionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Không có câu hỏi nào để hiển thị.'));
                }

                questions = convertQuestionsToMap(snapshot.data!);
                filteredQuestions = searchQuery.isEmpty
                    ? List.from(questions)
                    : questions.where((question) {
                  return question['question'].toLowerCase().contains(searchQuery.toLowerCase());
                }).toList();

                if (filteredQuestions.isEmpty) {
                  return Center(child: Text('Không tìm thấy câu hỏi phù hợp.'));
                }

                final currentQuestion = filteredQuestions[currentQuestionIndex];

                return Column(
                  children: [
                    // Thanh trượt ngang
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            filteredQuestions.length,
                                (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentQuestionIndex = index;
                                  selectedAnswer = null;
                                  showResult = false;
                                  _scrollToCurrentQuestion();
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
          ),
        ],
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