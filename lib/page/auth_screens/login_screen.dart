import 'dart:convert';

import 'package:goshield_driver/constant/show_toast_dialog.dart';
import 'package:goshield_driver/controller/login_conroller.dart';
import 'package:goshield_driver/model/user_model.dart';
import 'package:goshield_driver/page/auth_screens/forgot_password.dart';
import 'package:goshield_driver/page/auth_screens/mobile_number_screen.dart';
import 'package:goshield_driver/page/auth_screens/vehicle_info_screen.dart';
import 'package:goshield_driver/page/dash_board.dart';
import 'package:goshield_driver/themes/button_them.dart';
import 'package:goshield_driver/themes/constant_colors.dart';
import 'package:goshield_driver/themes/text_field_them.dart';
import 'package:goshield_driver/utils/Preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../newScreen/signupwithemail.dart';
import 'document_verify_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(LoginController());
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final _emailController = TextEditingController();
  static final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.background,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Login with Email".tr,
                    style: const TextStyle(
                        letterSpacing: 0.60,
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                      width: 80,
                      child: Divider(
                        color: ConstantColors.primary,
                        thickness: 3,
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            padding: const EdgeInsets.only(top: 15),
                            child: TextFieldThem.boxBuildTextField(
                              hintText: 'password'.tr,
                              controller: _passwordController,
                              textInputType: TextInputType.text,
                              obscureText: false,
                              contentPadding: EdgeInsets.zero,
                              validators: (String? value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return 'required'.tr;
                                }
                              },
                            ),
                          ),




                          Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: ButtonThem.buildButton(
                                context,
                                title: 'log in'.tr,
                                btnHeight: 50,
                                btnColor: ConstantColors.primary,
                                txtColor: Colors.white,
                                onPress: () async {
                                  if (_formKey.currentState!.validate()) {
                                    Map<String, String> bodyParams = {
                                      'email': _emailController.text.trim(),
                                      'mdp': _passwordController.text,
                                      'user_cat': 'driver',
                                      //'user_cat': 'customer',
                                    };
                                    await controller
                                        .loginAPI(bodyParams)
                                        .then((value) {
                                      if (value != null) {
                                        if (value.success == "success") {
                                          Preferences.setString(
                                              Preferences.user,
                                              jsonEncode(value));

                                          UserData? userData = value.userData;
                                          Preferences.setInt(
                                              Preferences.userId,
                                              int.parse(
                                                  userData!.id.toString()));
                                          if (userData.statutVehicule !=
                                                  "yes" ||
                                              userData
                                                  .statutVehicule!.isEmpty) {
                                            Get.to(() => VehicleInfoScreen(),
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                transition:
                                                    Transition.rightToLeft);
                                          }
                                          // else if (userData.photoPath == null) {
                                          //   Get.to(AddProfilePhotoScreen(fromOtp: false));
                                          // }
                                          // else if (userData.photoLicencePath == null) {
                                          //   Get.to(
                                          //       () => DocumentVerifyScreen(
                                          //             fromOtp: false,
                                          //           ),
                                          //       duration: const Duration(milliseconds: 400),
                                          //       transition: Transition.rightToLeft);
                                          // }
                                          // else if (userData.photoRoadWorthyPath == null) {
                                          //   Get.to(
                                          //       () => const AddRoadWorthyDocScreen(
                                          //             fromOtp: false,
                                          //           ),
                                          //       duration: const Duration(milliseconds: 400),
                                          //       transition: Transition.rightToLeft);
                                          // } else if (userData.photoCarServiceBookPath == null) {
                                          //   Get.to(
                                          //       () => AddCarServiceBookScreen(
                                          //             fromOtp: false,
                                          //           ),
                                          //       duration: const Duration(milliseconds: 400),
                                          //       transition: Transition.rightToLeft);
                                          // }
                                          else {
                                            Preferences.setBoolean(
                                                Preferences.isLogin, true);
                                            Get.offAll(DashBoard(),
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                transition:
                                                    Transition.rightToLeft);
                                          }
                                        } else {
                                          ShowToastDialog.showToast(
                                              value.error);
                                        }
                                      }
                                    });
                                  }
                                },
                              )),
                          GestureDetector(
                            onTap: () {
                              Get.to(ForgotPasswordScreen(),
                                  duration: const Duration(
                                      milliseconds:
                                          400), //duration of transitions, default 1 sec
                                  transition: Transition.rightToLeft);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Center(
                                child: Text(
                                  'forgot'.tr,
                                  style: TextStyle(
                                      color: ConstantColors.primary,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: ButtonThem.buildBorderButton(
                                context,
                                title: 'Login With Phone Number'.tr,
                                btnHeight: 50,
                                btnColor: Colors.white,
                                txtColor: ConstantColors.primary,
                                onPress: () {
                                  FocusScope.of(context).unfocus();
                                  Get.to(MobileNumberScreen(isLogin: true),
                                      duration: const Duration(
                                          milliseconds:
                                              400), //duration of transitions, default 1 sec
                                      transition: Transition.rightToLeft);
                                },
                                btnBorderColor: ConstantColors.primary,
                              )),


                          Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: ButtonThem.buildBorderButton(
                                context,
                                title: 'SignUp With Email'.tr,
                                btnHeight: 50,
                                btnColor: Colors.white,
                                txtColor: ConstantColors.primary,
                                onPress: () {
                                  FocusScope.of(context).unfocus();
                                  Get.to(EmailScreen(),
                                      duration: const Duration(
                                          milliseconds:
                                          400), //duration of transitions, default 1 sec
                                      transition: Transition.rightToLeft);
                                },
                                btnBorderColor: ConstantColors.primary,
                              )),




                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                children: [
                  TextSpan(
                    text: 'You don’t have an account yet? '.tr,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w500),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.to(MobileNumberScreen(isLogin: false),
                            duration: const Duration(
                                milliseconds:
                                    400), //duration of transitions, default 1 sec
                            transition:
                                Transition.rightToLeft); //transition effect);
                      },
                  ),
                  TextSpan(
                    text: 'SIGNUP'.tr,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ConstantColors.primary),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.to(
                            MobileNumberScreen(
                              isLogin: false,
                            ),
                            duration: const Duration(
                                milliseconds:
                                    400), //duration of transitions, default 1 sec
                            transition:
                                Transition.rightToLeft); //transition effect);
                      },
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
