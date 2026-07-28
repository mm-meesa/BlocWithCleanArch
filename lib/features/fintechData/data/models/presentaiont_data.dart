import 'package:blocwithcleanarch/features/fintechData/domain/entities/PresentaiontEntities.dart';

class PresentaiontData extends PresentationEntities {
  PresentaiontData({super.userId, super.id, super.title, super.body});

  factory PresentaiontData.fromJson(Map<String, dynamic> json) {
    return PresentaiontData(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
