import 'package:flutter/material.dart';

class OnboardingButton extends StatelessWidget {
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  const OnboardingButton({
    super.key,
    required this.isLast,
    required this.onNext,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLast ? onFinish : onNext,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF0059BB),
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            isLast ? "Get Started" : "Next",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}