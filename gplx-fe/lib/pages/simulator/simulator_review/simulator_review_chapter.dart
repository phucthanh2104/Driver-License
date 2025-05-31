import 'package:flutter/material.dart';
import 'package:gplx/models/chapter_simulator.dart';
import 'package:gplx/entities/Simulator.dart'; // Entity Simulator
import 'package:gplx/pages/simulator/simulator_review/situation_detail.dart';

class SimulatorReviewChapterPage extends StatefulWidget {
  final int chapterId; // Đã khai báo chapterId
  final String chapterTitle;

  // Constructor sửa lại để đảm bảo truyền tham số đúng cách
  const SimulatorReviewChapterPage({
    Key? key,
    required this.chapterId,
    required this.chapterTitle,
  }) : super(key: key);

  @override
  _SimulatorReviewChapterPageState createState() => _SimulatorReviewChapterPageState();
}

class _SimulatorReviewChapterPageState extends State<SimulatorReviewChapterPage> {
  List<Simulator> situations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSituations();
  }

  Future<void> fetchSituations() async {
    try {
      final api = ChapterSimulatorAPI();
      final data = await api.findSituationsByChapterId(widget.chapterId);
      setState(() {
        situations = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching situations: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapterTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : situations.isEmpty
          ? Center(child: Text('Không có tình huống nào.'))
          : ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: situations.length,
        itemBuilder: (context, index) {
          final situation = situations[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: () {
                // Không cần gọi API findSimulatorById, sử dụng danh sách situations hiện có
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SituationDetailPage(
                      situations: situations, // Truyền toàn bộ danh sách situations
                      initialIndex: index,
                      testId: 0,
                      testPassedScore: 0,
                      // Vị trí của situation được click
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue[100],
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            situation.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        5, // Tạm 5 sao hết (hoặc sau này map theo situation.difficulty)
                            (i) => Icon(
                          Icons.star,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      situation.description,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    SizedBox(height: 8),
                    situation.image.isNotEmpty
                        ? Container(
                      height: 200,
                      width: double.infinity,
                      child: Image.network(
                        situation.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Text('Không tải được ảnh'),
                        ),
                      ),
                    )
                        : Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Center(
                        child: Text('Không có hình ảnh minh họa'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}