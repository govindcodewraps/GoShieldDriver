import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../controller/phone_number_controller.dart';
import '../../themes/button_them.dart';
import '../../themes/constant_colors.dart';
import '../../themes/text_field_them.dart';
import '../auth_screens/otp_screen.dart';
import 'package:http/http.dart' as http;

import 'emailotpscreen.dart';


class EmailScreen extends StatelessWidget {
  //final bool? isLogin;

 // EmailScreen({super.key, required this.isLogin});

  final controller = Get.put(PhoneNumberController());
  static final _emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.background,
      body: SafeArea(
        child: Container(
          height: Get.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/login_bg.png",
              ),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          // isLogin == true
                          //     ? "Login Phone".tr
                          //     :
                          "Signup With Email".tr,
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
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 80),
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //         border: Border.all(
                        //           color: ConstantColors.textFieldBoarderColor,
                        //         ),
                        //         borderRadius:
                        //         const BorderRadius.all(Radius.circular(6))),
                        //     padding: const EdgeInsets.only(left: 10),
                        //     child: IntlPhoneField(
                        //       onChanged: (phone) {
                        //         controller.phoneNumber.value =
                        //             phone.completeNumber;
                        //       },
                        //       invalidNumberMessage: "number invalid",
                        //       showDropdownIcon: false,
                        //       disableLengthCheck: true,
                        //       decoration: InputDecoration(
                        //         contentPadding:
                        //         const EdgeInsets.symmetric(vertical: 12),
                        //         hintText: 'Phone Number'.tr,
                        //         border: InputBorder.none,
                        //         isDense: true,
                        //       ),
                        //     ),
                        //   ),
                        // ),


                        TextFieldThem.boxBuildTextField(
                          hintText: 'email'.tr,
                          controller: _emailController,
                          textInputType: TextInputType.emailAddress,
                          contentPadding: EdgeInsets.zero,
                          validators: (String? value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return 'required'.tr;
                            }
                          },
                        ),

                        Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: ButtonThem.buildButton(
                              context,
                              title: 'Continue'.tr,
                              btnHeight: 50,
                              btnColor: ConstantColors.primary,
                              txtColor: Colors.white,
                              onPress: () async {

                                email(_emailController.text,context);
                                print("Email ${_emailController.text}");

                               // Navigator.push(context,MaterialPageRoute(builder: (context)=>OtpScreen(email: _emailController.text,)));

                                // FocusScope.of(context).unfocus();
                                // if (controller.phoneNumber.value.isNotEmpty) {
                                //   ShowToastDialog.showLoader("Code sending".tr);
                                //   controller.sendCode(controller.phoneNumber.value);
                                // }
                              },
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: ButtonThem.buildButton(
                              context,
                              title: 'Login With Email'.tr,
                              btnHeight: 50,
                              btnColor: ConstantColors.yellow,
                              txtColor: Colors.white,
                              onPress: () {
                                FocusScope.of(context).unfocus();
                                Get.back();
                              },
                            )),
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
  //
  Future<void> email(emaill,context) async {
    try {
      var headers = {
        'Content-Type': 'application/json'
      };
      var request = http.Request('POST', Uri.parse('https://cab.codewraps.com/admin/api/v1/send-email-otp/'));
      request.body = json.encode({
        "email": emaill,
        "user_cat": "driver"
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(await response.stream.bytesToString());
        var otp = jsonResponse['data']['otp']; // Extracting the OTP value
        print('OTP: $otp');

        Navigator.push(context,MaterialPageRoute(builder: (context)=>EmailOtpScreen(email: _emailController.text,otpp:otp)));


      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email Already exists'),
        ),
      );
    }
  }




}
