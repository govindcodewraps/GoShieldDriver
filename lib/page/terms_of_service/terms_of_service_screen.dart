import 'package:goshield_driver/controller/terms_of_service_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../CommanWebView.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      CommonWebviewScreen(
        page_name:
        "Terms Condition",
        url:
        "https://goshieldapp.com/terms-conditions/",
        //"${AppConfig.RAW_BASE_URL}/mobile-page/terms",
      ),);

    // return GetBuilder<TermsOfServiceController>(
    //     init: TermsOfServiceController(),
    //     builder: (controller) {
    //       return Scaffold(
    //         body: Padding(
    //           padding: const EdgeInsets.all(20.0),
    //           child: controller.data != null
    //               ? Html(
    //                   data: controller.data,
    //                 )
    //               : const Offstage(),
    //         ),
    //       );
    //     });
  }
}
