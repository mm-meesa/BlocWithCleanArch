import 'package:blocwithcleanarch/features/signup/domain/usecases/signup_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupRemoteDataSources{
  final FirebaseAuth firebaseAuth;

  SignupRemoteDataSources(this.firebaseAuth);

  Future<User?> signUpCall(String email, String password) async{
    final res = await firebaseAuth.signInWithEmailAndPassword(email: email,
        password: password);
    return res.user;
  }
}