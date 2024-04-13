import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/parcel_model.dart';
import 'package:cabme_driver/page/complaint/add_complaint_screen.dart';
import 'package:cabme_driver/page/parcel_service/parcel_details_screen.dart';
import 'package:cabme_driver/page/parcel_service/parcel_route_view_screen.dart';
import 'package:cabme_driver/themes/button_them.dart';
import 'package:cabme_driver/themes/custom_alert_dialog.dart';
import 'package:cabme_driver/themes/custom_dialog_box.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:text_scroll/text_scroll.dart';
import '../../controller/parcel_service_controller.dart';
import '../../themes/constant_colors.dart';

class AllParcelScreen extends StatelessWidget {
  const AllParcelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ParcelServiceController>(
        init: ParcelServiceController(),
        builder: (controller) {
          return RefreshIndicator(
            onRefresh: () => controller.getParcel(),
            child: Scaffold(
              backgroundColor: ConstantColors.background,
              body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: controller.parcelList.isEmpty
                      ? Constant.emptyView(
                          "You don't have any parcel confirmed.".tr)
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.parcelList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return buildHistory(context,
                                controller.parcelList[index], controller);
                          },
                        )),
            ),
          );
        });
  }

  buildHistory(context, ParcelData data, ParcelServiceController controller) {
    return GestureDetector(
      onTap: () async {
        if (data.status == "completed") {
          var isDone = await Get.to(const ParcelDetailsScreen(), arguments: {
            "parcelData": data,
          });
          if (isDone != null) {
            controller.getParcel();
          }
        } else {
          var argumentData = {'type': data.status, 'data': data};
          if (Constant.mapType == "inappmap") {
            Get.to(const ParcelRouteViewScreen(), arguments: argumentData);
          } else {
            Constant.redirectMap(
              latitude: double.parse(data.latDestination!),
              longLatitude: double.parse(data.lngDestination!),
              name: data.destination!,
            );
          }
        }
      },
      child: Stack(
        children: [
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildLine(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildUsersDetails(
                              context,
                              data,
                              isSender: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            buildUsersDetails(
                              context,
                              data,
                              isSender: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: 80,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Constant.currency.toString(),
                                  style: TextStyle(
                                    color: ConstantColors.yellow,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                TextScroll(
                                  Constant().amountShow(
                                      amount: data.amount.toString()),
                                  mode: TextScrollMode.bouncing,
                                  pauseBetween: const Duration(seconds: 2),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            height: 80,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/ic_distance.png',
                                  height: 22,
                                  width: 22,
                                  color: ConstantColors.yellow,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextScroll(
                                  "${double.parse(data.distance.toString()).toStringAsFixed(int.parse(Constant.decimal!))} ${data.distanceUnit}",
                                  mode: TextScrollMode.bouncing,
                                  pauseBetween: const Duration(seconds: 2),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            height: 80,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black12,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/time.png',
                                  height: 22,
                                  width: 22,
                                  color: ConstantColors.yellow,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                TextScroll(data.duration.toString(),
                                    mode: TextScrollMode.bouncing,
                                    pauseBetween: const Duration(seconds: 2),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black54)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: data.userPhoto.toString(),
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Constant.loader(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(data.userName.toString(),
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: InkWell(
                                  onTap: () {
                                    Constant.makePhoneCall(
                                        data.userPhone.toString());
                                  },
                                  child: Image.asset(
                                    'assets/icons/call_icon.png',
                                    height: 36,
                                    width: 36,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 5.0,
                              ),
                              child: Text(data.parcelDate.toString(),
                                  style: const TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: data.status.toString() == "confirmed",
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: ButtonThem.buildBorderButton(
                                  context,
                                  title: 'REJECT'.tr,
                                  btnHeight: 45,
                                  btnWidthRatio: 0.8,
                                  btnColor: Colors.white,
                                  txtColor: Colors.black.withOpacity(0.60),
                                  btnBorderColor:
                                      Colors.black.withOpacity(0.20),
                                  onPress: () async {
                                    buildShowBottomSheet(
                                        context, data, controller);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 5, left: 10),
                                child: ButtonThem.buildButton(
                                  context,
                                  title: 'on_ride'.tr,
                                  btnHeight: 45,
                                  btnWidthRatio: 0.8,
                                  btnColor: ConstantColors.primary,
                                  txtColor: Colors.black,
                                  onPress: () async {
                                    showDialog(
                                      barrierColor:
                                          const Color.fromARGB(66, 20, 14, 14),
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          title:
                                              "Do you want to on ride this parcel?"
                                                  .tr,
                                          negativeButtonText: 'No'.tr,
                                          positiveButtonText: 'Yes'.tr,
                                          onPressNegative: () {
                                            Get.back();
                                          },
                                          onPressPositive: () {
                                            Get.back();

                                            if (Constant.rideOtp.toString() !=
                                                'yes') {
                                              Map<String, String> bodyParams = {
                                                'id_parcel': data.id.toString(),
                                                'id_user':
                                                    data.idUserApp.toString(),
                                                'driver_name':
                                                    '${data.driverName}',
                                                'driver_id': Preferences.getInt(
                                                        Preferences.userId)
                                                    .toString(),
                                              };
                                              controller
                                                  .onRideParcel(bodyParams)
                                                  .then((value) {
                                                if (value != null) {
                                                  Get.back();
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return CustomDialogBox(
                                                          title:
                                                              "On ride Successfully"
                                                                  .tr,
                                                          descriptions:
                                                              "Parcel Successfully On ride."
                                                                  .tr,
                                                          text: "Ok".tr,
                                                          onPress: () {
                                                            controller
                                                                .getParcel();
                                                          },
                                                          img: Image.asset(
                                                              'assets/images/green_checked.png'),
                                                        );
                                                      });
                                                }
                                              });
                                            } else {
                                              controller.otpController.value =
                                                  TextEditingController();
                                              showDialog(
                                                barrierColor: Colors.black26,
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: Container(
                                                      height: 180,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              top: 20,
                                                              right: 10,
                                                              bottom: 10),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black,
                                                                offset: Offset(
                                                                    0, 10),
                                                                blurRadius: 10),
                                                          ]),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            "Enter OTP".tr,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.60)),
                                                          ),
                                                          Pinput(
                                                            controller: controller
                                                                .otpController
                                                                .value,
                                                            defaultPinTheme:
                                                                PinTheme(
                                                              height: 50,
                                                              width: 50,
                                                              textStyle: const TextStyle(
                                                                  letterSpacing:
                                                                      0.60,
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                              // margin: EdgeInsets.all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                shape: BoxShape
                                                                    .rectangle,
                                                                color: Colors
                                                                    .white,
                                                                border: Border.all(
                                                                    color: ConstantColors
                                                                        .textFieldBoarderColor,
                                                                    width: 0.7),
                                                              ),
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .phone,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .done,
                                                            length: 6,
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: ButtonThem
                                                                    .buildButton(
                                                                  context,
                                                                  title:
                                                                      'done'.tr,
                                                                  btnHeight: 45,
                                                                  btnWidthRatio:
                                                                      0.8,
                                                                  btnColor:
                                                                      ConstantColors
                                                                          .primary,
                                                                  txtColor:
                                                                      Colors
                                                                          .white,
                                                                  onPress: () {
                                                                    if (controller
                                                                            .otpController
                                                                            .value
                                                                            .text
                                                                            .toString()
                                                                            .length ==
                                                                        6) {
                                                                      controller
                                                                          .verifyOTP(
                                                                        userId: data
                                                                            .idUserApp!
                                                                            .toString(),
                                                                        rideId: data
                                                                            .id!
                                                                            .toString(),
                                                                      )
                                                                          .then(
                                                                              (value) {
                                                                        if (value !=
                                                                                null &&
                                                                            value['success'] ==
                                                                                "success") {
                                                                          Map<String, String>
                                                                              bodyParams =
                                                                              {
                                                                            'id_parcel':
                                                                                data.id.toString(),
                                                                            'id_user':
                                                                                data.idUserApp.toString(),
                                                                            'driver_name':
                                                                                '${data.driverName}',
                                                                            'driver_id':
                                                                                Preferences.getInt(Preferences.userId).toString(),
                                                                          };

                                                                          controller
                                                                              .onRideParcel(bodyParams)
                                                                              .then((value) {
                                                                            if (value !=
                                                                                null) {
                                                                              Get.back();
                                                                              showDialog(
                                                                                  context: context,
                                                                                  builder: (BuildContext context) {
                                                                                    return CustomDialogBox(
                                                                                      title: "On ride Successfully".tr,
                                                                                      descriptions: "Parcel Successfully On ride.".tr,
                                                                                      text: "Ok".tr,
                                                                                      onPress: () {
                                                                                        Get.back();
                                                                                        controller.getParcel();
                                                                                      },
                                                                                      img: Image.asset('assets/images/green_checked.png'),
                                                                                    );
                                                                                  });
                                                                            }
                                                                          });
                                                                        }
                                                                      });
                                                                    } else {
                                                                      ShowToastDialog.showToast(
                                                                          'Please Enter OTP'
                                                                              .tr);
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Expanded(
                                                                child: ButtonThem
                                                                    .buildBorderButton(
                                                                  context,
                                                                  title:
                                                                      'cancel'
                                                                          .tr,
                                                                  btnHeight: 45,
                                                                  btnWidthRatio:
                                                                      0.8,
                                                                  btnColor:
                                                                      Colors
                                                                          .white,
                                                                  txtColor: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.60),
                                                                  btnBorderColor: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.20),
                                                                  onPress: () {
                                                                    Get.back();
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                  Visibility(
                      visible: data.status.toString() == "onride",
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: ButtonThem.buildButton(
                          context,
                          title: 'COMPLETE'.tr,
                          btnHeight: 45,
                          btnWidthRatio: 1,
                          btnColor: ConstantColors.primary,
                          txtColor: Colors.black,
                          onPress: () async {
                            Map<String, String> bodyParams = {
                              'id_parcel': data.id.toString(),
                              'id_user': data.idUserApp.toString(),
                              'driver_name': '${data.driverName}',
                              'from_id': Preferences.getInt(Preferences.userId)
                                  .toString(),
                            };

                            controller.completeParcel(bodyParams).then((value) {
                              if (value != null) {
                                Get.back();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialogBox(
                                        title: "Completed Successfully".tr,
                                        descriptions:
                                            "Parcel Successfully completed.".tr,
                                        text: "Ok".tr,
                                        onPress: () {
                                          Get.back();
                                          controller.getParcel();
                                        },
                                        img: Image.asset(
                                            'assets/images/green_checked.png'),
                                      );
                                    });
                              }
                            });
                          },
                        ),
                      )),
                  Visibility(
                    visible: data.status == "completed",
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ButtonThem.buildBorderButton(
                        context,
                        title: 'Add Complaint'.tr,
                        btnHeight: 40,
                        btnColor: Colors.white,
                        txtColor: ConstantColors.primary,
                        btnBorderColor: ConstantColors.primary,
                        onPress: () async {
                          Get.to(AddComplaintScreen(), arguments: {
                            "data": data,
                            "ride_type": "parcel",
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              right: 0,
              child: Image.asset(
                data.status == "new"
                    ? 'assets/images/new.png'
                    : data.status == "confirmed"
                        ? 'assets/images/conformed.png'
                        : data.status == "onride"
                            ? 'assets/images/onride.png'
                            : data.status == "completed"
                                ? 'assets/images/completed.png'
                                : 'assets/images/rejected.png',
                height: 120,
                width: 120,
              )),
        ],
      ),
    );
  }

  buildUsersDetails(context, ParcelData data, {bool isSender = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isSender ? "${"Sender".tr} " : "${"Receiver".tr} ",
                      style: TextStyle(
                          fontSize: 16,
                          color: isSender
                              ? ConstantColors.primary
                              : const Color(0xffd17e19)),
                    ),
                    Text(
                      isSender
                          ? data.senderName.toString()
                          : data.receiverName.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Text(
                  isSender
                      ? data.senderPhone.toString()
                      : data.receiverPhone.toString(),
                  style: TextStyle(
                      fontSize: 16, color: ConstantColors.subTitleTextColor),
                ),
                Text(
                  isSender
                      ? data.source.toString()
                      : data.destination.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16, color: ConstantColors.subTitleTextColor),
                ),
              ],
            ),
          ),
          !isSender
              ? InkWell(
                  onTap: () {
                    Constant.makePhoneCall(data.receiverPhone.toString());
                  },
                  child: Image.asset(
                    'assets/icons/call_icon.png',
                    height: 36,
                    width: 36,
                  ))
              : const Offstage(),
        ],
      ),
    );
  }

  buildLine() {
    return Column(
      children: [
        const SizedBox(
          height: 6,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Image.asset("assets/images/circle.png", height: 20),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 2),
          child: SizedBox(
            width: 1.3,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 15,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Container(
                      color: Colors.black38,
                      height: 2.5,
                    ),
                  );
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Image.asset("assets/images/parcel_Image.png", height: 20),
        ),
      ],
    );
  }

  buildShowBottomSheet(BuildContext context, ParcelData data,
      ParcelServiceController controller) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15))),
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Cancel Trip".tr,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Write a reason for trip cancellation".tr,
                        style: TextStyle(color: Colors.black.withOpacity(0.50)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextField(
                        controller: controller.resonController.value,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: ButtonThem.buildButton(
                                context,
                                title: 'Cancel Trip'.tr,
                                btnHeight: 45,
                                btnWidthRatio: 0.8,
                                btnColor: ConstantColors.primary,
                                txtColor: Colors.white,
                                onPress: () async {
                                  if (controller
                                      .resonController.value.text.isNotEmpty) {
                                    Get.back();
                                    showDialog(
                                      barrierColor: Colors.black26,
                                      context: context,
                                      builder: (context) {
                                        return CustomAlertDialog(
                                          title:
                                              "Do you want to reject this booking?"
                                                  .tr,
                                          onPressNegative: () {
                                            Get.back();
                                          },
                                          negativeButtonText: 'No'.tr,
                                          positiveButtonText: 'Yes'.tr,
                                          onPressPositive: () {
                                            Map<String, String> bodyParams = {
                                              'id_parcel': data.id.toString(),
                                              'id_user':
                                                  data.idUserApp.toString(),
                                              'name':
                                                  data.driverName.toString(),
                                              'from_id': Preferences.getInt(
                                                      Preferences.userId)
                                                  .toString(),
                                              'user_cat': controller
                                                  .userModel!.userData!.userCat
                                                  .toString(),
                                              'reason': controller
                                                  .resonController.value.text
                                                  .toString(),
                                            };
                                            controller
                                                .cancelParcel(bodyParams)
                                                .then((value) {
                                              Get.back();
                                              if (value != null) {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return CustomDialogBox(
                                                        title:
                                                            "Reject Successfully"
                                                                .tr,
                                                        descriptions:
                                                            "Parcel Successfully rejected."
                                                                .tr,
                                                        text: "Ok".tr,
                                                        onPress: () {
                                                          Get.back();
                                                          controller
                                                              .getParcel();
                                                        },
                                                        img: Image.asset(
                                                            'assets/images/green_checked.png'),
                                                      );
                                                    });
                                              }
                                            });
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    ShowToastDialog.showToast(
                                        "Please enter a reason".tr);
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 5, left: 10),
                              child: ButtonThem.buildBorderButton(
                                context,
                                title: 'Close'.tr,
                                btnHeight: 45,
                                btnWidthRatio: 0.8,
                                btnColor: Colors.white,
                                txtColor: ConstantColors.primary,
                                btnBorderColor: ConstantColors.primary,
                                onPress: () async {
                                  Get.back();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}
