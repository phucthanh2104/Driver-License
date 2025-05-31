import 'package:flutter/material.dart';
import 'package:gplx/entities/TestSimulatorDetail.dart';
import 'package:gplx/entities/Test.dart';
import 'package:gplx/entities/Simulator.dart';

import 'package:gplx/models/testSimulatorDetails_api.dart';
import 'package:gplx/models/test_api.dart';
import 'package:gplx/pages/simulator/simulator_test/situation_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimulatorTestListPage extends StatefulWidget {
  const SimulatorTestListPage({super.key});

  @override
  _SimulatorTestListPageState createState() => _SimulatorTestListPageState();
}

class _SimulatorTestListPageState extends State<SimulatorTestListPage> {
  final TestAPI testAPI = TestAPI();
  final TestSimulatorDetailsAPI testSimulatorDetailsAPI = TestSimulatorDetailsAPI();
  List<Test> tests = [];
  bool isLoading = true;
  Map<int, Map<String, dynamic>> testResults = {};

  @override
  void initState() {
    super.initState();
    loadTests();
  }

  Future<void> loadTests() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int rankId = prefs.getInt('rankID') ?? 3; // Giá trị mặc định là 3 nếu không có rankID
      final List<Test> fetchedTests = await testAPI.findSimulatorByTypeAndRankId(2, rankId);
      Map<int, Map<String, dynamic>> results = {};
      for (var test in fetchedTests) {
        int? totalScore = prefs.getInt('test_${test.id}_totalScore');
        bool? hasFailedCriticalQuestion = prefs.getBool('test_${test.id}_hasFailedCriticalQuestion');
        if (totalScore != null) {
          results[test.id!] = {
            'totalScore': totalScore,
            'passedScore': test.passedScore ?? 0,
            'hasFailedCriticalQuestion': hasFailedCriticalQuestion ?? false,
          };
        }
      }

      setState(() {
        tests = fetchedTests;
        testResults = results;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading tests: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteAllResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var test in tests) {
      await prefs.remove('test_${test.id}_correct');
      await prefs.remove('test_${test.id}_wrong');
      await prefs.remove('test_${test.id}_hasFailedCriticalQuestion');
      await prefs.remove('test_${test.id}_answers');
      await prefs.remove('test_${test.id}_scores'); // Xóa key từ SituationDetailPage
      await prefs.remove('test_${test.id}_totalScore'); // Xóa key từ SituationDetailPage
    }
    await loadTests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách đề thi mô phỏng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteAllResults,
            tooltip: 'Xóa dữ liệu bài thi',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tests.isEmpty
          ? const Center(child: Text('Chỉ dành cho từ hạng B trở lên, vui lòng chọn đúng hạng.'))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1.5,
          ),
          itemCount: tests.length,
          itemBuilder: (context, index) {
            final test = tests[index];
            int totalScore = testResults[test.id]?['totalScore'] ?? 0;
            int passedScore = testResults[test.id]?['passedScore'] ?? test.passedScore ?? 0;
            bool hasFailedCriticalQuestion = testResults[test.id]?['hasFailedCriticalQuestion'] ?? false;

            bool hasDoneTest = testResults.containsKey(test.id);
            bool hasPassed = hasDoneTest && !hasFailedCriticalQuestion && totalScore >= passedScore;

            return Card(
              color: hasDoneTest
                  ? (hasPassed ? Colors.green[400] : Colors.red[400])
                  : Colors.grey[300],
              child: InkWell(
                onTap: () async {
                  try {
                    // Lấy danh sách TestSimulatorDetail từ API dựa trên testId
                    final List<TestSimulatortDetail> testSimulatorDetails =
                    await testSimulatorDetailsAPI.findByTestId(test.id!);

                    // Ánh xạ sang danh sách Simulator
                    final List<Simulator> situations = testSimulatorDetails
                        .where((detail) => detail.simulator != null)
                        .map((detail) => detail.simulator!)
                        .toList();

                    // Kiểm tra nếu danh sách situations rỗng
                    if (situations.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Không có tình huống nào cho bài thi này.')),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SituationDetailPage(
                          situations: situations,
                          initialIndex: 0, // Bắt đầu từ tình huống đầu tiên
                          testId: test.id!, // Truyền testId
                          testPassedScore: test.passedScore!, // Truyền testPassedScore
                        ),
                      ),
                    ).then((_) => loadTests());
                  } catch (e) {
                    print("Error fetching situations: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi khi tải danh sách tình huống: $e')),
                    );
                  }
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
                      textAlign: TextAlign.center,
                    ),
                    if (hasDoneTest) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Điểm: $totalScore / $passedScore',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 8),
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