import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class otherUserDetails extends StatelessWidget {
  final String userId; // User ID passed to the screen

  const otherUserDetails({super.key, required this.userId});

  // Fetch user details from Firestore
  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    final userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      return userSnapshot.data()!;
    } else {
      throw Exception('User not found');
    }
  }

  // Follow user logic
  Future<void> followUser(String currentUserId, String otherUserId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Add the other user to the current user's "following" list
      await firestore.collection('users').doc(currentUserId).update({
        'following': FieldValue.arrayUnion([otherUserId])
      });

      // Add the current user to the other user's "followers" list
      await firestore.collection('users').doc(otherUserId).update({
        'followers': FieldValue.arrayUnion([currentUserId])
      });

      print("Follow operation successful!");
    } catch (e) {
      print("Error following user: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F3F7),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),

        title: FutureBuilder<Map<String, dynamic>>(
          future: fetchUserData(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError) {
              return const Text('Error');
            } else if (!snapshot.hasData) {
              return const Text('User not found');
            }

            final userData = snapshot.data!;
            final String userName = userData['username'] ?? 'No Name';
            return Text(userName); // Display the user's name as the title
          },
        ),


        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(userId), // Fetch user data from Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('User not found.'));
          }

          final userData = snapshot.data!;

          // Get user details
          final String profilePicUrl = userData['userProfileUrl'] ?? '';
          final String userName = userData['username'] ?? 'No Name';
          final String userEmail = userData['email'] ?? 'No Email';
          final Timestamp creationTimestamp = userData['createdAt'] ?? Timestamp.now();
          final DateTime creationDate = creationTimestamp.toDate();

          // Format creation date
          final String formattedDate = DateFormat('dd MMM yyyy').format(creationDate);

          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                // Profile Picture
                CircleAvatar(
                  radius: 50.r,
                  backgroundImage: profilePicUrl.isNotEmpty ? NetworkImage(profilePicUrl) : null,
                  child: profilePicUrl.isEmpty ?  Icon(Icons.person, size: 50.sp) : null,
                ),
                 SizedBox(height: 10.h),

                // Follow Button
                MaterialButton(
                  elevation: 5,
                  height: 40.h,
                  minWidth: 130.w,
                  color: Colors.white,
                  onPressed: () async {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('You must be logged in to follow users')),
                      );
                      return;
                    }

                    try {
                      await followUser(currentUser.uid, userId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Followed successfully!'),behavior: SnackBarBehavior.floating,),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  child: Text(
                    'Follow +',
                    style: TextStyle(fontSize: 22.sp, color: Colors.black),
                  ),
                ),


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
          );
        },
      ),
    );
  }
}
