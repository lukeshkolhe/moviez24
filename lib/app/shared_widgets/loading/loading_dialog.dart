import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moviez24/app/base/dialogs/custom_dialog.dart';
import 'package:moviez24/app/shared_widgets/layouts/vertical_space.dart';
import 'package:moviez24/app/theme/colors.dart';
import 'package:moviez24/app/theme/font_styles.dart';

class LoadingManager {
  late DialogRoute? _route;

  startLoading() {
    _route = DialogRoute(
      context: Get.context!,
      builder: (_) => const _LoadingDialog(),
    );
    Navigator.of(Get.context!).push(_route!);
  }

  stopLoading() {
    if (_route != null) {
      Navigator.of(Get.context!).removeRoute(_route!);
    }
  }
}

class _LoadingDialog extends CustomDialog {
  @override
  bool get isBarrierDismissible => true;

  const _LoadingDialog();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                color: secondaryTextColor,
                backgroundColor: bgColor,
              ),
              const VerticalSpace(height: 25),
              Text(
                'Please wait for a moment!',
                style: bodySemiBold.copyWith(decoration: TextDecoration.none),
              )
            ],
          ),
        ),
      ),
    );
  }
}
