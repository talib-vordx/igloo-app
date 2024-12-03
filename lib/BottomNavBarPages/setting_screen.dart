import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:igloo/wraper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  final user = FirebaseAuth.instance.currentUser;
  SignOut() async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: const Icon(Icons.arrow_back_ios_new)),
            SizedBox(width: 100.w,),
            Text('Setting',style: TextStyle(fontSize: 26.sp,fontWeight: FontWeight.w700,color: Colors.black),),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          MaterialButton(onPressed: (){},child:  Container(
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color:  Colors.white),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  // spreadRadius: 1,
                  blurRadius: 3,
                  // offset: Offset(0, 4), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('res/images/bell.svg'),
                  SizedBox(width: 20.w,),
                  Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Text('Notification',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded)
                ],
              ),
            ),
          ),),
          SizedBox(height: 10.h,),
          MaterialButton(onPressed: (){},child: Container(
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color:  Colors.white),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  // spreadRadius: 1,
                  blurRadius: 3,
                  // offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('res/images/bell.svg'),
                  SizedBox(width: 20.w,),
                  Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Text('Comment Notification',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded)
                ],
              ),
            ),
          ),),
          SizedBox(height: 10.h,),
          MaterialButton(onPressed: (){},child: Container(
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color:  Colors.white),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  // spreadRadius: 1,
                  blurRadius: 3,
                  // offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('res/images/contect.svg'),
                  SizedBox(width: 20.w,),
                  Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Text('Contact Us',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded)
                ],
              ),
            ),
          ),),
          SizedBox(height: 10.h,),
          MaterialButton(onPressed: (){},child: Container(
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color:  Colors.white),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  // spreadRadius: 1,
                  blurRadius: 3,
                  // offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('res/images/delateaccount.svg'),
                  SizedBox(width: 20.w,),
                  Padding(
                      padding: EdgeInsets.only(top: 5.h),
                      child: Text("Delete Account",style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded)
                ],
              ),
            ),
          ),),

        ],
      ),
    );
  }
}

