import 'package:gplx/entities/Simulator.dart';

class TestSimulatortDetail {
  int? id;
  int? status;
  Simulator? simulator;
  int? testId;
  int? testTime;
  int? testType;
  int? testPassedScore;
  int? chapterSimulatorId;

  TestSimulatortDetail({
    this.id,
    this.status,
    this.simulator,
    this.testId,
    this.testTime,
    this.testType,
    this.testPassedScore,
    this.chapterSimulatorId,
  });

  factory TestSimulatortDetail.fromMap(Map<String, dynamic> map) {
    return TestSimulatortDetail(
      id: map['id'] as int?,
      status: map['status'] as int?,
      simulator: map['simulator'] != null ? Simulator.fromMap(map['simulator'] as Map<String, dynamic>) : null,
      testId: map['testId'] as int?,
      testTime: map['testTime'] as int?,
      testType: map['testType'] as int?,
      testPassedScore: map['testPassedScore'] as int?,
      chapterSimulatorId: map['chapterSimulatorId'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'simulator': simulator?.toMap(),
      'testId': testId,
      'testTime': testTime,
      'testType': testType,
      'testPassedScore': testPassedScore,
      'chapterSimulatorId': chapterSimulatorId,
    };
  }
}