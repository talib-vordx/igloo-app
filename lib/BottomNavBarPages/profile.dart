import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../wraper.dart';

class currentUserProfileScreen extends StatelessWidget {
  const currentUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('No user logged in'),
      );
    }

    // Fetch user details
    final String profilePicUrl = user.photoURL ?? '';
    final String userName = user.displayName ?? 'No Name';
    final String userEmail = user.email ?? 'No Email';
    final DateTime creationDate = user.metadata.creationTime ?? DateTime.now();

    // Format creation date
    final String formattedDate = DateFormat('dd MMM yyyy').format(creationDate);

    return Scaffold(
      backgroundColor: const Color(0xffF5F3F7),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back_ios_new)),
        title: const Text('My Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding:  EdgeInsets.all(20.w),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundImage:
              profilePicUrl.isNotEmpty ? NetworkImage(profilePicUrl) : null,
              child: profilePicUrl.isEmpty ? const Icon(Icons.person, size: 50) : null,
            ),
             SizedBox(height: 10.h,),

            // User Name
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Name'),
              subtitle: Text(userName),
            ),

            // User Email
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(userEmail),
            ),

            // Account Creation Date
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Account Created'),
              subtitle: Text(formattedDate),
            ),

            // Logout Button
            MaterialButton(
              minWidth: 300.w,
              height: 50.h,
              color: const Color(0xff27D4C1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r)
              ),
              onPressed: (){
              signOutFromGoogle(context);
            },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> signOutFromGoogle(BuildContext context) async {
  try {
    // Step 1: Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Step 2: Sign out from Google
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    // Step 3: Clear SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Step 4: Clear Cache
    await DefaultCacheManager().emptyCache();

    // Step 5: Navigate to Login Screen and clear stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Wraper()),
          (route) => false, // Remove all previous routes
    );
  } catch (e) {
    // Handle errors during sign-out
    print("Sign out failed: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sign out failed: $e")),
    );
  }
}
