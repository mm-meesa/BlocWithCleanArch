
import 'package:flutter/material.dart';
import '../../movies/presentation/dashboard_page.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  LoginPage({super.key});

  void login(BuildContext context) {
    if (emailController.text.isEmpty || passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Validation Error")));
      return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Column(
        children: [
          TextField(controller: emailController),
          TextField(controller: passController),
          ElevatedButton(onPressed: () => login(context), child: Text("Login"))
        ],
      ),
    );
  }
}
