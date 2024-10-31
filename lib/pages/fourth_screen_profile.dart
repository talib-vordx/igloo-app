import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FourthScreenProfile extends StatelessWidget {
  const FourthScreenProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.orangeAccent,
      //   title: const Center(child: Text('Profile'),),
      // ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 100.h,
          left: 20.w,
          right: 20.w,
        ),
        child: Column(
          children: <Widget>[
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Profile",style: TextStyle(fontSize: 28.sp,fontWeight: FontWeight.w700,color: Colors.black),),
                    PhysicalModel(color: Colors.grey, clipBehavior: Clip.antiAlias, shape: BoxShape.circle, child: Image.asset('res/images/appicon.png', width: 55.w, height:55.w, fit: BoxFit.cover,)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.h,),
            Column(
              children: [
                Container(
                  height: 200.h,
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
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Your Cred'),
                      Text('75',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 70.sp,color: Color(0xFF27D4C1)),)
                    ],
                  ),
                ),
                SizedBox(height: 35.h,),
                Container(
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
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('res/images/shareButtonProfileScreeen.svg'),
                        SizedBox(width: 20.w,),
                        Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text('Share To Unique Link',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h,),
                Container(
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
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('res/images/MyPostIcon.svg'),
                        SizedBox(width: 20.w,),
                        Padding(
                          padding: EdgeInsets.only(top: 5.h),
                          child: Text('My Posts',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h,),
                Container(
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
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('res/images/MyPostIcon.svg'),
                        SizedBox(width: 20.w,),
                        Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text('New Followers',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h,),
                Container(
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
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('res/images/CommentsProfileScreen.svg'),
                        SizedBox(width: 20.w,),
                        Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text("My Comment's",style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h,),
                Container(
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
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('res/images/AboutUsProfileScreen.svg'),
                        SizedBox(width: 20.w,),
                        Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text('How To Use?',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                       Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h,),
                Container(
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
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('res/images/ic_outline-privacy-tip.svg'),
                        SizedBox(width: 20.w,),
                        Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text('Privacy Policy',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                       Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h,),
                Container(
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
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('res/images/uil_setting.svg'),
                        SizedBox(width: 20.w,),
                        Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text('Setting',style: TextStyle(fontSize: 20.sp,fontWeight:FontWeight.bold),)),
                       Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  ),
                ),


              ],
            ),
          ],
        ),
      ),
    );
  }
}