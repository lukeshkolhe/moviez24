import 'package:flutter/material.dart';
import 'package:moviez24/app/shared_widgets/messages/message.dart';

class SuccessMessage extends SnackBarMessage {
  SuccessMessage({super.key, required super.message})
      : super(
    actionText: 'Dismiss',
  );

  @override
  Color get backgroundColor => Colors.green;

  @override
  Color get dismissColor => Colors.white;
}