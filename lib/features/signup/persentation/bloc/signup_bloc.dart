

import 'package:blocwithcleanarch/features/signup/domain/entities/SignUpEntities.dart';
import 'package:blocwithcleanarch/features/signup/domain/usecases/signup_user.dart';
import 'package:blocwithcleanarch/features/signup/persentation/bloc/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Cubit<SignupState>{
  final SignUpUser signUpUser;

  SignUpBloc(this.signUpUser): super(SignupInitial());

  void signUp(String email, String password) async{
    emit(SignupLoading());

    if(email.isEmpty){
      emit(SignupError("Please enter Email"));
      return;
    }else if(password.isEmpty){
      emit(SignupError("Please enter Password"));
      return;
    }

    try{
      final signupUsers =await signUpUser(email,password);

      if(signupUsers != null){
        emit(SignupSuccess());
      }else{
        emit(SignupError("Invalid details"));
      }
    }catch(e){
      emit(SignupError("Something wrong ${e.toString()}"));
    }

  }
}