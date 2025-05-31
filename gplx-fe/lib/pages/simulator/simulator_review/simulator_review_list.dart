import 'package:flutter/material.dart';
import 'package:gplx/entities/ChapterSimulator.dart';
import 'package:gplx/pages/simulator/simulator_review/simulator_review_chapter.dart';
import 'package:gplx/models/chapter_simulator.dart'; // nhớ import

class SimulatorReviewListPage extends StatefulWidget {
  @override
  _SimulatorReviewListPageState createState() => _SimulatorReviewListPageState();
}

class _SimulatorReviewListPageState extends State<SimulatorReviewListPage> {
  List<ChapterSimulator> chapters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChapters();
  }

  Future<void> fetchChapters() async {
    try {
      final api = ChapterSimulatorAPI(); // đúng class API của bạn
      final data = await api.findAllChapterSimulator();
      setState(() {
        chapters = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching chapters: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ôn tập theo chương'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: chapters.length,
        itemBuilder: (context, index) {
          final chapter = chapters[index];
          return Card(
            margin: EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SimulatorReviewChapterPage(
                      chapterId: chapter.id, // Truyền đúng chapterId vào
                      chapterTitle: 'Ôn tập chương ${chapter.title}',
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
                        Text(
                          '${chapter.id}', // Hiển thị số chương
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            chapter.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      chapter.description,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    SizedBox(height: 8),

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
