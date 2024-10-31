import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:igloo/pages/first_screen_Home.dart';
import 'package:igloo/pages/fourth_screen_profile.dart';
import 'package:igloo/pages/post_create_screen.dart';
import 'package:igloo/pages/sceond_screen_Search.dart';
import 'package:igloo/pages/third_screen_Notification.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screens = [
    FirstScreen(),
    SceondScreenSearch(),
    ThirdScreenNotification(),
    FourthScreenProfile(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = FirstScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: PageStorage(bucket: bucket, child: currentScreen,),

      // floating + Button
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Color(0xFF27D4C1),
        onPressed: (){
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PostCreateScreen(),),);
        },
        child: Icon(Icons.add,color: Colors.white),
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          // decoration: const BoxDecoration(
          //   borderRadius:BorderRadius.only(
          //     bottomLeft: Radius.circular(50),
          //     bottomRight: Radius.circular(100),
          //   ),
          // ),
          height: 60.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    minWidth: 40.w,
                    onPressed: (){
                      setState(() {
                        currentScreen = FirstScreen();
                        currentTab = 0;
                      });
                    },
                    child:SizedBox(height: 40.h,width: 40.w,child: SvgPicture.asset('res/images/Homebutton.svg',color: currentTab == 0 ? Color(0xFF27D4C1) : Colors.grey,),),
                  ),
                  MaterialButton(
                    splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      minWidth: 40.w,
                    onPressed: (){
                      setState(() {
                        currentScreen = SceondScreenSearch();
                        currentTab = 1;
                      });
                    },
                    child:SizedBox(height: 40.h,width: 40.w,child: SvgPicture.asset('res/images/SearchButton.svg',color: currentTab == 1 ? Color(0xFF27D4C1) : Colors.grey,),)
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    minWidth: 40.w,
                    onPressed: (){
                      setState(() {
                        currentScreen = ThirdScreenNotification();
                        currentTab = 2;
                      });
                    },
                    child: SizedBox(height: 40.h,width: 40.w,child: SvgPicture.asset('res/images/Notficationbutton.svg',color: currentTab == 2 ? Color(0xFF27D4C1) : Colors.grey,),),
                  ),
                  MaterialButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    minWidth: 40.w,
                    onPressed: (){
                      setState(() {
                        currentScreen = FourthScreenProfile();
                        currentTab = 3;
                      });
                    },
                    child: SizedBox(height: 40.h,width: 40.w,child: SvgPicture.asset('res/images/ProfileButton.svg',color: currentTab == 3 ? Color(0xFF27D4C1) : Colors.grey,),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
