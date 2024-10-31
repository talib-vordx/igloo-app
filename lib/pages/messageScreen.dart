import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_items.dart';

class DriectMessageScreen extends StatelessWidget {
  const DriectMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        toolbarHeight: 130.h,
        title: Row(
          children: [
            BackButton(
              onPressed: (){
                 Navigator.pop(context,true);
                //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> FirstScreen()));
                },
            ),
            SizedBox(width: 120.w,),
            Text("DM'S",style: TextStyle(fontSize: 24.sp,color: Colors.black,fontWeight: FontWeight.w700),),
            SizedBox(width: 120.w,),
            IconButton(onPressed: (){}, icon: Icon(Icons.menu))
          ],
        ),
      ),
      body: Padding(
        padding:EdgeInsets.all(10) ,
        child: Column(
          children: [
            DrictMessageCard(),
            SizedBox(height: 15.h,),
            DrictMessageCard(),
            SizedBox(height: 15.h,),
            DrictMessageCard(),
            SizedBox(height: 15.h,),
          ],
        )
      )
    );
  }
}
