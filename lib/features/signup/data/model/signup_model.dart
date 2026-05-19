import 'package:blocwithcleanarch/features/auth/data/models/user_model.dart';
import 'package:blocwithcleanarch/features/signup/domain/entities/SignUpEntities.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupModel extends SignUpEntities{
  SignupModel({required super.email, required super.password});

  factory SignupModel.fromFirebase(User user){
    return SignupModel(
      email: user.uid,
      password: user.email ?? "",
    );

  }
}