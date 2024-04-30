import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:goshield_driver/constant/constant.dart';
import 'package:goshield_driver/constant/show_toast_dialog.dart';
import 'package:goshield_driver/model/settings_model.dart';
import 'package:goshield_driver/service/api.dart';
import 'package:goshield_driver/themes/constant_colors.dart';
import 'package:goshield_driver/utils/Preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as get_cord_address;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../NotificationService.dart';

class SettingsController extends GetxController {
  // @override
  // void onInit() {
  //   API.header['accesstoken'] = Preferences.getString(Preferences.accesstoken);
  //   //getSettingsData();
  //   super.onInit();
  // }

   NotificationServices notificationServices = NotificationServices();

    @override
    void onInit() {
      API.header['accesstoken'] = Preferences.getString(Preferences.accesstoken);
      if (!Platform.isIOS) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          showDialog(
            context: Get.context!,
            barrierDismissible: false, // Prevents closing by tapping outside
            builder: (context) =>
                AlertDialog(
                  //title: Text('The term “location"'),
                  content: Text(
                    "Go Shield Driver collects location data when the app is active/in use and when it is not in use to ensure accurate Driver location detection for best results ",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Navigator.of(context).pop();
                        // Navigator.of(context).pop();
                        SystemNavigator.pop();
                        },
                      child: Text('Exit'),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();


                        notificationServices.requestNotificationPermission();
                        notificationServices.firebaseInit(context);
                        notificationServices.setupInteractMessage(context);
                        //notificationServices.isTokenRefresh();
                        notificationServices.getDeviceToken().then((value) {
                          print('device token');
                          print(value);
                        });

                        //  PermissionStatusWidget();
                        getSettingsData();
                      },
                      child: Text('Continue'),
                    ),
                  ],
                ),
          );
        });
      }


      if(Platform.isIOS){
        getSettingsData();
      }

      super.onInit();
    }


  Future<SettingsModel?> getSettingsData() async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(
        Uri.parse(API.settings),
        headers: API.authheader,
      );

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        log(responseBody.toString());
        SettingsModel model = SettingsModel.fromJson(responseBody);
        Constant.parcelActive = model.data!.parcelActive!;
        ConstantColors.primary = Color(
            int.parse(model.data!.driverappColor!.replaceFirst("#", "0xff")));
        Constant.distanceUnit = model.data!.deliveryDistance!;
        Constant.appVersion = model.data!.appVersion.toString();
        Constant.decimal = model.data!.decimalDigit!;
        // Constant.taxList = model.data!.taxModel!;
        // Constant.taxType = model.data!.taxType!;
        // Constant.taxName = model.data!.taxName!;

        // Constant.taxValue = model.data!.taxValue!;
        Constant.currency = model.data!.currency!;
        Constant.symbolAtRight =
            model.data!.symbolAtRight! == 'true' ? true : false;
        Constant.kGoogleApiKey = model.data!.googleMapApiKey!;
        Constant.contactUsEmail = model.data!.contactUsEmail!;
        Constant.contactUsAddress = model.data!.contactUsAddress!;
        Constant.minimumWalletBalance = model.data!.minimumDepositAmount!;
        Constant.contactUsPhone = model.data!.contactUsPhone!;
        Constant.rideOtp = model.data!.showRideOtp!;
        Constant.driverLocationUpdateUnit = model.data!.driverLocationUpdate!;
        Constant.mapType = model.data!.mapType!;
        Constant.minimumWithdrawalAmount = model.data!.minimumWithdrawalAmount!;
        Constant.deliveryChargeParcel = model.data!.deliveryChargeParcel!;

        Constant.parcelPerWeightCharge = model.data!.parcelPerWeightCharge!;
        LocationData location = await Location().getLocation();
        List<get_cord_address.Placemark> placeMarks =
            await get_cord_address.placemarkFromCoordinates(
                location.latitude ?? 0.0, location.longitude ?? 0.0);
        for (var i = 0; i < model.data!.taxModel!.length; i++) {
          if (placeMarks.first.country.toString().toUpperCase() ==
              model.data!.taxModel![i].country!.toUpperCase()) {
            Constant.taxList.add(model.data!.taxModel![i]);
          }
        }
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
