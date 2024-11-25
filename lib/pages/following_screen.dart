import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({super.key});

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
            Text('Following',style: TextStyle(fontSize: 26.sp,fontWeight: FontWeight.w700,color: Colors.black),),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 50.h,left: 20.w,right: 20.w),
        child: Container(
          height: 750.h,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                blurRadius: 3,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 20.h,left: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("My Followings",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24.sp,color: Colors.black),),
                SizedBox(height: 40.h,),
                Row(
                  children: [
                    PhysicalModel(color: Colors.grey, clipBehavior: Clip.antiAlias, shape: BoxShape.circle, child: Image.asset('res/images/appicon.png', width: 55.w, height:55.w, fit: BoxFit.cover,)),
                    SizedBox(width: 15.w,),
                    Text("#Ecin101",style: TextStyle(fontSize: 14.sp,color: Colors.black,fontWeight: FontWeight.bold),),
                    const Spacer(),
                    MaterialButton(height:40.h,minWidth: 80.w,color:const Color(0xFF27D4C1),onPressed: (){},child: const Text('Remove',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),),
                    // SizedBox(width: 15.w,),
                    IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/ThireDotButton.svg',),),
                  ],
                ),
                SizedBox(height: 20.h,),
                Row(
                  children: [
                    PhysicalModel(color: Colors.grey, clipBehavior: Clip.antiAlias, shape: BoxShape.circle, child: Image.asset('res/images/appicon.png', width: 55.w, height:55.w, fit: BoxFit.cover,)),
                    SizedBox(width: 15.w,),
                    Expanded(child: Text("Aston Football Society",style: TextStyle(fontSize: 14.sp,color: Colors.black,fontWeight: FontWeight.bold),),),
                    MaterialButton(height:40.h,minWidth: 30.w,color:const Color(0xFF27D4C1),onPressed: (){},child: const Text('Remove',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),),
                    IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/ThireDotButton.svg',),),
                  ],
                ),
                SizedBox(height: 20.h,),
                Row(
                  children: [
                    PhysicalModel(color: Colors.grey, clipBehavior: Clip.antiAlias, shape: BoxShape.circle, child: Image.asset('res/images/appicon.png', width: 55.w, height:55.w, fit: BoxFit.cover,)),
                    SizedBox(width: 15.w,),
                    Expanded(child: Text("#BusinessManagment",style: TextStyle(fontSize: 14.sp,color: Colors.black,fontWeight: FontWeight.bold),),),
                    MaterialButton(height:40.h,minWidth: 30.w,color:const Color(0xFF27D4C1),onPressed: (){},child: const Text('Remove',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),),
                    IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/ThireDotButton.svg',),),
                  ],
                ),
                SizedBox(height: 20.h,),
                Row(
                  children: [
                    PhysicalModel(color: Colors.grey, clipBehavior: Clip.antiAlias, shape: BoxShape.circle, child: Image.asset('res/images/appicon.png', width: 55.w, height:55.w, fit: BoxFit.cover,)),
                    SizedBox(width: 15.w,),
                    Expanded(child: Text("#IBAM",style: TextStyle(fontSize: 14.sp,color: Colors.black,fontWeight: FontWeight.bold),),),
                    MaterialButton(height:40.h,minWidth: 30.w,color:const Color(0xFF27D4C1),onPressed: (){},child: const Text('Remove',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),),
                    IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/ThireDotButton.svg',),),
                  ],
                ),
                SizedBox(height: 20.h,),
                Row(
                  children: [
                    PhysicalModel(color: Colors.grey, clipBehavior: Clip.antiAlias, shape: BoxShape.circle, child: Image.asset('res/images/appicon.png', width: 55.w, height:55.w, fit: BoxFit.cover,)),
                    SizedBox(width: 15.w,),
                    Expanded(child: Text("#History101",style: TextStyle(fontSize: 14.sp,color: Colors.black,fontWeight: FontWeight.bold),),),
                    MaterialButton(height:40.h,minWidth: 30.w,color:const Color(0xFF27D4C1),onPressed: (){},child: const Text('Remove',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),),
                    IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/ThireDotButton.svg',),),
                  ],
                ),
                SizedBox(height: 20.h,),
                Row(
                  children: [
                    PhysicalModel(color: Colors.grey, clipBehavior: Clip.antiAlias, shape: BoxShape.circle, child: Image.asset('res/images/appicon.png', width: 55.w, height:55.w, fit: BoxFit.cover,)),
                    SizedBox(width: 15.w,),
                    Expanded(child: Text("#IntroToAccounting",style: TextStyle(fontSize: 14.sp,color: Colors.black,fontWeight: FontWeight.bold),),),
                    MaterialButton(height:40.h,minWidth: 30.w,color:const Color(0xFF27D4C1),onPressed: (){},child: const Text('Remove',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),),
                    IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/ThireDotButton.svg',),),
                  ],
                ),
                SizedBox(height: 20.h,),
                Row(
                  children: [
                    PhysicalModel(color: Colors.grey, clipBehavior: Clip.antiAlias, shape: BoxShape.circle, child: Image.asset('res/images/appicon.png', width: 55.w, height:55.w, fit: BoxFit.cover,)),
                    SizedBox(width: 15.w,),
                    Expanded(child: Text("#MathForEcon",style: TextStyle(fontSize: 14.sp,color: Colors.black,fontWeight: FontWeight.bold),),),
                    MaterialButton(height:40.h,minWidth: 30.w,color:const Color(0xFF27D4C1),onPressed: (){},child: const Text('Remove',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),),
                    IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/ThireDotButton.svg',),),
                  ],
                ),
                SizedBox(height: 20.h,),
                Row(
                  children: [
                    PhysicalModel(color: Colors.grey, clipBehavior: Clip.antiAlias, shape: BoxShape.circle, child: Image.asset('res/images/appicon.png', width: 55.w, height:55.w, fit: BoxFit.cover,)),
                    SizedBox(width: 15.w,),
                    Expanded(child: Text("#Marketing101",style: TextStyle(fontSize: 14.sp,color: Colors.black,fontWeight: FontWeight.bold),),),
                    MaterialButton(height:40.h,minWidth: 30.w,color:const Color(0xFF27D4C1),onPressed: (){},child: const Text('Remove',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),),
                    IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/ThireDotButton.svg',),),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
