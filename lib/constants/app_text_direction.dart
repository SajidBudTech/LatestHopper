import 'package:flutter/material.dart';

class AppTextDirection {
  //Text direction
  // Right to left for arabic etc.
  // static TextDirection get defaultDirection => TextDirection.rtl;
  // static CrossAxisAlignment get axisAlignment => CrossAxisAlignment.end;

  // Left to right for english etc.
  static TextDirection get defaultDirection => TextDirection.ltr;
  static CrossAxisAlignment get axisAlignment => CrossAxisAlignment.start;
}
