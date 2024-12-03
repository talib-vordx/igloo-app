import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../home.dart';
import 'signup.dart';
import 'forget_password.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isPasswordVisible = false;
  bool isLoading = false;
  bool status = false;

// Firebase Sign-In Function
  SignInWithEmailPassword() async {
    if (_formKey.currentState!.validate()) {
      // Proceed only if the form is valid
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text, password: password.text);
      } on FirebaseException catch (e) {
        Get.snackbar('Recheck or Forget Your Password', e.code);
      } catch (e) {
        Get.snackbar('Error Message', e.toString());
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Function to handle sign-up
  Future<void> storeUserData(User user) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Store user data
      await firestore.collection('users').doc(user.uid).set({
        'username': user.displayName ??
            'Unnamed User', // Store the username or fallback to 'Unnamed User'
        'email': user.email, // Store the email
        'createdAt': FieldValue.serverTimestamp(), // Add creation time
      });

      print('User data successfully stored in Firestore!');
    } catch (e) {
      print('Failed to store user data: $e');
    }
  }

  /// Function to handle sign-up with google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Always set a display name
      if (userCredential.user!.displayName == null) {
        await userCredential.user!
            .updateDisplayName(googleUser.displayName ?? 'Unnamed');
      }

      // Store user data in Firestore after sign-in
      await storeUserData(userCredential.user!);

      // Navigate to Home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(), // Replace with your home screen widget
        ),
      );

      print('Signed in as: ${userCredential.user?.displayName}');
    } catch (e) {
      print('Error signing in with Google: $e');
      // Optionally, show an error dialog or snackbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            resizeToAvoidBottomInset: true, // Ensures the layout resizes
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(25.w),
                  child: Form(
                    key: _formKey, // Attach form key
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50.h),
                        Center(
                          child: Image.asset(
                            'res/images/appicon.png',
                            width: 80.w,
                            height: 80.h,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Center(
                          child: const Text(
                            'Login in your Account',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        TextFormField(
                          controller: email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter Email here',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: password,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'Enter Password',
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Switch(
                                  activeColor: Colors.grey,
                                  value: status,
                                  onChanged: (value) {
                                    setState(() {
                                      status = value;
                                    });
                                  },
                                ),
                                Text(
                                  'Remember me',
                                  style: TextStyle(
                                      fontSize: 16.sp, color: Colors.grey),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgetPassword()),
                                );
                              },
                              child: Text(
                                'Forget Password?',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30.h),
                        MaterialButton(
                          onPressed: () {
                            SignInWithEmailPassword();
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xff27D4C1),
                                  Colors.black,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Container(
                              constraints: BoxConstraints(
                                  minWidth: double.infinity, minHeight: 60.h),
                              alignment: Alignment.center,
                              child: Text(
                                'Login  ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.sp),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Center(child: SvgPicture.asset('res/images/line.svg')),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                signInWithGoogle(context);
                              },
                              icon: SvgPicture.asset(
                                'res/images/btn.svg',
                                width: 185.w,
                              ),
                            ),
                            IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                'res/images/appleButton.svg',
                                width: 185.w,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'If you don’t have an account',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Signup(),
                                  ),
                                );
                              },
                              child: const Text('Sign Up'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
