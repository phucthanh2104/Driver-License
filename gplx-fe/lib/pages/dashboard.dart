import 'package:flutter/material.dart';
import 'package:gplx/entities/Rank.dart';
import 'package:gplx/models/test_api.dart';
import 'package:gplx/pages/review/review_all_question.dart';
import 'package:gplx/pages/review/review_signs.dart';
import 'package:gplx/pages/review/review_test_list.dart';
import 'package:gplx/pages/review/review_failed_list.dart';
import 'package:gplx/pages/simulator/simulator_dashboard.dart';
import 'package:gplx/pages/test/test_list.dart';
import 'package:gplx/pages/review/review_tips.dart'; // Import trang TipsPage
import 'package:gplx/pages/test/test_random_list.dart';

import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Danh sách các mục trong dashboard
  final testAPI = new TestAPI();
  final List<Map<String, dynamic>> dashboardItems = [
    {
      'title': 'Đề ngẫu nhiên',
      'icon': Icons.shuffle,
      'color': Colors.orange,
    },
    {
      'title': 'Thi theo bộ đề',
      'icon': Icons.list_alt,
      'color': Colors.red,
    },
    {
      'title': 'Toàn bộ câu hỏi',
      'icon': Icons.person,
      'color': Colors.green,
    },
    {
      'title': 'Ôn tập câu hỏi',
      'icon': Icons.book,
      'color': Colors.teal,
    },
    {
      'title': 'Các biển báo',
      'icon': Icons.traffic,
      'color': Colors.blue,
    },
    {
      'title': 'Mẹo ghi nhớ',
      'icon': Icons.favorite,
      'color': Colors.purple,
    },
    {
      'title': 'Câu điểm liệt',
      'icon': Icons.shield,
      'color': Colors.brown,
    },
    {
      'title': '120 câu mô phỏng',
      'icon': Icons.lightbulb,
      'color': Colors.cyan,
    },
  ];
  List<Rank> ranks = [];

  @override
  void initState() {
    super.initState();
    loadRanks();
  }

  // Hàm tải danh sách bài kiểm tra từ API
  Future<void> loadRanks() async {
    try {
      final List<Rank> fetchedRanks = await testAPI.findAllRank();
      setState(() {
        ranks = fetchedRanks;
      });
    } catch (e) {
      print("Error: ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giấy Phép Lái Xe 2025'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Xử lý khi nhấn vào nút cài đặt
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.03,

                ),
                itemCount: dashboardItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: dashboardItems[index]['color'],
                    child: InkWell(
                      onTap: () {
                        // Chuyển hướng đến các trang tương ứng

                        if (dashboardItems[index]['title'] == 'Ôn tập câu hỏi') {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewTestListPage(),
                            ),
                          );
                        } else if (dashboardItems[index]['title'] ==
                            'Thi theo bộ đề') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TestListPage(),
                            ),
                          );
                        } else if (dashboardItems[index]['title'] ==
                            'Câu điểm liệt') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewFailedListPage(),
                            ),
                          );
                        }else if (dashboardItems[index]['title'] ==
                            'Toàn bộ câu hỏi') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewAllQuestionPage(categoryTitle: 'Toàn bộ câu hỏi',),
                            ),
                          );
                        }
                        else if (dashboardItems[index]['title'] ==
                            'Đề ngẫu nhiên') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TestRanDomListPage(),
                            ),
                          );
                        }
                        else if (dashboardItems[index]['title'] ==
                            '120 câu mô phỏng') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SimulationDashboardPage(),
                            ),
                          );
                        } else if (dashboardItems[index]['title'] ==
                            'Các biển báo') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewSignPage(),
                            ),
                          );
                        } else if (dashboardItems[index]['title'] ==
                            'Mẹo ghi nhớ') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(

                              builder: (context) =>  TipsPage(),
                            ),
                          );
                        } else if (dashboardItems[index]['title'] == 'Mẹo ghi nhớ') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TipsPage(), // Chuyển hướng đến TipsPage

                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Bạn đã nhấn vào: ${dashboardItems[index]['title']}'),
                            ),
                          );
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            dashboardItems[index]['icon'],
                            size: 40,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8),
                          Text(
                            dashboardItems[index]['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Chọn hạng GPLX',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: ranks.map((rank) {
                        return ElevatedButton(
                          onPressed: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setInt('rankID', rank.id!);
                            print(prefs.getInt('rankID'));
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                'Đã chọn hạng: ${rank.name}',
                                style: TextStyle(fontSize: 15),
                              )),
                            );
                            // TODO: Xử lý logic chuyển đổi theo hạng nếu cần
                          },
                          child: Text(rank.name!,
                              style: TextStyle(fontSize: 15)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Text("Hạng"),
        tooltip: 'Chọn hạng GPLX',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
