import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'custom_items.dart';
import 'messageScreen.dart';

class FirstScreen extends StatefulWidget{
  const FirstScreen({super.key});
  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> with TickerProviderStateMixin {

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener((){
      setState(() {
      });
    });
  }
  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120.h,
        backgroundColor:  Colors.white,
        automaticallyImplyLeading: false,
        title: Padding(
          padding:  EdgeInsets.only(
            top: 56.h,
            bottom: 28.h,
           // left: 20.w,
           // right: 20.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {},
                child: SizedBox(
                  height: 60.h,
                  width: 60.w,
                  child: Image.asset('res/images/splashLogo.png'),
                ),
              ),
              Text('Aston University',style: TextStyle(fontFamily: 'Karla',color: Colors.black,fontWeight: FontWeight.w700,fontSize:26.sp)),
              SizedBox(width: 20.w,),
              Expanded(child: MaterialButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => DriectMessageScreen()));
                },
                child: SizedBox(
                  height: 40.h,
                  width: 40.w,
                  child: SvgPicture.asset('res/images/tabler_send.svg'),
                ),
              ),)
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            TabBar(
              //  isScrollable: true,
                controller: _tabController,
                labelColor: Colors.black, // Active tab color
                unselectedLabelColor: Colors.grey,
                indicator: UnderlineTabIndicator(
                    insets:  EdgeInsets.symmetric(horizontal: 130.w),
                    borderSide: BorderSide(
                      width: 3.w,
                      color: const Color(0xFF27D4C1),
                    )
                ),
                tabs:[
                  Tab(
                   child: Row(
                     children: <Widget>[
                       SizedBox(width: 5.w,),
                       SizedBox(height: 30.h,width: 30  .w,child: SvgPicture.asset('res/images/appfirsticon.svg',color: _tabController.index == 0 ? Colors.black : Colors.grey,),),
                       SizedBox(width: 5.w,),
                       Text('Top',style: TextStyle(fontFamily: '',fontSize: 22.sp,fontWeight: FontWeight.w600),),
                     ],
                   ),
                  ),
                  Tab(
                   child: Row(
                     children: <Widget>[
                       SizedBox(height: 25.h,width: 25.w,child: SvgPicture.asset('res/images/pepicons-pencil_stars.svg',color: _tabController.index == 1 ? Colors.black : Colors.grey,),),
                       SizedBox(width: 5.w,),
                        Text('New',style: TextStyle(fontSize: 22.sp,fontFamily: '',fontWeight: FontWeight.w600),),
                     ],
                   ),
                  ),
                  Tab(
                   child: Row(
                     children: <Widget>[
                       SizedBox(height: 25.h,width: 25.w,child: SvgPicture.asset('res/images/followicon.svg',color: _tabController.index == 2 ? Colors.black : Colors.grey,),),
                       SizedBox(width: 5.w,),
                       Text('Following',style: TextStyle(fontSize: 18.sp,fontFamily: '',fontWeight: FontWeight.w700),),
                     ],
                   ),
                  ),
                ]
            ),

            Expanded(
                child:TabBarView(
                    controller: _tabController,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.h,
                          left: 20.w,
                          right: 20.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.h,),
                            Row(
                              children: [
                              Expanded(child: MaterialButton(
                                color: const Color(0xFF27D4C1),
                                minWidth: 150.w,
                                height: 60.h,
                                onPressed: (){},
                                child: const Text('Day'),
                              ),),
                                SizedBox(width: 10.w,),
                              Expanded(child: MaterialButton(
                                  color: Colors.white,
                                  minWidth: 150.w,
                                  height: 60.h,
                                  onPressed: (){},
                                  child: const Text('Week'),
                                ),),
                                SizedBox(width: 10.w,),
                              Expanded(child: MaterialButton(
                                  color: Colors.white,
                                  minWidth: 150.w,
                                  height: 60.h,
                                  onPressed: (){},
                                  child: const Text('Anytime'),
                                ),),
                             ],
                            ),
                            SizedBox(height: 20.h),
                            _Fisrstcard(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.h,
                          left: 20.w,
                          right: 20.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Fisrstcard(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.h,
                          left: 20.w,
                          right: 20.w,
                        ),
                        child:  _Fisrstcard(),
                      ),
                    ]
                )
            )
          ],
        ),
      ),
    );
  }

  Widget _Fisrstcard(){
    return Expanded(
      child: Container(
        // height: 414.h,
        //  padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FirstActivatiesCard(),
              SizedBox(height: 20.h,),
              SecondActivatiesCard(),
              SizedBox(height: 20.h,),
              ThirdActivatiesCard(),
              SizedBox(height: 20.h,),
              FirstActivatiesCard(),
              SizedBox(height: 20.h,),
              FirstActivatiesCard(),
              SizedBox(height: 20.h,),
              FirstActivatiesCard(),
              SizedBox(height: 20.h,),
              FirstActivatiesCard(),
              SizedBox(height: 20.h,),
              FirstActivatiesCard(),
              SizedBox(height: 20.h,),
              FirstActivatiesCard(),
              SizedBox(height: 20.h,),
              FirstActivatiesCard(),
            ],
          ),
        ),
      ),
    );
  }
}
