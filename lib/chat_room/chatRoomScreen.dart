import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'chat_screen.dart';

class ChatRoomsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          toolbarHeight: 110.h,
          title: Row(
            children: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back_ios_new)),
              const Spacer(),
              Text("DM's",style: TextStyle(fontSize: 24.sp,color: Colors.black,fontWeight: FontWeight.w700),),
              const Spacer(),
              IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/ThireDotButton.svg',),),
            ],
          ),
        ),
        body: Center(child: Text('You need to be logged in to view chat rooms.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 130.h,
        title: Row(
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_ios_new)),
            const Spacer(),
            Text("DM's",style: TextStyle(fontSize: 24.sp,color: Colors.black,fontWeight: FontWeight.w700),),
            const Spacer(),
            IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/ThireDotButton.svg',),),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatRooms')
            .where('users', arrayContains: currentUser.uid)
            .orderBy('updatedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chat rooms available.'));
          }

          final chatRooms = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final chatRoom = chatRooms[index];
              final otherUserId = (chatRoom['users'] as List<dynamic>)
                  .firstWhere((id) => id != currentUser.uid, orElse: () => null);

              if (otherUserId == null) {
                return const ListTile(title: Text('Error: No other user found.'));
              }
              // Fetch the other user's data
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(title: Text('Loading...'));
                  }

                  if (userSnapshot.hasError) {
                    return ListTile(
                      title: Text('Error: Unable to fetch user data'),
                      subtitle: Text(userSnapshot.error.toString()),
                    );
                  }

                  final userData = userSnapshot.data?.data() as Map<String, dynamic>?;

                  if (userData == null) {
                    return ListTile(
                      leading: CircleAvatar(child: Icon(Icons.error, color: Colors.red)),
                      title: Text('Unknown User'),
                      subtitle: Text('User data not available.'),
                    );
                  }

                  // Adjusted to match your Firestore field names
                  final userName = userData['username'] ?? 'Unknown User';
                  final userProfileUrl = userData['userProfileUrl'] ?? '';
                  final lastMessage = chatRoom['lastMessage'] ?? 'No messages yet';
                  final updatedAt = chatRoom['updatedAt'] != null
                      ? (chatRoom['updatedAt'] as Timestamp).toDate()
                      : DateTime.now();
                  final formattedTime = DateFormat('dd MMM, hh:mm a').format(updatedAt);

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 5.h),
                    child: Card(
                      color: Colors.white,
                      child: ListTile(
                        title: Row(
                          children: [
                            CircleAvatar(
                            radius: 22,
                            backgroundImage: userProfileUrl.isNotEmpty
                                ? NetworkImage(userProfileUrl)
                                : null,
                            child: userProfileUrl.isEmpty
                                ? Icon(Icons.person, size: 30)
                                : null,
                          ),
                            SizedBox(width: 20.w,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formattedTime,
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        subtitle:  Padding(
                          padding: EdgeInsets.all(20.h),
                          child: Text(
                                  lastMessage,
                                  style: TextStyle(color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(chatRoomId: chatRoom['chatRoomId']),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
