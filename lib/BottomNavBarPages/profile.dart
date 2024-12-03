import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

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
             SizedBox(height: 20.h),

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
          ],
        ),
      ),
    );
  }
}
