import 'package:flutter/material.dart';
import 'package:gplx/entities/Test.dart';
import 'package:gplx/models/test_api.dart';
import 'package:gplx/pages/test/test_random_question.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math'; // Import để sử dụng Random


class TestRanDomListPage extends StatefulWidget {
  @override
  _TestRanDomListPageState createState() => _TestRanDomListPageState();
}

class _TestRanDomListPageState extends State<TestRanDomListPage> {
  final TestAPI testAPI = TestAPI();
  List<Test> tests = [];
  bool isLoading = true; // Trạng thái đang tải dữ liệu

  @override
  void initState() {
    super.initState();
    loadAndNavigateToRandomTest();
  }

  // Hàm tải danh sách bài kiểm tra và điều hướng đến một bài kiểm tra ngẫu nhiên
  Future<void> loadAndNavigateToRandomTest() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? rankId = 3; // Giá trị mặc định
    if (prefs.getInt('rankID') != null) {
      rankId = prefs.getInt('rankID');
      print("Rank ID: $rankId");
    }

    try {
      // Lấy danh sách đề thi từ API
      final List<Test> fetchedTests = await testAPI.findAllByTypeAndRankId(2, rankId!);

      // Xóa toàn bộ dữ liệu SharedPreferences của các bài thi ngẫu nhiên
      for (var test in fetchedTests) {
        await prefs.remove('test_${test.id}_correct');
        await prefs.remove('test_${test.id}_wrong');
        await prefs.remove('test_${test.id}_hasFailedCriticalQuestion');
        await prefs.remove('test_${test.id}_answers');
      }

      setState(() {
        tests = fetchedTests;
        isLoading = false;
      });

      // Chọn ngẫu nhiên một bài kiểm tra
      if (tests.isNotEmpty) {
        final random = Random();
        final randomTest = tests[random.nextInt(tests.length)]; // Chọn ngẫu nhiên một đề thi
        // Điều hướng đến TestRandomQuestionPage với testId ngẫu nhiên
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestRandomQuestionPage(
              categoryTitle: randomTest.title ?? 'Đề thi ngẫu nhiên',
              testId: randomTest.id!,
            ),
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Hàm xóa toàn bộ dữ liệu bài thi đã làm
  Future<void> _deleteAllResults() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xóa dữ liệu bài thi'),
        content: Text('Bạn có chắc muốn xóa toàn bộ kết quả bài thi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      for (var test in tests) {
        await prefs.remove('test_${test.id}_correct');
        await prefs.remove('test_${test.id}_wrong');
        await prefs.remove('test_${test.id}_hasFailedCriticalQuestion');
        await prefs.remove('test_${test.id}_answers');
      }
      await loadAndNavigateToRandomTest();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đề ngẫu nhiên'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popUntil(context, ModalRoute.withName('/')); // Quay về dashboard
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
          : Center(child: Text('Đang chuyển hướng đến đề thi ngẫu nhiên...')),
    );
  }
}