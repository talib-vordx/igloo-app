import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:igloo/wraper.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});
  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  bool isLoading = false; // Track loading state

  @override
  void initState() {
    sendVerifyinglink();
    super.initState();
  }

  sendVerifyinglink() async {
    setState(() {
      isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser!;
    try {
      await user.sendEmailVerification();
      Get.snackbar(
        'Link Sent',
        'Verification link has been sent to your email.',
        margin: EdgeInsets.all(30),
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        margin: EdgeInsets.all(30),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  reload() async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.currentUser!.reload();
      Get.offAll(const Wraper());
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        margin: EdgeInsets.all(30),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xff27D4C1),
        title: const Text(
          'Verify Yourself',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Show loader
      )
          : Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Email verification link has been sent successfully to your entered email address. Open your email and verify yourself. After verifying, come back and click the button below ⬇️",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            MaterialButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                reload();
              },
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff27D4C1),
                      Colors.black,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Container(
                  width: 180.w,
                  constraints:
                  BoxConstraints(minWidth: 50.w, minHeight: 60.h),
                  alignment: Alignment.center,
                  child: Text(
                    'Go to Home',
                    style: TextStyle(
                        color: Colors.white, fontSize: 18.sp),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
