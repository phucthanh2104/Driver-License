class Answer {
  int? id;
  String? content;
  bool? correct;
  bool? status;

  Answer({
    this.id,
    this.content,
    this.correct,
    this.status,
  });

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      id: map['id'] as int?,
      content: map['content'] as String?,
      correct: map['correct'] as bool?,
      status: map['status'] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'correct': correct,
      'status': status,
    };
  }
}
