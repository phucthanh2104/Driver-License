import 'package:flutter/material.dart';
import 'package:gplx/pages/dashboard.dart';
import 'package:gplx/pages/simulator/simulator_review/simulator_review_list.dart';
import 'package:gplx/pages/simulator/simulator_test/simulator_test_list.dart';
import 'package:gplx/pages/test/test_list.dart';

class SimulationDashboardPage extends StatefulWidget {
  @override
  _SimulationDashboardPageState createState() => _SimulationDashboardPageState();
}

class _SimulationDashboardPageState extends State<SimulationDashboardPage> {
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
      'title': 'Các tình huống ghi nhớ',
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ôn thi 120 THGT'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Xử lý khi nhấn vào nút cài đặt
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Mở cài đặt')),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần thông số
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           'Số tình huống',
            //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //         ),
            //         SizedBox(height: 4),
            //         Text(
            //           '0/120',
            //           style: TextStyle(fontSize: 16, color: Colors.purple),
            //         ),
            //         SizedBox(height: 16),
            //         Text(
            //           'Thi ngẫu nhiên',
            //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //         ),
            //         SizedBox(height: 4),
            //         Text(
            //           '0',
            //           style: TextStyle(fontSize: 16, color: Colors.purple),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           'Điểm trung bình',
            //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //         ),
            //         SizedBox(height: 4),
            //         Text(
            //           '0/50',
            //           style: TextStyle(fontSize: 16, color: Colors.red),
            //         ),
            //         SizedBox(height: 16),
            //         Text(
            //           'Thi theo bộ đề',
            //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //         ),
            //         SizedBox(height: 4),
            //         Text(
            //           '0/12',
            //           style: TextStyle(fontSize: 16, color: Colors.red),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            SizedBox(height: 16),
            // Phần danh sách các nút chức năng
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cột
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.0, // Tỷ lệ chiều rộng/chiều cao của ô
                ),
                itemCount: simulationItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: simulationItems[index]['color'],
                    child: InkWell(
                      onTap: () {
                        // Chuyển hướng đến SimulatorReviewPage khi nhấn "Ôn thi"
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
                        }else if (simulationItems[index]['title'] == 'Thi thử') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SimulatorTestListPage(),
                            ),
                          );
                        }else {
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
      // Banner quảng cáo ở dưới cùng

    );
  }
}