import 'package:flutter/material.dart';
import 'package:moviez24/app/base/base_controller.dart';

abstract class BaseView<T extends BaseController> extends StatelessWidget {
  const BaseView({super.key});

  T get controller;
}
