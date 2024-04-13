import 'package:cabme_driver/constant/constant.dart';
import 'package:cabme_driver/controller/parcel_payment_controller.dart';
import 'package:cabme_driver/model/tax_model.dart';
import 'package:cabme_driver/page/chats_screen/FullScreenImageViewer.dart';
import 'package:cabme_driver/themes/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParcelDetailsScreen extends StatelessWidget {
  const ParcelDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ParcelPaymentController>(
        init: ParcelPaymentController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: ConstantColors.background,
            appBar: AppBar(
                backgroundColor: ConstantColors.background,
                elevation: 0,
                centerTitle: true,
                title: Text("Parcel Details".tr,
                    style: const TextStyle(color: Colors.black)),
                leading: Padding(
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
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.black,
                          ),
                        )),
                  ),
                )),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildHistory(context, controller),
                    buildAmountWidget(controller),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Admin commission".tr,
                                  style: TextStyle(
                                      letterSpacing: 1.0,
                                      color: ConstantColors.subTitleTextColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                "(-${Constant().amountShow(amount: controller.adminCommission.value.toString())})",
                                style: const TextStyle(
                                    letterSpacing: 1.0,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Note : Admin commission will be debited from your wallet balance. \nAdmin commission will apply on parcel Amount minus Discount(If applicable)."
                                .tr,
                            style: const TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  buildHistory(context, ParcelPaymentController controller) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                          controller,
                          isSender: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        buildUsersDetails(
                          context,
                          controller,
                          isSender: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Colors.black12,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Parcel image".tr,
                  style: TextStyle(
                    color: ConstantColors.subTitleTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                    itemCount: controller.data.value.parcelImage!.length,
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(
                            () => FullScreenImageViewer(
                              imageUrl:
                                  controller.data.value.parcelImage![index],
                            ),
                          );
                        },
                        child: Container(
                          width: 90,
                          height: 100.0,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    controller.data.value.parcelImage![index])),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                      );
                    }),
              ),
              const Divider(
                color: Colors.black12,
                thickness: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: buildOtherDetails(
                      title: "Parcel Status".tr,
                      value: controller.data.value.status.toString(),
                    ),
                  ),
                  Expanded(
                    child: buildOtherDetails(
                      title: "Parcel Type".tr,
                      value: controller.data.value.title.toString(),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  const Divider(
                    color: Colors.black12,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: buildOtherDetails(
                          title: "PickUp date".tr,
                          value:
                              "${controller.data.value.parcelDate} ${controller.data.value.parcelTime}",
                        ),
                      ),
                      Expanded(
                        child: buildOtherDetails(
                          title: "Drop Date".tr,
                          value:
                              "${controller.data.value.receiveDate} ${controller.data.value.receiveTime}",
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const Divider(
                color: Colors.black12,
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: buildOtherDetails(
                      title: "Distance".tr,
                      value: controller.data.value.distance.toString() +
                          controller.data.value.distanceUnit.toString(),
                    ),
                  ),

                  Expanded(
                    child: buildOtherDetails(
                      title: "Weight".tr,
                      value: "${controller.data.value.parcelWeight}Kg",
                    ),
                  )
                  // buildOtherDetails(title: "Rate".tr(), value: symbol + double.parse(orderModel.subTotal!).toStringAsFixed(decimal), color: Color(COLOR_PRIMARY)),
                ],
              ),
              const Divider(
                color: Colors.black12,
                thickness: 1,
              ),
              Center(
                child: buildOtherDetails(
                  title: "Dimension".tr,
                  value: "${controller.data.value.parcelDimension}ft",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildOtherDetails({
    required String title,
    required String value,
    Color color = Colors.black,
  }) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(title,
              style: TextStyle(
                  color: ConstantColors.subTitleTextColor,
                  fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 5,
          ),
          Text(value,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: ConstantColors.titleTextColor,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  buildUsersDetails(context, ParcelPaymentController controller,
      {bool isSender = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
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
                    ? controller.data.value.senderName.toString()
                    : controller.data.value.receiverName.toString(),
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
                ? controller.data.value.senderPhone.toString()
                : controller.data.value.receiverPhone.toString(),
            style: TextStyle(
                fontSize: 16, color: ConstantColors.subTitleTextColor),
          ),
          Text(
            isSender
                ? controller.data.value.source.toString()
                : controller.data.value.destination.toString(),
            style: TextStyle(
                fontSize: 16, color: ConstantColors.subTitleTextColor),
          ),
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

  buildAmountWidget(ParcelPaymentController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 2,
              offset: const Offset(2, 2),
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Sub Total".tr,
                    style: TextStyle(
                        letterSpacing: 1.0,
                        color: ConstantColors.subTitleTextColor,
                        fontWeight: FontWeight.w600),
                  )),
                  Text(
                      Constant().amountShow(
                          amount: controller.data.value.amount.toString()),
                      style: TextStyle(
                          letterSpacing: 1.0,
                          color: ConstantColors.titleTextColor,
                          fontWeight: FontWeight.w800)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Divider(
                  color: Colors.black.withOpacity(0.40),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Discount".tr,
                    style: TextStyle(
                        letterSpacing: 1.0,
                        color: ConstantColors.subTitleTextColor,
                        fontWeight: FontWeight.w600),
                  )),
                  Text(
                      "(-${Constant().amountShow(amount: controller.data.value.discount.toString())})",
                      style: const TextStyle(
                          letterSpacing: 1.0,
                          color: Colors.red,
                          fontWeight: FontWeight.w800)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Divider(
                  color: Colors.black.withOpacity(0.40),
                ),
              ),
              ListView.builder(
                itemCount: controller.data.value.paymentStatus == "yes"
                    ? controller.data.value.taxModel!.length
                    : Constant.taxList.length,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  TaxModel taxModel =
                      controller.data.value.paymentStatus == "yes"
                          ? controller.data.value.taxModel![index]
                          : Constant.taxList[index];
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${taxModel.libelle.toString()} (${taxModel.type == "Fixed" ? Constant().amountShow(amount: taxModel.value) : "${taxModel.value}%"})',
                            style: TextStyle(
                                letterSpacing: 1.0,
                                color: ConstantColors.subTitleTextColor,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                              Constant().amountShow(
                                  amount: controller
                                      .calculateTax(taxModel: taxModel)
                                      .toString()),
                              style: TextStyle(
                                  letterSpacing: 1.0,
                                  color: ConstantColors.titleTextColor,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Divider(
                          color: Colors.black.withOpacity(0.40),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Visibility(
                visible: controller.tipAmount.value == 0 ? false : true,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          "Driver Tip".tr,
                          style: TextStyle(
                              letterSpacing: 1.0,
                              color: ConstantColors.subTitleTextColor,
                              fontWeight: FontWeight.w600),
                        )),
                        Text(
                            Constant().amountShow(
                                amount: controller.tipAmount.toString()),
                            style: TextStyle(
                                letterSpacing: 1.0,
                                color: ConstantColors.titleTextColor,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Divider(
                        color: Colors.black.withOpacity(0.40),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Total".tr,
                    style: TextStyle(
                        letterSpacing: 1.0,
                        color: ConstantColors.titleTextColor,
                        fontWeight: FontWeight.w600),
                  )),
                  Text(
                      Constant().amountShow(
                          amount: controller.getTotalAmount().toString()),
                      style: TextStyle(
                          letterSpacing: 1.0,
                          color: ConstantColors.primary,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
