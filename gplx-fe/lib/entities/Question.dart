import 'package:gplx/entities/Answer.dart';

class Question {
  int? id;
  String? content;
  String? image;
  bool? failed; // Thay failed bằng is_failed
  String? explain; // Thêm trường explain
  bool? status;
  bool? isRankA;  // Thêm trường is_rankA
  List<Answer>? answers;

  Question({
    this.id,
    this.content,
    this.image,
    this.failed,
    this.explain,
    this.status,
    this.isRankA,
    this.answers,
  });

  // Tạo từ Map (JSON)
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] as int?,
      content: map['content'] as String?,
      image: map['image'] as String?,
      failed: map['is_failed'] == 1, // Chuyển tinyint(1) thành boolean (1 = true, 0 = false)
      explain: map['explain'] as String?, // Thêm ánh xạ cho explain
      status: map['status'] == 1, // Chuyển tinyint(1) thành boolean
      isRankA: map['is_rankA'] == 1, // Chuyển tinyint(1) thành boolean
      answers: (map['answers'] as List<dynamic>?)
          ?.map((e) => Answer.fromMap(e))
          .toList(),
    );
  }

  // Chuyển thành Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'image': image,
      'is_failed': failed == true ? 1 : 0, // Chuyển boolean thành 1 hoặc 0
      'explain': explain, // Thêm explain vào map
      'status': status == true ? 1 : 0, // Chuyển boolean thành 1 hoặc 0
      'is_rankA': isRankA == true ? 1 : 0, // Chuyển boolean thành 1 hoặc 0
      'answers': answers?.map((e) => e.toMap()).toList(),
    };
  }
}