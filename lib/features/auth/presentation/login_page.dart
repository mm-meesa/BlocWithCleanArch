import 'package:blocwithcleanarch/core/di/injection.dart';
import 'package:blocwithcleanarch/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blocwithcleanarch/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../movies/presentation/dashboard_page.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  LoginPage({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: BlocProvider(
        create: (_) => sl<AuthBloc>(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              showDialog(
                context: context,
                builder: (_) => Center(child: CircularProgressIndicator()),
              );
            } else if (state is AuthSuccess) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => DashboardPage()),
              );
            } else if (state is AuthError) {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Builder(builder: (context) => mainWidget(context)),
        ),
      ),
    );
  }
  //
  Widget mainWidget(BuildContext context) {
     return Padding(
       padding: const EdgeInsets.all(10.0),
       child: Column(
         children: [
           TextField(controller: emailController),
           TextField(controller: passController),
           ElevatedButton(
             onPressed: () {
               context.read<AuthBloc>().login(
                 emailController.text,
                 passController.text,
               );
             },
             child: Text("Login"),
           ),
         ],
       ),
     );
  }
}
