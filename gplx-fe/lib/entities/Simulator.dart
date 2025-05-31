import 'package:gplx/entities/Simulator.dart';
class Simulator {
  final int id;
  final String title;
  final String description;
  final String videoLink;
  final String image;
  final int videoLength;
  final int dangerSecond;
  final String guideDescription;
  final String guideImage;
  final bool status;

  Simulator({
    required this.id,
    required this.title,
    required this.description,
    required this.videoLink,
    required this.image,
    required this.videoLength,
    required this.dangerSecond,
    required this.guideDescription,
    required this.guideImage,
    required this.status,
  });

  factory Simulator.fromMap(Map<String, dynamic> map) {
    return Simulator(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      videoLink: map['videoLink'],
      image: map['image'],
      videoLength: map['videoLength'],
      dangerSecond: map['dangerSecond'],
      guideDescription: map['guideDescription'],
      guideImage: map['guideImage'],
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'videoLink': videoLink,
      'image': image,
      'videoLength': videoLength,
      'dangerSecond': dangerSecond,
      'guideDescription': guideDescription,
      'guideImage': guideImage,
      'status': status,
    };
  }
}
