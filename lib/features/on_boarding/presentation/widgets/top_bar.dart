import 'package:flutter/material.dart';

class OnboardingTopBar extends StatelessWidget {
  final VoidCallback onSkip;

  const OnboardingTopBar({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Salamty',
          style: TextStyle(
            color: Color(0xFF0059BB),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: onSkip,
          child: const Text(
            "Skip",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}