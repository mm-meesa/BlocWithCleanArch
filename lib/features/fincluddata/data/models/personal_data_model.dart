import 'package:blocwithcleanarch/features/fincluddata/domain/entities/personal_data.dart';


class PersonalDataModel extends PersonalData {
  PersonalDataModel({
     super.userId,
     super.id,
     super.title,
     super.body,
  });

  factory PersonalDataModel.fromJson(Map<String, dynamic> json) {
    return PersonalDataModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
