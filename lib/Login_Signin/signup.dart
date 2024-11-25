import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:igloo/Login_Signin/login.dart';
import 'package:igloo/wraper.dart';

import '../home.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cpassword = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool isChecked = false;

  Future<void> signUpUser() async {
    if (formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );

        // Update the display name
        await userCredential.user!.updateDisplayName(username.text.trim());

        // Navigate to the next screen
        Get.offAll(const Wraper());
      } catch (e) {
        // Show error message
        Get.snackbar(
          'Sign Up Failed',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try
    {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled   the sign-in
        return;
      }

      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to the Home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()), // Replace 'Home()' with your home screen widget
      );

      print('Signed in as: ${userCredential.user?.displayName}');
    } catch (e) {
      print('Error signing in with Google: $e');
      // Optionally, show an error dialog or snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(30.w),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 30.h,),
              Image.asset('res/images/appicon.png',width: 80.w,height: 80.h,),
              SizedBox(height: 10.h,),
              const Text('Sign Up in your Account',style: TextStyle(color:Colors.black,fontWeight: FontWeight.w700,fontSize: 20),),
              SizedBox(height: 10.h,),
              // Username Field
              TextFormField(
                controller: username,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'User Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username is Require';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              SizedBox(height: 10.h),

              // Email Field
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter Email here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter Email';
                  } else if (!RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                      .hasMatch(value)) {
                    return 'Enter a valid Email';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              SizedBox(height: 10.h),

              // Password Field
              TextFormField(
                controller: password,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  labelText: 'Create Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Password is Require';
                  }
                  else if (value.length < 8) {
                    return 'Password should be at least 8 characters long';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              SizedBox(height: 10.h),

              // Confirm Password Field
              TextFormField(
                controller: cpassword,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Confirm Password is require';
                  } else if (value != password.text.trim()) {
                    return 'Confirm Password Must be Same';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    // fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: isChecked,
                    shape: CircleBorder(),
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  SizedBox(width: 5.w,),
                  Text("I’ve read and agreed to User Agreement \n And Privacy Policy"),
                ],
              ),
              SizedBox(height: 15,),
              // Sign Up Button
              MaterialButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: signUpUser,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient:  LinearGradient(
                        begin: Alignment.topCenter,  // Starting from top-left
                        end: Alignment.bottomCenter, // Ending at bottom-right
                        colors: [
                          Color(0xff27D4C1),
                          Colors.black,
                        ]
                    ),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Container(
                    constraints:  BoxConstraints(minWidth: 50.w, minHeight: 60.h),
                    alignment: Alignment.center,
                    child:  Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h,),
              SvgPicture.asset('res/images/line.svg',width: 350.w,),
              SizedBox(height: 20.h,),
              Row(
                children: [
                  IconButton(
                      splashColor : Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: (){
                        signInWithGoogle(context);
                      },
                      icon: SvgPicture.asset(
                        'res/images/btn.svg',width: 178.w,)),
                  // SizedBox(width: 10.w),
                  IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: (){},
                      icon: SvgPicture.asset(
                        'res/images/appleButton.svg',width: 178.w,)),
                ],
              ),
              SizedBox(height: 10.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Already have an account',style: TextStyle(color: Colors.grey),),
                  TextButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login(),));
                  }, child:Text('Sign In')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

