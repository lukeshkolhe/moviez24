import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HorizontalSpace extends SizedBox {
  const HorizontalSpace({super.key, required super.width});

  factory HorizontalSpace.extraSmall() => const HorizontalSpace(width: 4);
  factory HorizontalSpace.verySmall() => const HorizontalSpace(width: 6);
  factory HorizontalSpace.smaller() => const HorizontalSpace(width: 8);
  factory HorizontalSpace.small() => const HorizontalSpace(width: 12);
  factory HorizontalSpace.normal() => const HorizontalSpace(width: 16);
  factory HorizontalSpace.medium() => const HorizontalSpace(width: 20);
  factory HorizontalSpace.large() => const HorizontalSpace(width: 24);
}
