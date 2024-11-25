  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:get/get.dart';
  import 'package:get/get_core/src/get_main.dart';

  class ForgetPassword extends StatefulWidget {
    const ForgetPassword({super.key});

    @override
    State<ForgetPassword> createState() => _ForgetPasswordState();
  }

  class _ForgetPasswordState extends State<ForgetPassword> {
    TextEditingController email= TextEditingController();

    Reset()async{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text).then((value) => {
        Get.snackbar('Request Send Successfully', 'Open Your Mail and Reset Your Password',margin: EdgeInsets.all(30),snackPosition: SnackPosition.TOP),
      });
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color(0xff27D4C1),
          title: const Text('Forget Password',style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  "https://img.freepik.com/free-vector/emails-concept-illustration_114360-1355.jpg?w=1380&t=st=1673699432~exp=1673700032~hmac=d65454eb5c72e8310209bf8ae770f849ea388f318dc6b9b1300b24b03e8886ca",
                  height: 350,
                ),
              ),
              SizedBox(height: 30.h,),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration:  InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter Email here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (email){
                  if(email==null || email.isEmpty){
                    return 'Enter Email';
                  }
                  else if(!RegExp(r'^[\w\-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$').hasMatch(email)){
                    return 'Enter Right Mail';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30.h,),
              MaterialButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                    onPressed: (){
                    Reset();
              }, child: Ink(
                decoration: BoxDecoration(
                  gradient:  LinearGradient(
                      begin: Alignment.topCenter,  // Starting from top-left
                      end: Alignment.bottomCenter, // Ending at bottom-right
                      colors: [
                        Color(0xff27D4C1),
                        Colors.black,
                      ]
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Container(
                  width: 150.w,
                  constraints:  BoxConstraints(minWidth: 50.w, minHeight: 60.h),
                  alignment: Alignment.center,
                  child:  Text(
                    'Send Link',
                    style: TextStyle(color: Colors.white, fontSize: 18.sp),
                  ),
                ),
              )),
            ],
          ),
        ),
      );
    }
  }
