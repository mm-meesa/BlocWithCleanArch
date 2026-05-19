import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSource(this.firebaseAuth);

  Future<User?> login(String email, String password) async {
    final res = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return res.user;
  }

  
}