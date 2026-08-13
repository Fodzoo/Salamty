import 'dart:ui';
import 'package:flutter/cupertino.dart';
abstract class AppColors{
  static const BgColorWhite =Color(0xFFFFFFFF);
  static const borderColor = Color(0xFFE0E0E0);
  static const kPrimaryBgColor = BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFFF0F9FF), // أزرق فاتح جداً للنهاية
          Color(0xFFFFFFFF), // أبيض ناصع
          Color(0xFFE0FCFF), // أزرق فاتح
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
  );
}