import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle get bodySemiBold             => baseTextStyle.boldFont.normalSize.withColor(Colors.black);

TextStyle get subBodyMediumStyle       => mediumTextStyle.smallSize.withColor(Colors.black);

TextStyle get baseTextStyle            => GoogleFonts.poppins();
TextStyle get mediumTextStyle          => GoogleFonts.poppins(fontWeight: FontWeight.w500);
TextStyle get textButtonTextStyle      => mediumTextStyle.normalSize.withColor(Colors.blue);

extension TextStyleHelpers on TextStyle {
  TextStyle get extraBoldFont => copyWith(fontWeight: FontWeight.w700);
  TextStyle get boldFont => copyWith(fontWeight: FontWeight.w600);
  TextStyle get regularFont => copyWith(fontWeight: FontWeight.w400);
  TextStyle get verySmallSize => copyWith(fontSize: 10);
  TextStyle get smallSize => copyWith(fontSize: 12);
  TextStyle get normalSize => copyWith(fontSize: 14);
  TextStyle get largeSize => copyWith(fontSize: 16);
  TextStyle get veryLargeSize => copyWith(fontSize: 18);
  TextStyle get extraLargeSize => copyWith(fontSize: 20);
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle withSize(double size) => copyWith(fontSize: size);
}
