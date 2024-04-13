import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/model/parcel_details_model.dart';
import 'package:cabme_driver/model/parcel_model.dart';
import 'package:cabme_driver/model/tax_model.dart';
import 'package:cabme_driver/service/api.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ParcelPaymentController extends GetxController {
  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  RxDouble subTotalAmount = 0.0.obs;
  RxDouble tipAmount = 0.0.obs;
  RxDouble taxAmount = 0.0.obs;
  RxDouble discountAmount = 0.0.obs;
  RxDouble adminCommission = 0.0.obs;

  var data = ParcelData().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      data.value = argumentData["parcelData"];

      subTotalAmount.value = double.parse(data.value.amount!);
      // tipAmount.value =
      //     data.value.tipAmount != "null" && data.value.tipAmount!.isNotEmpty
      //         ? double.parse(data.value.tipAmount.toString())
      //         : 0.0;
      // taxAmount.value = double.parse(data.value.tax!);
      discountAmount.value =
          data.value.discount != "null" && data.value.discount != null
              ? double.parse(data.value.discount!)
              : 0.0;
    }

    if (data.value.paymentStatus == "yes") {
      getParcelDetailsData(data.value.id.toString());
      adminCommission.value =
          double.parse(data.value.adminCommission.toString());
    } else {
      for (var i = 0; i < Constant.taxList.length; i++) {
        if (Constant.taxList[i].statut == 'yes') {
          if (Constant.taxList[i].type == "Fixed") {
            taxAmount.value +=
                double.parse(Constant.taxList[i].value.toString());
          } else {
            taxAmount.value += ((subTotalAmount.value - discountAmount.value) *
                    double.parse(Constant.taxList[i].value!.toString())) /
                100;
          }
        }
      }
      adminCommission.value =
          (Preferences.getString(Preferences.admincommissiontype).toString() ==
                  'Percentage')
              ? ((subTotalAmount.value - discountAmount.value) *
                      double.parse(
                          Preferences.getString(Preferences.admincommission)
                              .toString())) /
                  100
              : double.parse(Preferences.getString(Preferences.admincommission)
                  .toString());
    }

    update();
  }

  Future<dynamic> getParcelDetailsData(String id) async {
    try {
      final response = await http.get(
          Uri.parse("${API.getParcelDetails}?parcel_id=$id"),
          headers: API.header);
      log(response.body);

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ParcelDetailsModel rideDetailsModel =
            ParcelDetailsModel.fromJson(responseBody);
        data.value = ParcelData.fromJson(responseBody['data']);
        subTotalAmount.value =
            double.parse(rideDetailsModel.rideDetailsdata!.amount.toString());
        tipAmount.value =
            double.parse(rideDetailsModel.rideDetailsdata!.tip.toString());
        discountAmount.value =
            double.parse(rideDetailsModel.rideDetailsdata!.discount.toString());
        for (var i = 0; i < data.value.taxModel!.length; i++) {
          if (data.value.taxModel![i].statut == 'yes') {
            if (data.value.taxModel![i].type == "Fixed") {
              taxAmount.value +=
                  double.parse(data.value.taxModel![i].value.toString());
            } else {
              taxAmount.value += ((subTotalAmount.value -
                          discountAmount.value) *
                      double.parse(data.value.taxModel![i].value!.toString())) /
                  100;
            }
          }
        }
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
      } else {}
    } on TimeoutException {
      // ShowToastDialog.showToast(e.message.toString());
    } on SocketException {
      // ShowToastDialog.showToast(e.message.toString());
    } on Error {
      // ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      // ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  double calculateTax({TaxModel? taxModel}) {
    double tax = 0.0;
    if (taxModel != null && taxModel.statut == 'yes') {
      if (taxModel.type.toString() == "Fixed") {
        tax = double.parse(taxModel.value.toString());
      } else {
        tax = ((subTotalAmount.value - discountAmount.value) *
                double.parse(taxModel.value!.toString())) /
            100;
      }
    }
    return tax;
  }

  double getTotalAmount() {
    // if (Constant.taxType == "Percentage") {
    //   taxAmount.value =
    //       Constant.taxValue != null && Constant.taxValue.toString() != "0"
    //           ? (subTotalAmount.value - discountAmount.value) *
    //               double.parse(Constant.taxValue.toString()) /
    //               100
    //           : 0.0;
    // } else {
    //   taxAmount.value = Constant.taxValue.toString() != "0"
    //       ? double.parse(Constant.taxValue.toString())
    //       : 0.0;
    // }
    // if (paymentSettingModel.value.tax!.taxType == "percentage") {
    //   taxAmount.value = paymentSettingModel.value.tax!.taxAmount != null
    //       ? (subTotalAmount.value - discountAmount.value) *
    //           double.parse(
    //               paymentSettingModel.value.tax!.taxAmount.toString()) /
    //           100
    //       : 0.0;
    // } else {
    //   taxAmount.value = paymentSettingModel.value.tax!.taxAmount != null
    //       ? double.parse(paymentSettingModel.value.tax!.taxAmount.toString())
    //       : 0.0;
    // }

    return (subTotalAmount.value - discountAmount.value) +
        tipAmount.value +
        taxAmount.value;
  }
}
