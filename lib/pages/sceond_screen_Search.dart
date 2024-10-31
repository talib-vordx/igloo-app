import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'custom_items.dart';

class SceondScreenSearch extends StatelessWidget {
  const SceondScreenSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.pinkAccent,
      appBar:  AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 130.h,
        title: Row(
          children: [
            IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/CencelButton.svg',),),
            // SizedBox(width: 10.w,),
            SizedBox(
               // height: 50.h,
              width:270.w,
              child: TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(width: 0.8.w)
                    ),
                    hintText: '#Econ101',
                    prefixIcon: Icon(Icons.search,size: 40.sp,)
                ),
              ),
            ),
            SizedBox(width: 18.w,),
            IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/tabler_send.svg',),),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              DrictMessageCard(),
              SizedBox(height: 15.h,),
              DrictMessageCard(),
              SizedBox(height: 15.h,),
              DrictMessageCard(),
              SizedBox(height: 15.h,),
              DrictMessageCard(),
              SizedBox(height: 15.h,),
              DrictMessageCard(),
              SizedBox(height: 15.h,),
            ],
          ),
        ),
      ),
    );
  }
}
