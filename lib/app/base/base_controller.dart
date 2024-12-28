import 'package:get/get.dart';
import 'package:moviez24/app/shared_widgets/loading/loading_dialog.dart';

class BaseController extends FullLifeCycleController {
  final RxBool isLoading = false.obs;
  final RxBool somethingWentWrong = false.obs;
  LoadingManager loadingManager = LoadingManager();

  startLoading() {
    if (isLoading.value == false) {
      isLoading.value = true;
      _showLoadingDialog();
    }
  }

  _showLoadingDialog() async {
    await Future.delayed(const Duration(seconds: 0));
    loadingManager = LoadingManager();
    loadingManager.startLoading();
  }

  stopLoading() {
    if (isLoading.value == true) {
      isLoading.value = false;
      loadingManager.stopLoading();
    }
  }

  onSomethingWentWrong() {
    stopLoading();
    somethingWentWrong.value = true;
  }

  onRetry() {
    somethingWentWrong.value = false;
  }
}
