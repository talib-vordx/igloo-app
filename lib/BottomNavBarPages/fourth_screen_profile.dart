
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:igloo/BottomNavBarPages/profile.dart';
import 'package:igloo/BottomNavBarPages/setting_screen.dart';

import '../Create_and_Post/my_following_list.dart';
import '../Create_and_Post/my_post.dart';

class FourthScreenProfile extends StatefulWidget {
  const FourthScreenProfile({super.key});

  @override
  State<FourthScreenProfile> createState() => _FourthScreenProfileState();
}

class _FourthScreenProfileState extends State<FourthScreenProfile> {
  final currentUser = FirebaseAuth.instance.currentUser;

  // Stream to fetch all the votes of the current user across posts
  Stream<int> getTotalVotesGainedByUser() {
    if (currentUser == null) {
      return Stream.value(0); // If the user is not logged in, return 0 votes.
    }

    final userId = currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('posts')
        .snapshots()
        .map((snapshot) {
      int totalVotes = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final votes = data['votes'] as Map<String, dynamic>?;

        if (votes != null && votes.containsKey(userId)) {
          totalVotes += votes[userId] == true ? 1 : 0; // Increment for upvotes
        }
      }

      return totalVotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if the user is null before accessing the properties
    if (currentUser == null) {
      return const Center(child: Text('No user logged in'));
    }

    // Fetch user details
    final String profilePicUrl = currentUser?.photoURL ?? '';
    final String userName = currentUser?.displayName ?? 'No Name';
    final String userEmail = currentUser?.email ?? 'No Email';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F7),
      body: Padding(
        padding: EdgeInsets.only(top: 70.h, left: 15.w, right: 15.w),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Profile",
                  style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w700, color: Colors.black),
                ),
                GestureDetector(
                  child: CircleAvatar(
                    radius: 35.r,
                    backgroundImage: profilePicUrl.isNotEmpty ? NetworkImage(profilePicUrl) : null,
                    child: profilePicUrl.isEmpty ? const Icon(Icons.person, size: 50) : null,
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const currentUserProfileScreen()));
                  },
                ),
              ],
            ),
            SizedBox(height: 24.h,),
            SizedBox(
              height: 200.h,
              width: double.infinity,
              child: Card(
                semanticContainer: true,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: StreamBuilder<int>(
                    stream: getTotalVotesGainedByUser(), // Stream that returns total votes
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final totalVotes = snapshot.data!;
                      return Column(
                        children: [
                          Text("Your Cred",style: TextStyle(fontSize: 20.sp,),),
                          Text(
                            "$totalVotes", // Display the total votes gained
                            style: TextStyle(fontSize: 45.sp,color: const Color(0xFF27D4C1),fontWeight: FontWeight.bold),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 35.h,),
            // share to unique link
            GestureDetector(
              child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('res/images/shareButtonProfileScreeen.svg'),
                        SizedBox(width: 20.w,),
                        Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text('Share To Unique Link',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  )),
              onTap: (){
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("This Feature is Coming Soon"))
                );
              },
            ),
            // My post
            GestureDetector(
              child: Card(
                color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    SvgPicture.asset('res/images/MyPostIcon.svg'),
                    SizedBox(width: 20.w,),
                    Padding(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Text('My Posts',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded)
                                      ],
                                    ),
                  )),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserPostsScreen() ));
              },
            ),
            // my following
            GestureDetector(
              child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('res/images/MyPostIcon.svg'),
                        SizedBox(width: 20.w,),
                        Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text('My Following',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  )),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyFollowingScreen()));
              },
            ),
            // my comment
            GestureDetector(
              child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('res/images/CommentsProfileScreen.svg'),
                        SizedBox(width: 20.w,),
                        Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text("My Comment's",style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  )),
              onTap: (){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This Feature is Coming Soon'))
                );
              },
            ),
            // how to use
            GestureDetector(
              child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('res/images/AboutUsProfileScreen.svg'),
                        SizedBox(width: 20.w,),
                        Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text('How To Use?',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  )),
              onTap: (){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("This Feature is Coming Soon"))
                );
              },
            ),
            // privacy policy
            GestureDetector(
              child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('res/images/ic_outline-privacy-tip.svg'),
                        SizedBox(width: 20.w,),
                        Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text('Privacy Policy',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  )),
              onTap: (){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This Feature is Coming Soon'))
                );
              },
            ),
            // setting
            GestureDetector(
              child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('res/images/uil_setting.svg'),
                        SizedBox(width: 20.w,),
                        Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text('Setting',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  )),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen(),),);
                },
            ),

          ],
        ),
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:igloo/BottomNavBarPages/setting_screen.dart';
// import '../Create_and_Post/my_post.dart';
//
//
// class FourthScreenProfile extends StatefulWidget {
//   const FourthScreenProfile({super.key});
//
//   @override
//   State<FourthScreenProfile> createState() => _FourthScreenProfileState();
// }
//
// class _FourthScreenProfileState extends State<FourthScreenProfile> {
//   final currentUser = FirebaseAuth.instance.currentUser;
//
//
//   // Stream to fetch all the votes of the current user across posts
//   // Stream to get the total votes gained by the current user across all posts.
//   Stream<int> getTotalVotesGainedByUser() {
//     final currentUser = FirebaseAuth.instance.currentUser;
//
//     if (currentUser == null) {
//       return Stream.value(0); // If the user is not logged in, return 0 votes.
//     }
//
//     final userId = currentUser.uid;
//
//     // Get all posts where the user has voted and count how many times they have voted.
//     return FirebaseFirestore.instance
//         .collection('posts')
//         .snapshots()
//         .map((snapshot) {
//       int totalVotes = 0;
//
//       for (var doc in snapshot.docs) {
//         final data = doc.data();
//         final votes = data['votes'] as Map<String, dynamic>?;
//
//         // If the current user has voted (either upvoted or downvoted), add to the total
//         if (votes != null && votes.containsKey(userId)) {
//           totalVotes += votes[userId] == true ? 1 : 0; // Increment only for upvotes
//         }
//       }
//
//       return totalVotes;
//     });
//   }
//
//   // Fetch user details
//   final String profilePicUrl = user.photoURL ?? '';
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F3F7),
//       body: Padding(
//         padding: EdgeInsets.only(top: 70.h,left: 15.w,right: 15.w),
//         child: Column(
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Text("Profile",style: TextStyle(fontSize: 28.sp,fontWeight: FontWeight.w700,color: Colors.black),),
//
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundImage:
//                   profilePicUrl.isNotEmpty ? NetworkImage(profilePicUrl) : null,
//                   child: profilePicUrl.isEmpty ? const Icon(Icons.person, size: 50) : null,
//                 ),
//               ],
//             ),
//             SizedBox(height: 24.h,),
//             SizedBox(
//               height: 200.h,
//               width: double.infinity,
//               child: Card(
//                 semanticContainer: true,
//                 color: Colors.white,
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(vertical: 40.h),
//                   child: StreamBuilder<int>(
//                     stream: getTotalVotesGainedByUser(), // Stream that returns total votes
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       final totalVotes = snapshot.data!;
//                       return Column(
//                         children: [
//                           Text("Your Cred",style: TextStyle(fontSize: 20.sp,),),
//                           Text(
//                             "$totalVotes", // Display the total votes gained
//                             style: TextStyle(fontSize: 45.sp,color: const Color(0xFF27D4C1),fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 35.h,),
//             // share to unique link
//             GestureDetector(
//               child: Card(
//                   color: Colors.white,
//                   child: Padding(
//                     padding: EdgeInsets.all(12.h),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SvgPicture.asset('res/images/shareButtonProfileScreeen.svg'),
//                         SizedBox(width: 20.w,),
//                         Padding(
//                             padding: EdgeInsets.only(top: 5.h),
//                             child: Text('Share To Unique Link',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
//                         const Spacer(),
//                         const Icon(Icons.arrow_forward_ios_rounded)
//                       ],
//                     ),
//                   )),
//               onTap: (){
//                 ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text("This Feature is Coming Soon"))
//                 );
//               },
//             ),
//             // My post
//             GestureDetector(
//               child: Card(
//                 color: Colors.white,
//                   child: Padding(
//                     padding: EdgeInsets.all(12.h),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                     SvgPicture.asset('res/images/MyPostIcon.svg'),
//                     SizedBox(width: 20.w,),
//                     Padding(
//                         padding: EdgeInsets.only(top: 5.h),
//                         child: Text('My Posts',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
//                     const Spacer(),
//                     const Icon(Icons.arrow_forward_ios_rounded)
//                                       ],
//                                     ),
//                   )),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) =>  UserPostsScreen() ));
//               },
//             ),
//             // my following
//             GestureDetector(
//               child: Card(
//                   color: Colors.white,
//                   child: Padding(
//                     padding: EdgeInsets.all(12.h),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SvgPicture.asset('res/images/MyPostIcon.svg'),
//                         SizedBox(width: 20.w,),
//                         Padding(
//                             padding: EdgeInsets.only(top: 5.h),
//                             child: Text('My Following',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
//                         const Spacer(),
//                         const Icon(Icons.arrow_forward_ios_rounded)
//                       ],
//                     ),
//                   )),
//               onTap: (){
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('This Feature is Coming Soon'))
//                 );
//               },
//             ),
//             // my comment
//             GestureDetector(
//               child: Card(
//                   color: Colors.white,
//                   child: Padding(
//                     padding: EdgeInsets.all(12.h),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SvgPicture.asset('res/images/CommentsProfileScreen.svg'),
//                         SizedBox(width: 20.w,),
//                         Padding(
//                             padding: EdgeInsets.only(top: 5.h),
//                             child: Text("My Comment's",style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
//                         const Spacer(),
//                         const Icon(Icons.arrow_forward_ios_rounded)
//                       ],
//                     ),
//                   )),
//               onTap: (){
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('This Feature is Coming Soon'))
//                 );
//               },
//             ),
//             // how to use
//             GestureDetector(
//               child: Card(
//                   color: Colors.white,
//                   child: Padding(
//                     padding: EdgeInsets.all(12.h),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SvgPicture.asset('res/images/AboutUsProfileScreen.svg'),
//                         SizedBox(width: 20.w,),
//                         Padding(
//                             padding: EdgeInsets.only(top: 5.h),
//                             child: Text('How To Use?',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
//                         const Spacer(),
//                         const Icon(Icons.arrow_forward_ios_rounded)
//                       ],
//                     ),
//                   )),
//               onTap: (){
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("This Feature is Coming Soon"))
//                 );
//               },
//             ),
//             // privacy policy
//             GestureDetector(
//               child: Card(
//                   color: Colors.white,
//                   child: Padding(
//                     padding: EdgeInsets.all(12.h),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SvgPicture.asset('res/images/ic_outline-privacy-tip.svg'),
//                         SizedBox(width: 20.w,),
//                         Padding(
//                             padding: EdgeInsets.only(top: 5.h),
//                             child: Text('Privacy Policy',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
//                         const Spacer(),
//                         const Icon(Icons.arrow_forward_ios_rounded)
//                       ],
//                     ),
//                   )),
//               onTap: (){
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('This Feature is Coming Soon'))
//                 );
//               },
//             ),
//             // setting
//             GestureDetector(
//               child: Card(
//                   color: Colors.white,
//                   child: Padding(
//                     padding: EdgeInsets.all(12.h),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SvgPicture.asset('res/images/uil_setting.svg'),
//                         SizedBox(width: 20.w,),
//                         Padding(
//                             padding: EdgeInsets.only(top: 5.h),
//                             child: Text('Setting',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
//                         const Spacer(),
//                         const Icon(Icons.arrow_forward_ios_rounded)
//                       ],
//                     ),
//                   )),
//               onTap: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen(),),);
//                 },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
