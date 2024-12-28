import 'package:flutter/material.dart';

class MoviesAppBar extends AppBar {
  final String titleText;
  MoviesAppBar({super.key, required this.titleText});

  @override
  Widget? get title => Text(
        titleText,
        style: titleTextStyle,
      );
}
