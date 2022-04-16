import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:day_to_day/register_widget.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            TextField(
              controller: emailController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
                onPressed: signInEmail,
                style:
                    ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 18),
                )),
            TextButton(
                onPressed: register,
                child: const Text('Don\'t have an account? Sign up here.'))
          ],
        ));
  }

  Future signInEmail() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  void register() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const RegisterWidget();
    }));
  }
}
