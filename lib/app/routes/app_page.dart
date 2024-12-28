import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppPage extends GetPage {
  AppPage({
    required super.name,
    required super.page,
    super.binding,
  });

  @override
  List<GetMiddleware>? get middlewares => [
        AppPageMiddleware(),
        ...?super.middlewares,
      ];
}

class AppPageMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // ToDo: log 'Navigating to Screen $route'
    return null;
  }
}
