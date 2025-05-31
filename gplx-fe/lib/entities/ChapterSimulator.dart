import 'package:gplx/entities/ChapterSimulator.dart';
class ChapterSimulator {
  final int id;
  final String title;
  final String description;
  final bool status;
  final int testId;

  ChapterSimulator({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.testId,
  });

  factory ChapterSimulator.fromMap(Map<String, dynamic> map) {
    return ChapterSimulator(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      status: map['status'],
      testId: map['testId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'testId': testId,
    };
  }
}
