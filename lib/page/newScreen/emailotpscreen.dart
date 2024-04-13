// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../../themes/constant_colors.dart';
import '../auth_screens/signup_screen.dart';

class EmailOtpScreen extends StatelessWidget {
  String? phoneNumber;
  String? verificationId;
  String? email;
  int? otpp;

  EmailOtpScreen(
      {super.key,this.phoneNumber,this.verificationId,this.email,this.otpp});

 // final controller = Get.put(PhoneNumberController());
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ConstantColors.background,
      body: SafeArea(
        child: Container(
          height: Get.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/login_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Text("${phoneNumber}"),
                        // Text("${email}"),
                        // Text("${otpp}"),

                        Text(
                          "Enter OTP".tr,
                          style: const TextStyle(
                              letterSpacing: 0.60,
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                            width: 80,
                            child: Divider(
                              color: ConstantColors.yellow1,
                              thickness: 3,
                            )),



                        OtpTextField(
                          numberOfFields: 6,
                          borderColor: Color(0xFF512DA8),
                          showFieldAsBox: true,
                          onCodeChanged: (String code) {
                            // Handle validation or checks here
                          },
                          onSubmit: (String verificationCode) {
                            if (verificationCode == otpp.toString()) {

                              Get.off(SignupScreen(
                                phoneNumber: phoneNumber.toString(),
                                emailId: email.toString(),
                              ));
                              //Get.to(() => AddProfilePhotoScreen());
                            } else {
                              Fluttertoast.showToast(
                                msg: "OTP does not match",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              // Clear the OTP text field
                              textEditingController.text = '';
                            }
                          },
                        ),

                        // Padding(
                        //     padding: const EdgeInsets.only(top: 40),
                        //     child: ButtonThem.buildButton(
                        //       context,
                        //       title: 'done'.tr,
                        //       btnHeight: 50,
                        //       btnColor: ConstantColors.primary,
                        //       txtColor: Colors.white,
                        //       onPress: () async {
                        //
                        //       },
                        //     ))
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.black,
                        ),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
