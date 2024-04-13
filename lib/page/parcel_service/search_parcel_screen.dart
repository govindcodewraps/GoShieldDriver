import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/constant/show_toast_dialog.dart';
import 'package:cabme_driver/controller/dash_board_controller.dart';
import 'package:cabme_driver/controller/parcel_service_controller.dart';
import 'package:cabme_driver/model/parcel_model.dart';
import 'package:cabme_driver/page/parcel_service/parcel_route_view_screen.dart';
import 'package:cabme_driver/themes/button_them.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:cabme_driver/themes/text_field_them.dart';
import 'package:cabme_driver/utils/Preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:bottom_picker/bottom_picker.dart';

class SearchParcelScreen extends StatelessWidget {
  SearchParcelScreen({super.key});
  final dashboardController = Get.put(DashBoardController());
  @override
  Widget build(BuildContext context) {
    return GetX<ParcelServiceController>(
        init: ParcelServiceController(),
        builder: (controller) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  if (double.parse(controller.totalEarn.value.toString()) <
                      double.parse(Constant.minimumWalletBalance!))
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ConstantColors.primary),
                      child: Text(
                        "${"Your wallet balance must be".tr} ${Constant().amountShow(amount: Constant.minimumWalletBalance!.toString())} ${"to get parcel.".tr}",
                      ),
                    ),
                  InkWell(
                      onTap: () async {
                        await Constant()
                            .handlePressButton(context)
                            .then((value) {
                          if (value != null) {
                            controller.sourceLatLng = LatLng(
                                value.result.geometry!.location.lat,
                                value.result.geometry!.location.lng);
                            controller.sourceCityController.value.text =
                                value.result.vicinity.toString();
                          }
                        });
                      },
                      child: TextFieldThem.boxBuildTextField(
                        hintText: 'From',
                        controller: controller.sourceCityController.value,
                        enabled: false,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () async {
                        await Constant()
                            .handlePressButton(context)
                            .then((value) {
                          if (value != null) {
                            controller.destinationLatLng = LatLng(
                                value.result.geometry!.location.lat,
                                value.result.geometry!.location.lng);
                            controller.destinationCityController.value.text =
                                value.result.vicinity.toString();
                          }
                        });
                      },
                      child: TextFieldThem.boxBuildTextField(
                        hintText: 'To',
                        controller: controller.destinationCityController.value,
                        enabled: false,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () async {
                        BottomPicker.date(
                          onSubmit: (index) {
                            controller.dateAndTime = index;
                            DateFormat dateFormat = DateFormat("dd-MMM-yyyy");
                            String string = dateFormat.format(index);

                            controller.whenController.value.text = string;
                          },
                          minDateTime: DateTime.now(),
                          buttonAlignment: MainAxisAlignment.center,
                          displayButtonIcon: false,
                          displaySubmitButton: true,
                          title: '',
                          buttonText: 'Confirm',
                          buttonSingleColor: ConstantColors.primary,
                          buttonTextStyle: const TextStyle(color: Colors.white),
                        ).show(context);
                      },
                      child: TextFieldThem.boxBuildTextField(
                        hintText: 'Select date',
                        controller: controller.whenController.value,
                        enabled: false,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonThem.buildButton(context,
                      title: "Search",
                      btnColor: ConstantColors.primary,
                      txtColor: Colors.white, onPress: () {
                    if (controller.sourceCityController.value.text.isNotEmpty &&
                        controller.whenController.value.text.isNotEmpty) {
                      if (double.parse(controller.totalEarn.value.toString()) <
                          double.parse(Constant.minimumWalletBalance!)) {
                        ShowToastDialog.showToast(
                            "${"Your wallet balance must be".tr} ${Constant().amountShow(amount: Constant.minimumWalletBalance!.toString())} ${"to get parcel.".tr}");
                      } else {
                        String url =
                            "?source_lat=${controller.sourceLatLng!.latitude.toString()}&source_lng=${controller.sourceLatLng!.longitude.toString()}&destination_lat=${controller.destinationLatLng != null ? controller.destinationLatLng!.latitude.toString() : ""}&destination_lng=${controller.destinationLatLng != null ? controller.destinationLatLng!.longitude.toString() : ""}&date=${controller.whenController.value.text}&source_city=${controller.sourceCityController.value.text}&destination_city=${controller.destinationCityController.value.text}&driver_id=${Preferences.getInt(Preferences.userId).toString()}";

                        controller.searchParcel(url);
                      }
                    } else {
                      ShowToastDialog.showToast(
                          "Please enter source city and date.");
                    }
                  }),
                  Expanded(
                      child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.searchParcelList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildHistory(context,
                          controller.searchParcelList[index], controller);
                    },
                  ))
                ],
              ),
            ),
          );
        });
  }

  buildHistory(context, ParcelData data, ParcelServiceController controller) {
    return GestureDetector(
      onTap: () async {
        // var isDone = await Get.to(const ParcelDetailsScreen(), arguments: {
        //   "parcelData": data,
        // });

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
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        "Parcel weight (In Kg.) : ",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            color: ConstantColors.subTitleTextColor),
                      ),
                      Text(
                        "${data.parcelWeight}Kg",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Text(
                      "Parcel dimension(In ft.) : ",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          color: ConstantColors.subTitleTextColor),
                    ),
                    Text(
                      "${data.parcelDimension}ft",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
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
                              Constant()
                                  .amountShow(amount: data.amount.toString()),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
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
                                Constant.makePhoneCall("${data.userPhone}");
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ButtonThem.buildBorderButton(
                  context,
                  title: 'Accept'.tr,
                  btnHeight: 40,
                  btnColor: ConstantColors.primary,
                  txtColor: Colors.white,
                  btnBorderColor: ConstantColors.primary,
                  onPress: () async {
                    Map<String, String> bodyParams = {
                      "id_parcel": data.id.toString(),
                      "id_user": data.idUserApp.toString(),
                      "driver_name":
                          "${controller.userModel!.userData!.prenom} ${controller.userModel!.userData!.nom}",
                      "driver_id":
                          Preferences.getInt(Preferences.userId).toString(),
                    };
                    controller.confirmedParcel(bodyParams).then((value) {
                      if (value != null) {
                        ShowToastDialog.showToast(value['message']);
                        dashboardController.onSelectItem(2);
                      }
                    });
                  },
                ),
              )
            ],
          ),
        ),
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
          InkWell(
              onTap: () {
                isSender
                    ? Constant.makePhoneCall(data.senderPhone.toString())
                    : Constant.makePhoneCall(data.receiverPhone.toString());
              },
              child: Image.asset(
                'assets/icons/call_icon.png',
                height: 36,
                width: 36,
              )),
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
}
