import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviez24/app/theme/font_styles.dart';

class SnackBarMessage extends GetSnackBar{
  final String actionText;
  SnackBarMessage({super.key, required String message, required this.actionText}):super(title: message);

  late SnackbarController controller;

  Color get dismissColor => Colors.white;

  @override
  EdgeInsets get margin => const EdgeInsets.all(12);

  @override
  EdgeInsets get padding => const EdgeInsets.only(top: 8, bottom: 3, left: 12);

  @override
  double get borderRadius => 4;

  @override
  Color get backgroundColor => Colors.black;

  @override
  Widget? get messageText => const SizedBox(height: 0);

  @override
  SnackPosition get snackPosition => SnackPosition.TOP;

  @override
  Widget? get titleText => SizedBox(
    // height: 18,
    child: Text(
      title ?? '',
      style: subBodyMediumStyle.withColor(Colors.white),
    ),
  );

  @override
  Duration? get duration => const Duration(seconds: 5);

  @override
  Duration get animationDuration => const Duration(milliseconds: 300);

  @override
  SnackbarController show() {
    Get.closeCurrentSnackbar();
    controller = Get.showSnackbar(this);
    return controller;
  }

  @override
  bool get isDismissible => true;

  @override
  Widget? get mainButton => SizedBox(
    height: 32,
    child: TextButton(
        child: Text(
          actionText,
          style: textButtonTextStyle.withColor(dismissColor),
        ),
        onPressed: () {
          controller.close();
        }),
  );
}