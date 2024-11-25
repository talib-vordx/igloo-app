import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:igloo/Notification/notification.dart';
import 'package:igloo/pages/first_screen_home.dart';
import 'package:igloo/pages/fourth_screen_profile.dart';
import 'package:igloo/pages/sceond_screen_search.dart';
import 'package:igloo/pages/third_screen_notification.dart';
import 'Create_and_Post/post_create_screen.dart';



class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  int currentTab = 0;
  final List<Widget> screens = [
    const FirstScreen(),
    const SceondScreenSearch(),
    const ThirdScreenNotification(),
    const FourthScreenProfile(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const FirstScreen();

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit();
    notificationServices.getDeviceToken().then((value){
      print('Device Token');
      print(value);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentScreen,),

      // floating + Button
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF27D4C1),
        onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context) =>  PostCreateScreen(),),);
        },
        child: const Icon(Icons.add,color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius:BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(100),
            ),
          ),
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
                        currentScreen = const FirstScreen();
                        currentTab = 0;
                      });
                    },
                    child:SizedBox(height: 40.h,width: 40.w,child: SvgPicture.asset('res/images/Homebutton.svg',color: currentTab == 0 ? const Color(0xFF27D4C1) : Colors.grey,),),
                  ),
                  MaterialButton(
                    splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      minWidth: 40.w,
                    onPressed: (){
                      setState(() {
                        currentScreen = const SceondScreenSearch();
                        currentTab = 1;
                      });
                    },
                    child:SizedBox(height: 40.h,width: 40.w,child: SvgPicture.asset('res/images/SearchButton.svg',color: currentTab == 1 ? const Color(0xFF27D4C1) : Colors.grey,),)
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
                        currentScreen = const ThirdScreenNotification();
                        currentTab = 2;
                      });
                    },
                    child: SizedBox(height: 40.h,width: 40.w,child: SvgPicture.asset('res/images/NewNotificationIcon.svg',color: currentTab == 2 ? const Color(0xFF27D4C1) : Colors.grey,),),
                  ),
                  MaterialButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    minWidth: 40.w,
                    onPressed: (){
                      setState(() {
                        currentScreen = const FourthScreenProfile();
                        currentTab = 3;
                      });
                    },
                    child: SizedBox(height: 40.h,width: 40.w,child: SvgPicture.asset('res/images/ProfileButton.svg',color: currentTab == 3 ? const Color(0xFF27D4C1) : Colors.grey,),),
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
