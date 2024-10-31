import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'first_screen_Home.dart';
class PostCreateScreen extends StatelessWidget {
  const PostCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 130.h,
        title: Row(
          children: [
            IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/CencelButton.svg',),),
            Spacer(),
            Text('Create Post',style: TextStyle(fontSize: 24.sp,fontWeight: FontWeight.w700,color: Colors.black),),
            Spacer(),
            IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/tabler_send.svg',),),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.r),
        child: Container(
          height: 600.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                blurRadius: 3,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 40.h,left: 15.w),
                  child: Row(
                    children: [
                      Image.asset('res/images/appicon.png',height: 70.h,width: 70.w,),
                      SizedBox(width: 10.w,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 180.w,child: TextField(
                            decoration: new InputDecoration.collapsed(
                                hintText: 'Type a Pseudonym..'
                            ),
                          ),),
                          SizedBox(
                            // height: 50.h,
                            width:250.w,
                            // height: 300.h,
                            child: TextFormField(
                              decoration: InputDecoration(
                                  // border: OutlineInputBorder(
                                  //     borderRadius: BorderRadius.circular(10.r),
                                  //     borderSide: BorderSide(width: 0.8.w)
                                  // ),
                                  hintText: 'Uni help? Secret Crush? Confession? \n Share what’s on your mind...',
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h,),
                          Row(
                            children: <Widget>[
                              SvgPicture.asset('res/images/Post1nd.svg'),
                              SizedBox(width: 25.w,),
                              SvgPicture.asset('res/images/Post2nd.svg'),
                              SizedBox(width: 25.w,),
                              SvgPicture.asset('res/images/Post3nd.svg'),
                              SizedBox(width: 25.w,),
                              SvgPicture.asset('res/images/Post4nd.svg'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60.h,),
                Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      MaterialButton(
                        color: const Color(0xFF27D4C1),
                        minWidth: 140.w,
                        height: 45.h,
                        onPressed: (){},
                        child: const Text('POST',style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
