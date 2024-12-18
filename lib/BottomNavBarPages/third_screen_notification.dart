import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ThirdScreenNotification extends StatelessWidget {
  const ThirdScreenNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F3F7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 130.h,
        title: Row(
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios_new)),
            const Spacer(),
            Text("Notifications",style: TextStyle(fontSize: 24.sp,color: Colors.black,fontWeight: FontWeight.w700),),
            const Spacer(),
            IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/ThireDotButton.svg',),),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Text('Today',style: TextStyle(fontSize: 28.sp,color: Colors.black26,fontWeight: FontWeight.w700),),
                const Spacer(),
                TextButton(
                    onPressed: () async {
                      // Add Clear All functionality if needed
                      await FirebaseFirestore.instance.collection('notifications').get().then((snapshot) {
                        for (var doc in snapshot.docs) {
                          doc.reference.delete();
                        }
                      });
                    },
                    child: const Text("Clear All",style: TextStyle(color: Color(0xFF27D4C1),),)
                )
              ],
            ),
            SizedBox(height: 10.h,),
            Expanded(  // Wrap the ListView inside Expanded so it can properly fit
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 6.h,),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('notifications')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        // Handling Loading State
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        // Handling Empty Data
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No notifications yet.'));
                        }

                        // Mapping Firestore Data to NotificationModel
                        final notifications = snapshot.data!.docs.map((doc) {
                          return NotificationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                        }).toList();

                        // Building ListView
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal,
                                child: Icon(Icons.notifications, color: Colors.white),
                              ),
                              title: Text(notification.message),
                              subtitle: Text(
                                notification.createdAt != null
                                    ? DateFormat('yyyy-MM-dd HH:mm').format(notification.createdAt)
                                    : 'Date not available',
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationModel {
  String? id;
  final String postId;
  final String message;
  final String userId;
  final DateTime createdAt;

  NotificationModel({
    this.id,
    required this.postId,
    required this.message,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'message': message,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static NotificationModel fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      postId: map['postId'],
      message: map['message'],
      userId: map['userId'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
