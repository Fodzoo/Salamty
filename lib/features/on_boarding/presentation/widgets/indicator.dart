import 'package:flutter/material.dart';

class OnboardingIndicator extends StatelessWidget {
  final int length;
  final double currentPage;

  const OnboardingIndicator({
    super.key,
    required this.length,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        bool active = currentPage.round() == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF0059BB)
                : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}