import 'package:flutter/material.dart';
import 'package:salamty/core/resourses/assets.dart';

class LogoBody extends StatelessWidget {
  const LogoBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
        SizedBox(
          width: 180,
          height: 180,
          child: Image.asset(
            AssetImages.logo2,
            fit: BoxFit.cover,
          ),
        ),
    );
  }
}
