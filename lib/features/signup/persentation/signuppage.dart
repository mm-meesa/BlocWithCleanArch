import 'package:blocwithcleanarch/features/movies/presentation/dashboard_page.dart';
import 'package:blocwithcleanarch/features/signup/persentation/bloc/signup_bloc.dart';
import 'package:blocwithcleanarch/features/signup/persentation/bloc/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';

class SignupPage extends StatelessWidget{

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text("Signup")),
     body: BlocProvider(
       create: (_) => sl<SignUpBloc>(),
       child: BlocListener<SignUpBloc,SignupState>(
         listener: (context,state){
           if(state is SignupLoading){
             showDialog(
               context: context,
               builder: (_) => Center(child: CircularProgressIndicator()),
             );
           }
           else if(state is SignupSuccess){
             Navigator.pop(context);
             Navigator.pushReplacement(
               context,
               MaterialPageRoute(builder: (_) => DashboardPage()),
             );
           }
           else if(state is SignupError){
             Navigator.pop(context);
             ScaffoldMessenger.of(
               context,
             ).showSnackBar(SnackBar(content: Text(state.message)));
           }
         },
         child: Builder(builder: (context) => mainSignupWidget(context),),),
     ),
   );
  }

  Widget mainSignupWidget(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          TextField(controller: emailController),
          TextField(controller: passwordController),
          ElevatedButton(
            onPressed: () {
              context.read<SignUpBloc>().signUp(
                emailController.text,
                passwordController.text,
              );
            },
            child: Text("Signup"),
          ),
        ],
      ),
    );
  }

}