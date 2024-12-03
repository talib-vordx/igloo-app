import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllUsersScreen extends StatelessWidget {

  // Fetch all users from Firestore
  Stream<QuerySnapshot> getAllUsers() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }
  @override
  Widget build(BuildContext context) {
    // Get the current logged-in user's ID
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
           centerTitle: true,
          title: Text('All Users')
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getAllUsers(),
        builder: (context, snapshot) {
          // Show a loading indicator while fetching data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // Handle error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // If no data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          }
          // List of users
          var users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var userData = users[index].data() as Map<String, dynamic>;

              // Skip the current user's entry
              if (userData['userId'] == currentUserId) {
                return SizedBox.shrink(); // Skip rendering
              }
              // If not the current user, display the user info
              return MaterialButton(onPressed: (){
              },child: Card(
                child: ListTile(
                  title: Row(
                      children: [
                        CircleAvatar(child: Text(userData['username'][0].toUpperCase()), ),
                        SizedBox(width: 20.w,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(userData['username'] ?? 'Anonymous'),
                            Text(
                              userData['createdAt'] != null
                                  ? (userData['createdAt'] as Timestamp)
                                  .toDate()
                                  .toLocal()
                                  .toString()
                                  : 'No Date',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  subtitle: Text(userData['email'] ?? 'No Email'),
                ),
              ),);
            },
          );
        },
      ),
    );
  }
}
