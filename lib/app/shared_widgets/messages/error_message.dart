import 'package:moviez24/app/shared_widgets/messages/message.dart';

class ErrorMessage extends SnackBarMessage {
  ErrorMessage({super.key, message})
      : super(
          message: message ?? "Something Went Wrong",
          actionText: 'Dismiss',
        );
}
