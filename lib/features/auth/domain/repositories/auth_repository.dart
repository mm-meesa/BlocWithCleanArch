import 'package:blocwithcleanarch/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity?> login(String email, String password);
}