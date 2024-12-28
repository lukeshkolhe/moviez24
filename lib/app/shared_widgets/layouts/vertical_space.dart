import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerticalSpace extends SizedBox{
  const VerticalSpace({super.key, required super.height});

  factory VerticalSpace.extraSmall() => const VerticalSpace(height: 4);
  factory VerticalSpace.verySmall() => const VerticalSpace(height: 6);
  factory VerticalSpace.smaller() => const VerticalSpace(height: 8);
  factory VerticalSpace.small() => const VerticalSpace(height: 12);
  factory VerticalSpace.normal() => const VerticalSpace(height: 16);
  factory VerticalSpace.medium() => const VerticalSpace(height: 20);
  factory VerticalSpace.large() => const VerticalSpace(height: 24);
}