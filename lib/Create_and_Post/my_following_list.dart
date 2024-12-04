import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyFollowingScreen extends StatelessWidget {
  const MyFollowingScreen({super.key});

  // Get the current user's following list as a stream
  Stream<List<String>> getFollowingList(String currentUserId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data != null && data['following'] != null) {
        return List<String>.from(data['following']);
      }
      return [];
    });
  }

  // Fetch user details from Firestore
  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    final userSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userSnapshot.exists) {
      return userSnapshot.data()!;
    }
    return {};
  }

  // Remove user from the following list
  Future<void> removeFollowing(String currentUserId, String otherUserId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Remove the other user from the current user's "following" list
      await firestore.collection('users').doc(currentUserId).update({
        'following': FieldValue.arrayRemove([otherUserId])
      });

      // Remove the current user from the other user's "followers" list
      await firestore.collection('users').doc(otherUserId).update({
        'followers': FieldValue.arrayRemove([currentUserId])
      });

      stdout.write("User successfully removed from following.");
    } catch (e) {
      stdout.write("Error removing user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(
        child: Text('You must be logged in to view your following list'),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F7),
      appBar: AppBar(
        toolbarHeight: 100.h,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          'My Following',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.h),
        child: Card(
          color: Colors.white,
          child: StreamBuilder<List<String>>(
            stream: getFollowingList(currentUser.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final followingList = snapshot.data ?? [];
              if (followingList.isEmpty) {
                return const Center(
                  child: Text('You are not following anyone.'),
                );
              }

              return ListView.builder(
                itemCount: followingList.length,
                itemBuilder: (context, index) {
                  final userId = followingList[index];
                  return FutureBuilder<Map<String, dynamic>>(
                    future: getUserDetails(userId),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const ListTile(title: Text('Loading...'));
                      } else if (userSnapshot.hasError) {
                        return const ListTile(
                            title: Text('Error loading user details'));
                      } else if (!userSnapshot.hasData ||
                          userSnapshot.data!.isEmpty) {
                        return const ListTile(title: Text('No user data found'));
                      }

                      final user = userSnapshot.data!;
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 30.r,
                          backgroundImage: user['userProfileUrl'] != null &&
                              user['userProfileUrl'].isNotEmpty
                              ? NetworkImage(user['userProfileUrl'])
                              : const AssetImage(
                              'assets/images/default_profile.png')
                          as ImageProvider,
                          onBackgroundImageError: (exception, stackTrace) {
                            debugPrint(
                                'Error loading profile image: $exception');
                          },
                          child: user['userProfileUrl'] == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(
                          user['username'] ?? 'No Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 19.sp),
                        ),
                        subtitle: Text(
                          user['email'] ?? 'No Email',
                          style: TextStyle(fontSize: 10.sp),
                        ),
                        trailing: MaterialButton(
                          color: const Color(0xFF27D4C1),
                          child: Text(
                            'Remove',
                            style: TextStyle(
                                color: Colors.white, fontSize: 18.sp),
                          ),
                          onPressed: () async {
                            try {
                              await removeFollowing(currentUser.uid, userId);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Text('Removed from following list.')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
