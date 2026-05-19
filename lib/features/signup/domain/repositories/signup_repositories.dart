import 'package:blocwithcleanarch/features/signup/domain/entities/SignUpEntities.dart';

abstract class SignUpRepositories{

  Future<SignUpEntities?> signup(String email,String password);
}