import 'package:flutter/material.dart';
import 'package:gplx/entities/Test.dart';
import 'package:gplx/models/test_api.dart';
import 'package:gplx/pages/review/review_question.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewTestListPage extends StatefulWidget {
  @override
  _ReviewTestListPageState createState() => _ReviewTestListPageState();
}

class _ReviewTestListPageState extends State<ReviewTestListPage> {
  final testAPI = TestAPI();

  List<Test> tests = [];
  List<Test> filteredTests = []; // Danh sách tests sau khi lọc
  String searchQuery = ""; // Biến lưu trữ từ khóa tìm kiếm

  @override
  void initState() {
    super.initState();
    loadTests();
  }

  // Hàm tải danh sách bài kiểm tra từ API
  Future<void> loadTests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? rankId = 2;
    if(prefs.getInt('rankID') != null){
      rankId = prefs.getInt('rankID');
      print(rankId);
    }
    try {
      final List<Test> fetchedTests =
          await testAPI.findAllByTypeAndRankId(1, rankId!);
      setState(() {
        tests = fetchedTests;
        filteredTests = tests; // Ban đầu, filteredTests bằng tests
      });
    } catch (e) {
      print("Error: ${e}");
    }
  }

  // Hàm lọc bài kiểm tra theo title
  void filterTests(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredTests =
            tests; // Nếu không có từ khóa, hiển thị tất cả bài kiểm tra
      } else {
        filteredTests = tests.where((test) {
          return test.title!.toLowerCase().contains(query.toLowerCase());
        }).toList(); // Lọc các bài kiểm tra có title chứa từ khóa
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lý thuyết GPLX 2025'),
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
              // Xử lý khi nhấn nút làm mới
              loadTests(); // Làm mới dữ liệu từ API
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) => filterTests(query),
              // Gọi hàm lọc khi nhập vào ô tìm kiếm
              decoration: InputDecoration(
                hintText: 'Tìm kiếm nội dung câu hỏi',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          // Danh sách các mục ôn tập
          Expanded(
            child: ListView.builder(
              itemCount: filteredTests.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(
                      filteredTests[index].title!,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (filteredTests[index].description!.isNotEmpty)
                          Text(
                            filteredTests[index].description!,
                            style: TextStyle(fontSize: 20),
                          ),
                        SizedBox(height: 4),
                        if (true)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: 0.0,
                                  // Giá trị tiến độ (có thể thay đổi)
                                  backgroundColor: Colors.grey[300],
                                  color: Colors.blue,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "${filteredTests[index].numberOfQuestions}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewQuestionPage(
                            categoryTitle: filteredTests[index].title!,
                            testId: filteredTests[index].id!,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
