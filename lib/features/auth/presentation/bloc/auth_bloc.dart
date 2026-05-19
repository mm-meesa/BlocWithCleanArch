import 'package:blocwithcleanarch/features/auth/domain/usecases/login_user.dart';
import 'package:blocwithcleanarch/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AuthBloc extends Cubit<AuthState> {
  final LoginUser loginUser;

  AuthBloc(this.loginUser) : super(AuthInitial());

  void login(String email, String password) async {
    emit(AuthLoading());

    if(email.isEmpty){
      emit(AuthError("Please enter Email"));
      return;
    }else if(password.isEmpty){
      emit(AuthError("Please enter Password"));
      return;
    }

    try {
      final user = await loginUser(email, password);

      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthError("Invalid credentials"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}