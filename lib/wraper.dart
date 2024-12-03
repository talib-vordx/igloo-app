import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Login_SignUP/login.dart';
import 'Login_SignUP/verify.dart';
import 'home.dart';

class Wraper extends StatefulWidget {
  const Wraper({super.key});

  @override
  State<Wraper> createState() => _WraperState();
}

class _WraperState extends State<Wraper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              print(snapshot.hasData);

              if(snapshot.data!.emailVerified){
                return    const Home();

              }
              else{
                return const VerifyPage();
              }
            }
            else{
              return const Login();
            }
          }
      ),
    );
  }
}
