import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:igloo/wraper.dart';
import '../home.dart';
import 'login.dart';

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
  bool _isConfirmPasswordVisible = false;
  bool isChecked = false;
  bool isLoading = false;


    /// Function to handle sign-up
  Future<void> signUpUser() async {
    if (!isChecked) {
      Get.snackbar(
        'Terms and Conditions',
        'Please accept the User Agreement and Privacy Policy to proceed.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (formKey.currentState!.validate()) {
      try {
        // Create a new user
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );

        // Update the user's display name
        await userCredential.user!.updateDisplayName(username.text.trim());

        // Reload the user to ensure the updated display name is fetched
        await userCredential.user!.reload();

        // Fetch the updated user information
        User? updatedUser = FirebaseAuth.instance.currentUser;

        // Log the updated user details for debugging
        print("User display name: ${updatedUser?.displayName}");

        // Store the user data in Firestore
        await storeUserData(updatedUser!);

        // Navigate to the next screen
        Get.offAll(const Wraper());
      } catch (e) {
        // Handle errors and display error messages
        Get.snackbar(
          'Sign Up Failed',
          'An error occurred: ${e.toString()}',
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }

  /// Function to store user data in Firebase Firestore
  Future<void> storeUserData(User user) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get the user's profile photo URL (if available)
      String profileUrl = user.photoURL ?? ''; // Use the user's photoURL or leave it empty

      // Store user data in Firestore
      await firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'username': user.displayName ?? 'Anonymous', // Use display name or fallback
        'email': user.email, // Store the email
        'userProfileUrl': profileUrl, // Add profile URL
        'createdAt': FieldValue.serverTimestamp(), // Add creation timestamp
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

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Always set a display name and photo URL for Google sign-in users
      if (userCredential.user != null) {
        if (userCredential.user!.displayName == null) {
          await userCredential.user!.updateDisplayName(googleUser.displayName ?? 'Anonymous');
        }
        if (userCredential.user!.photoURL == null) {
          await userCredential.user!.updatePhotoURL(googleUser.photoUrl ?? '');
        }
      }

      // Store user data in Firestore after sign-in
      await storeUserData(userCredential.user!);

      // Navigate to Home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
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
    return isLoading ? const Center(child: CircularProgressIndicator(),) : Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(30.w),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),

              // App icon
              Image.asset(
                'res/images/appicon.png',
                width: 80.w,
                height: 80.h,
              ),
              SizedBox(
                height: 10.h,
              ),

              // Header Text
              const Text(
                'Sign Up in your Account',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
              SizedBox(
                height: 10.h,
              ),

              // Username Field
              TextFormField(
                controller: username,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Enter Your Name',
                  labelText: 'User Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username is Required';
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
                  } else if (!RegExp(
                          r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
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
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
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
                    return 'Password is Required';
                  } else if (value.length < 8) {
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
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Confirm Password is required';
                  } else if (value != password.text.trim()) {
                    return 'Passwords must match';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              SizedBox(height: 20.h),

              // Check Box and Privacy Policy
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    value: isChecked,
                    shape: const CircleBorder(),
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  const Text(
                      "I’ve read and agreed to User Agreement \n And Privacy Policy"),
                ],
              ),
              SizedBox(
                height: 15,
              ),

              // Sign Up Button
              MaterialButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: signUpUser,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFfdbb2d),
                          Color(0xFF27D4C1),
                        ]),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Container(
                    constraints:
                        BoxConstraints(minWidth: 50.w, minHeight: 60.h),
                    alignment: Alignment.center,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),

              // Divider Line
              SvgPicture.asset(
                'res/images/line.svg',
                width: 350.w,
              ),
              SizedBox(
                height: 20.h,
              ),

              // Auth Button Google And Apple
              Row(
                children: [
                  IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        signInWithGoogle(context);
                      },
                      icon: SvgPicture.asset(
                        'res/images/btn.svg',
                        width: 178.w,
                      )),
                  IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'res/images/appleButton.svg',
                        width: 178.w,
                      )),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),

              // Text And TextButton
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ));
                      },
                      child: const Text('Sign In')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
