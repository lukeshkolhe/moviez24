import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class CustomDialog extends Dialog {
  const CustomDialog({super.key});

  bool get isBarrierDismissible => true;

  show() {
    // ToDo: log the opeing of this dialog in Analytics
    Get.dialog(this, barrierDismissible: isBarrierDismissible);
  }
}
