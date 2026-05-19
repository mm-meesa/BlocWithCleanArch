import 'package:blocwithcleanarch/features/signup/domain/entities/SignUpEntities.dart';
import 'package:blocwithcleanarch/features/signup/domain/repositories/signup_repositories.dart';

class SignUpUser{

  final SignUpRepositories repositories;

  SignUpUser(this.repositories);

  Future<SignUpEntities?> call(String email, String password){
    return repositories.signup(email, password);
  }

}