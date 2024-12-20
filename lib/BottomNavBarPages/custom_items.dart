import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';



// First Custom Card for Home Screen First Tab(Top)
class FirstActivatiesCard extends StatelessWidget{
  const FirstActivatiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 240.h,
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: const Color(0xFF1D4184)),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    PhysicalModel(color: Colors.grey, clipBehavior: Clip.antiAlias, shape: BoxShape.circle, child: Image.asset('res/images/appicon.png', width: 45.w, height:45.w, fit: BoxFit.cover,)),
                    SizedBox(width: 12.h,),
                    Column(
                      children: [
                        Text("Talib Jameel",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),),
                        SizedBox(height: 2.h,),
                        const Text("09:04 am")
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.h,),
             //   Container(height: 80.h,width: 300.w,child: Expanded(child:Text("GOOD LUCK FOR THE #Econ101 EXAM EVERYBODY!!!",textAlign: TextAlign.start,style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w500),)),),
                Row(
                  children: <Widget>[
                    IconButton(onPressed: (){
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => const CommentScreen(),),);
                    }, icon: SizedBox(height: 30.h,width: 30.w,child: SvgPicture.asset('res/images/commentbutton.svg',),)),
                    const Text("12",style: TextStyle(fontWeight: FontWeight.w700),),
                    SizedBox(width: 20.w,),
                    IconButton(onPressed: (){}, icon: SizedBox(height: 30.h,width: 30.w,child: SvgPicture.asset('res/images/Vector.svg',),)),
                    const Text("14",style: TextStyle(fontWeight: FontWeight.w700),),
                    SizedBox(width: 20.w,),
                    IconButton(onPressed: (){
                   //   Navigator.push(context, MaterialPageRoute(builder: (context)=> const DirectMessage(),),);
                    }, icon: SizedBox(height: 30.h,width: 30.w,child: SvgPicture.asset('res/images/forwaedbutton.svg',),)),

                  ],
                ),
              ],
            ),
            SizedBox(width: 35.w,),
            Column(
              children: [
                IconButton(onPressed: (){
                  showCustomDialog(context);
                }, icon: Icon(Icons.flag_outlined,size: 35.sp,),),
                //Icon(Icons.flag_outlined),
                SizedBox(height: 20.h,),
                Icon(Icons.keyboard_arrow_up,size: 41.sp,),
                Text("25",style: TextStyle(fontSize: 30.sp,fontWeight: FontWeight.bold,color: const Color(0xFF27D4C1),),),
                Icon(Icons.keyboard_arrow_down_outlined,size: 41.sp,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Second Custom Card for Home Screen First Tab(Top)
class SecondActivatiesCard extends StatelessWidget{
  const SecondActivatiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 240.h,
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: const Color(0xFF1D4184)),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            // spreadRadius: 1,
            // blurRadius: 3,
            // offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    PhysicalModel(color: Colors.grey, clipBehavior: Clip.antiAlias, shape: BoxShape.circle, child: Image.asset('res/images/appicon.png', width: 45.w, height:45.w, fit: BoxFit.cover,)),
                    SizedBox(width: 12.h,),
                    Column(
                      children: [
                        Text("Pizza hater guy",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),),
                        SizedBox(height: 2.h,),
                        const Text("12:04 am")
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.h,),
                SizedBox(height: 80.h,width: 300.w,child: Expanded(child:Text("Is the pizza in the canteen even considered edible? 🍕",textAlign: TextAlign.start,style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w500),)),),
                Row(
                  children: <Widget>[
                    IconButton(onPressed: (){
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => const CommentScreen(),),);
                    }, icon: SizedBox(height: 30.h,width: 30.w,child: SvgPicture.asset('res/images/commentbutton.svg',),)),
                    const Text("24",style: TextStyle(fontWeight: FontWeight.w700),),
                    SizedBox(width: 20.w,),
                    IconButton(onPressed: (){}, icon: SizedBox(height: 30.h,width: 30.w,child: SvgPicture.asset('res/images/Vector.svg',),)),
                    const Text("13",style: TextStyle(fontWeight: FontWeight.w700),),
                    SizedBox(width: 20.w,),
                    IconButton(onPressed: (){
                     // Navigator.push(context, MaterialPageRoute(builder: (context)=> const DirectMessage(),),);
                    }, icon: SizedBox(height: 30.h,width: 30.w,child: SvgPicture.asset('res/images/forwaedbutton.svg',),)),

                  ],
                ),
              ],
            ),
            SizedBox(width: 35.w,),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: (){showCustomDialog(context);}, icon: Icon(Icons.flag_outlined,size: 35.sp,),),
                SizedBox(height: 20.h,),
                Icon(Icons.keyboard_arrow_up,size: 41.sp,),
                Text("67",style: TextStyle(fontSize: 30.sp,fontWeight: FontWeight.bold,color: const Color(0xFF27D4C1),),),
                Icon(Icons.keyboard_arrow_down_outlined,size: 41.sp,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Third Custom Card for Home Screen First Tab(Top)
class ThirdActivatiesCard extends StatelessWidget{
  const ThirdActivatiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 560.h,
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: const Color(0xFF1D4184)),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            // spreadRadius: 1,
            // blurRadius: 3,
            // offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: <Widget>[
                        PhysicalModel(color: Colors.grey, clipBehavior: Clip.antiAlias, shape: BoxShape.circle, child: Image.asset('res/images/footballCardimg.png', width: 50.w, height:50.w, fit: BoxFit.cover,)),
                        SizedBox(width: 12.h,),
                        Column(
                          children: [
                            Text("Pizza hater guy",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),),
                            SizedBox(height: 2.h,),
                            const Text("03:00 PM")
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h,),
                    Text("Need numbers for sunday kickabout",textAlign: TextAlign.start,style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w700),),
                  ],
                ),
                SizedBox(width: 40.w,),
                Column(
                  children: [
                    Icon(Icons.keyboard_arrow_up,size: 41.sp,),
                    Text("327",style: TextStyle(fontSize: 30.sp,fontWeight: FontWeight.bold,color: const Color(0xFF27D4C1),),),
                    Icon(Icons.keyboard_arrow_down_outlined,size: 41.sp,)
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h,),
            VotingCard(),
            SizedBox(height: 10.h,),
            Row(
              children: <Widget>[
                IconButton(onPressed: (){}, icon: SizedBox(height: 30.h,width: 30.w,child: SvgPicture.asset('res/images/commentbutton.svg',),)),
                const Text("24",style: TextStyle(fontWeight: FontWeight.w700),),
                SizedBox(width: 20.w,),
                IconButton(onPressed: (){}, icon: SizedBox(height: 30.h,width: 30.w,child: SvgPicture.asset('res/images/Vector.svg',),)),
                const Text("13",style: TextStyle(fontWeight: FontWeight.w700),),
                SizedBox(width: 20.w,),
                IconButton(onPressed: (){}, icon: SizedBox(height: 30.h,width: 30.w,child: SvgPicture.asset('res/images/forwaedbutton.svg',),)),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
//for third card
class VotingCard extends StatelessWidget {
  final List<VoteOption> options = [
    VoteOption("Yes", 140, 0.4),
    VoteOption("No", 180, 0.5),
    VoteOption("Maybe", 116, 0.3),
    VoteOption("Won't play but spectate", 250, 0.7),
  ];

  VotingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 315.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1), // Light background color for the card
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: options.map((option) => buildOptionRow(option)).toList(),
      ),
    );
  }

  Widget buildOptionRow(VoteOption option) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.white, // White background for each row
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFD0D0D0), width: 1), // Light grey border
        ),
        child: Stack(
          children: [
            // Progress Fill
            FractionallySizedBox(
              widthFactor: option.percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[350], // Purple fill color
                  borderRadius: BorderRadius.circular(11.r),
                ),
              ),
            ),
            // Text and Vote Information
            Padding(
               padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Center(child: Text(
                   option.label,
                   style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black87),
                 ) ,),
                  Row(
                    children: [
                      Text(
                        "${option.votes} Votes",
                        style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "${(option.percentage * 100).toStringAsFixed(0)}%",
                        style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Model class for vote options
class VoteOption {
  final String label;
  final int votes;
  final double percentage;

  VoteOption(this.label, this.votes, this.percentage);
}


// Dialog Box for Every Card
void showCustomDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true, // Closes the dialog when tapped outside
    barrierLabel: "Custom Alert",
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return GestureDetector(
        onTap: (){
          Navigator.pop(context);
          },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.topRight, // Positions the dialog at the top right
            child: Padding(
              padding: EdgeInsets.only(top: 150.h, right: 20.w), // Adjusts distance from top and right edges
              child: Container(
                width: 180.w,
                height: 155.h,// Custom width of the dialog
                padding: EdgeInsets.all(10.w.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.r,
                      // offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const CustomAlertBoxContent(),
              ),
            ),
          ),
        ),
      );
    },
  );
}
// CustomAlertBoxContent Extend the functionality of showCustomDialog
class CustomAlertBoxContent extends StatelessWidget {
  const CustomAlertBoxContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
        children: [
          IconButton(onPressed: (){}, icon: Icon(Icons.report,size: 30.sp,)),
          Text("Report",style: TextStyle(fontSize: 25.sp,color: Colors.black),),
        ],
      ),
        Row(
          children: [
            IconButton(onPressed: (){}, icon: Icon(Icons.block,size: 30.sp,)),
            Text("Block",style: TextStyle(fontSize: 25.sp,color: Colors.black,)),
          ],
        ),
      ],
    );
  }
}

//Drict Message Dcreen Card
class DrictMessageCard extends StatelessWidget{
  const DrictMessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 175.h,
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: const Color(0xFF1D4184)),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            // spreadRadius: 1,
            blurRadius: 1,
            //offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                PhysicalModel(color: Colors.grey, clipBehavior: Clip.antiAlias, shape: BoxShape.circle, child: Image.asset('res/images/appicon.png', width: 45.w, height:45.w, fit: BoxFit.cover,)),
                SizedBox(width: 12.h,),
                Column(
                  children: [
                    Text("Talib Jameel",style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.bold),),
                    SizedBox(height: 2.h,),
                    const Text("09:04 am")
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.h,),
            Text("GOOD LUCK FOR THE #Econ101 EXAM EVERYBODY!!!",textAlign: TextAlign.start,style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w500),),],
        ),
      ),
    );
  }
}

// Notification Card for Notifiction Screen
class NotificationCard extends StatelessWidget{
  const NotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 130.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PhysicalModel(color: Colors.grey, clipBehavior: Clip.antiAlias, shape: BoxShape.circle, child: Image.asset('res/images/notificationCardIcon.png', width: 60.w, height:60.w, fit: BoxFit.cover,)),
                SizedBox(width: 12.h,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width:275.w ,child:Text("Anonymous commented” I get what you saying” on your post",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold),),),
                    SizedBox(height: 10.h,),
                    const Text("09:04 am",textAlign: TextAlign.start,)
                  ],
                ),
                IconButton(onPressed: (){}, icon:SvgPicture.asset('res/images/ThreeDotButtonVertical.svg',),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


