import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gplx/entities/Simulator.dart';
import 'package:gplx/models/simulator_api.dart';
import 'package:gplx/models/testSimulatorDetails_api.dart';
import 'package:gplx/pages/dashboard.dart';
import 'package:gplx/pages/simulator/simulator_review/simulator_review_list.dart';
import 'package:gplx/pages/simulator/simulator_review/situation_all_detail.dart';
import 'package:gplx/pages/simulator/simulator_test/situation_detail.dart';
import 'package:gplx/pages/simulator/simulator_test/simulator_test_list.dart';
import 'package:gplx/pages/simulator/simulator_test/situation_random_detail.dart';
import 'package:gplx/pages/test/test_list.dart';
import 'package:gplx/entities/Test.dart'; // Import Test
import 'package:gplx/entities/TestSimulatorDetail.dart'; // Import TestSimulatorDetail
import 'package:gplx/models/test_api.dart'; // Import TestAPI


class SimulationDashboardPage extends StatefulWidget {
  @override
  _SimulationDashboardPageState createState() => _SimulationDashboardPageState();
}

class _SimulationDashboardPageState extends State<SimulationDashboardPage> {
  final SimulatorAPI _simulatorAPI = SimulatorAPI();
  final TestAPI _testAPI = TestAPI(); // Thêm instance của TestAPI
  final TestSimulatorDetailsAPI _testSimulatorDetailsAPI = TestSimulatorDetailsAPI(); // Thêm instance của TestSimulatorDetailsAPI
  List<Simulator> _situations = [];
  List<Test> _tests = []; // Danh sách các Test
  List<TestSimulatortDetail> _testSimulatorDetails = []; // Danh sách TestSimulatorDetail
  bool _isLoading = true;
  String? _errorMessage;

  // Danh sách các mục trong trang mô phỏng
  final List<Map<String, dynamic>> simulationItems = [
    {
      'title': 'Ôn thi',
      'icon': Icons.book,
      'color': Colors.blue,
    },
    {
      'title': 'Thi thử',
      'icon': Icons.person,
      'color': Colors.teal,
    },
    {
      'title': 'Toàn bộ tình huống',
      'icon': Icons.star,
      'color': Colors.purple,
    },
    {
      'title': 'Bộ tình huống ngẫu nhiên',
      'icon': Icons.bookmark,
      'color': Colors.red,
    },
    {
      'title': 'Trở về lý thuyết',
      'icon': Icons.list_alt,
      'color': Colors.white,
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchSituations();
    _fetchTests(); // Gọi hàm để lấy danh sách Test
  }

  Future<void> _fetchSituations() async {
    try {
      final situations = await _simulatorAPI.findAll();
      setState(() {
        _situations = situations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Không thể tải danh sách tình huống: $e';
      });
    }
  }

  Future<void> _fetchTests() async {
    try {
      final tests = await _testAPI.findAllSimulatorTest();
      setState(() {
        _tests = tests;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải danh sách bài kiểm tra: $e';
      });
    }
  }

  Future<List<TestSimulatortDetail>> _fetchTestSimulatorDetails(int testId) async {
    try {
      final details = await _testSimulatorDetailsAPI.findByTestId(testId);
      return details;
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể tải chi tiết bài kiểm tra: $e';
      });
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ôn thi 120 THGT'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Mở cài đặt')),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: simulationItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: simulationItems[index]['color'],
                    child: InkWell(
                      onTap: () async {
                        if (simulationItems[index]['title'] == 'Ôn thi') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SimulatorReviewListPage(),
                            ),
                          );
                        } else if (simulationItems[index]['title'] == 'Trở về lý thuyết') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardPage(),
                            ),
                          );
                        } else if (simulationItems[index]['title'] == 'Bộ tình huống ngẫu nhiên') {
                          if (_tests.isNotEmpty) {
                            // Chọn ngẫu nhiên một testId từ danh sách _tests
                            final random = Random();
                            final randomTestId = _tests[random.nextInt(_tests.length)].id!;
                            // Lấy danh sách TestSimulatorDetail dựa trên testId ngẫu nhiên
                            final details = await _fetchTestSimulatorDetails(randomTestId);
                            if (details.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SituationRandomDetailPage(
                                    situations: details.map((detail) => detail.simulator!).toList(), // Chuyển đổi sang danh sách Simulator
                                    initialIndex: 0,
                                    testId: randomTestId,
                                    testPassedScore: 0, // Có thể lấy từ Test nếu cần
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Không có chi tiết cho bộ đề ngẫu nhiên'),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Không có bài kiểm tra nào để hiển thị'),
                              ),
                            );
                          }
                        } else if (simulationItems[index]['title'] == 'Toàn bộ tình huống') {
                          if (_situations.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SituationAllDetailPage(
                                  situations: _situations,
                                  initialIndex: 0,
                                  testId: 0,
                                  testPassedScore: 0,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Không có tình huống nào để hiển thị'),
                              ),
                            );
                          }
                        } else if (simulationItems[index]['title'] == 'Thi thử') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SimulatorTestListPage(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Bạn đã nhấn vào: ${simulationItems[index]['title']}'),
                            ),
                          );
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            simulationItems[index]['icon'],
                            size: 40,
                            color: simulationItems[index]['color'] == Colors.white
                                ? Colors.black
                                : Colors.white,
                          ),
                          SizedBox(height: 8),
                          Text(
                            simulationItems[index]['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: simulationItems[index]['color'] == Colors.white
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}