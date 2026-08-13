import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';

class BMICalcAppbar extends StatelessWidget {
  const BMICalcAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(6),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: Color(0xFF0059BB),
            ),
          ),
        ),

        Text(
          isArabic ? "حاسبة مؤشر كتلة الجسم" : "BMI Calculator",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0059BB),
          ),
        ),

        Container(
          width: 45,
          height: 45,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Hero(
            tag: 'medication_icon',
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.monitor_weight,
                color: Colors.green,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
