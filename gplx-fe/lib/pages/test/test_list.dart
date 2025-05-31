import 'package:flutter/material.dart';
import 'package:gplx/entities/Test.dart';
import 'package:gplx/models/test_api.dart';
import 'package:gplx/pages/test/test_question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestListPage extends StatefulWidget {
  @override
  _TestListPageState createState() => _TestListPageState();
}

class _TestListPageState extends State<TestListPage> {
  final TestAPI testAPI = TestAPI();

  List<Test> tests = [];
  bool isLoading = true; // Trạng thái đang tải dữ liệu
  Map<int, Map<String, dynamic>> testResults = {}; // Lưu kết quả của từng bài thi

  @override
  void initState() {
    super.initState();
    loadTests();
  }

  // Hàm tải danh sách bài kiểm tra từ API với type = 2
  Future<void> loadTests() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? rankId = 2; // Giá trị mặc định
    if (prefs.getInt('rankID') != null) {
      rankId = prefs.getInt('rankID');
      print("Rank ID: $rankId");
    }

    try {

      final List<Test> fetchedTests = await testAPI.findAllByTypeAndRankId(2, rankId!);
      // Tải kết quả từ SharedPreferences
      Map<int, Map<String, dynamic>> results = {};
      for (var test in fetchedTests) {
        int? correct = prefs.getInt('test_${test.id}_correct');
        int? wrong = prefs.getInt('test_${test.id}_wrong');
        bool? hasFailedCriticalQuestion = prefs.getBool('test_${test.id}_hasFailedCriticalQuestion');
        if (correct != null && wrong != null && hasFailedCriticalQuestion != null) {
          results[test.id!] = {
            'correct': correct,
            'wrong': wrong,
            'hasFailedCriticalQuestion': hasFailedCriticalQuestion,
          };
        }
      }

      setState(() {
        tests = fetchedTests;
        testResults = results;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Hàm xóa toàn bộ dữ liệu bài thi đã làm
  Future<void> _deleteAllResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var test in tests) {
      await prefs.remove('test_${test.id}_correct');
      await prefs.remove('test_${test.id}_wrong');
      await prefs.remove('test_${test.id}_hasFailedCriticalQuestion');
      await prefs.remove('test_${test.id}_answers');
    }
    // Làm mới danh sách
    await loadTests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ôn tập câu hỏi'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteAllResults, // Nút xóa dữ liệu
            tooltip: 'Xóa dữ liệu bài thi',
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Hiển thị khi đang tải
          : tests.isEmpty
          ? Center(child: Text('Không có đề thi nào để hiển thị.'))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cột
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1.5, // Tỷ lệ chiều rộng/chiều cao của ô
          ),
          itemCount: tests.length,
          itemBuilder: (context, index) {
            final test = tests[index];
            // Lấy kết quả từ testResults
            int correct = testResults[test.id]?['correct'] ?? 0;
            int wrong = testResults[test.id]?['wrong'] ?? 0;
            bool hasFailedCriticalQuestion =
                testResults[test.id]?['hasFailedCriticalQuestion'] ?? false;


            bool hasDoneTest = correct > 0 || wrong > 0;
            print("critical: " + hasFailedCriticalQuestion.toString());
            print("correct: " + correct.toString());

            bool hasPassed = hasDoneTest && !hasFailedCriticalQuestion && correct >= test.passedScore!;
            print(hasDoneTest);
            print(hasPassed);
                      return Card(
              color: hasDoneTest
                  ? (hasPassed ? Colors.green[400] : Colors.red[400]) // Màu xanh nếu đạt, đỏ nếu không đạt
                  : Colors.grey[300], // Nếu chưa làm, màu xám
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TestQuestionPage(
                        categoryTitle: test.title ?? 'Đề thi không tên',
                        testId: test.id!,
                      ),
                    ),
                  ).then((_) {
                    // Làm mới danh sách khi quay lại từ TestQuestionPage
                    loadTests();
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      test.title ?? 'Đề thi ${index + 1}',
                      style: TextStyle(
                        color: hasDoneTest ? Colors.white : Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (hasDoneTest) ...[
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 20),
                          SizedBox(width: 4),
                          Text(
                            '$correct',
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(width: 16),
                          Icon(Icons.cancel, color: Colors.red, size: 20),
                          SizedBox(width: 4),
                          Text(
                            '$wrong',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 8),
                    Text(
                      'Số câu: ${test.numberOfQuestions ?? 0}',
                      style: TextStyle(
                        color: hasDoneTest ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}