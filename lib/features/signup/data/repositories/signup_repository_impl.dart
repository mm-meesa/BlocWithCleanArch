import 'package:blocwithcleanarch/features/signup/data/datasources/signup_remote_datasources.dart';
import 'package:blocwithcleanarch/features/signup/data/model/signup_model.dart';
import 'package:blocwithcleanarch/features/signup/domain/entities/SignUpEntities.dart';
import 'package:blocwithcleanarch/features/signup/domain/repositories/signup_repositories.dart';

class SignupRepositoryImpl extends SignUpRepositories {
  final SignupRemoteDataSources remote;

  SignupRepositoryImpl(this.remote);

  @override
  Future<SignUpEntities?> signup(String email, String password) async {
    final signUpUsers = await remote.signUpCall(email, password);
    if (signUpUsers == null) return null;
    return SignupModel.fromFirebase(signUpUsers);
  }
}
