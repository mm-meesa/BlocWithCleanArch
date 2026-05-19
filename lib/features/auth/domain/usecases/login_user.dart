import 'package:blocwithcleanarch/features/auth/domain/entities/user.dart';
import 'package:blocwithcleanarch/features/auth/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<UserEntity?> call(String email, String password) {
    return repository.login(email, password);
  }
}