import 'package:blocwithcleanarch/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:blocwithcleanarch/features/auth/data/models/user_model.dart';
import 'package:blocwithcleanarch/features/auth/domain/entities/user.dart';
import 'package:blocwithcleanarch/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<UserEntity?> login(String email, String password) async {
    final user = await remote.login(email, password);
    if (user == null) return null;
    return UserModel.fromFirebase(user);
  }
}