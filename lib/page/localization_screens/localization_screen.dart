import 'package:goshield_driver/constant/show_toast_dialog.dart';
import 'package:goshield_driver/controller/localization_controller.dart';
import 'package:goshield_driver/on_boarding_screen.dart';
import 'package:goshield_driver/service/localization_service.dart';
import 'package:goshield_driver/themes/constant_colors.dart';
import 'package:goshield_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationScreens extends StatelessWidget {
  final String intentType;

  const LocalizationScreens({super.key, required this.intentType});

  @override
  Widget build(BuildContext context) {
    return GetX<LocalizationController>(
      init: LocalizationController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: ConstantColors.background,
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: intentType == "dashBoard"
                      ? EdgeInsets.zero
                      : const EdgeInsets.only(top: 30),
                  child: Text(
                    'select_language'.tr,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.languageList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Obx(
                        () => InkWell(
                          onTap: () {
                            controller.selectedLanguage.value =
                                controller.languageList[index].code.toString();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: controller.languageList[index].code ==
                                      controller.selectedLanguage.value
                                  ? BoxDecoration(
                                      border: Border.all(
                                          color: ConstantColors.primary),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(
                                              5.0) //                 <--- border radius here
                                          ),
                                    )
                                  : null,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    Image.network(
                                      controller.languageList[index].flag
                                          .toString(),
                                      height: 60,
                                      width: 60,
                                    ),
                                    Expanded(
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(controller
                                              .languageList[index].language
                                              .toString())),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {
                LocalizationService()
                    .changeLocale(controller.selectedLanguage.value);
                Preferences.setString(Preferences.languageCodeKey,
                    controller.selectedLanguage.toString());
                if (intentType == "dashBoard") {
                  ShowToastDialog.showToast("Language change successfully".tr);
                } else {
                  Get.offAll(const OnBoardingScreen());
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: Colors.black,
                padding: const EdgeInsets.all(14),
              ),
              child: const Icon(Icons.navigate_next, size: 32),
            ),
          ),
        );
      },
    );
  }
}
