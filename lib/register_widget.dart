import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({Key? key}) : super(key: key);

  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
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
                onPressed: registerEmail,
                style:
                    ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18),
                ))
          ],
        ));
  }

  Future registerEmail() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
