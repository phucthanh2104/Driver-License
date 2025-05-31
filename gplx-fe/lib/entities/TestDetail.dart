import 'question.dart';

class TestDetail {
  int? testId;
  int? chapterId;
  Question? question;
  int? time;
  int? passedScore;
  TestDetail({
    this.testId,
    this.chapterId,
    this.question,
    this.time,
    this.passedScore
  });

  factory TestDetail.fromMap(Map<String, dynamic> map) {
    return TestDetail(
      testId: map['testId'] as int?,
      chapterId: map['chapterId'] as int?,
      question: map['question'] != null ? Question.fromMap(map['question']) : null,
      time: map['time'] as int?,
      passedScore: map['passedScore'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'testId': testId,
      'chapterId': chapterId,
      'question': question?.toMap(),
      'time': time,
      'passedScore': passedScore,
    };
  }
}
