import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'custom_items.dart';

class ThirdScreenNotification extends StatelessWidget {
  const ThirdScreenNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 130.h,
        title: Row(
          children: [
            BackButton(onPressed: (){},),
            SizedBox(width: 80.w,),
            Text("Notifications",style: TextStyle(fontSize: 24.sp,color: Colors.black,fontWeight: FontWeight.w700),),
            SizedBox(width: 80.w,),
            IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/ThireDotButton.svg',),),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Text('Today',style: TextStyle(fontSize: 28.sp,color: Colors.black26,fontWeight: FontWeight.w700),),
                Spacer(),
                TextButton(onPressed: (){}, child: Text("Clear All",style: TextStyle(color: Color(0xFF27D4C1),),))
              ],
            ),
            SizedBox(height: 10.h,),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  NotificationCard(),
                  SizedBox(height: 6.h,),
                  NotificationCard(),
                  SizedBox(height: 6.h,),
                  NotificationCard(),
                  SizedBox(height: 6.h,),
                  NotificationCard(),
                  SizedBox(height: 6.h,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
