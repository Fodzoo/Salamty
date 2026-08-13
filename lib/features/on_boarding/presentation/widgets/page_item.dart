import 'package:flutter/material.dart';

class OnboardingPageItem extends StatelessWidget {
  final String title;
  final String desc;
  final String image;
  final double currentPage;
  final int index;



  const OnboardingPageItem({
    super.key,
    required this.title,
    required this.desc,
    required this.image,
    required this.currentPage,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    double diff = currentPage - index;
    double scale = (1 - (diff.abs() * 0.3)).clamp(0.7, 1);
    double opacity = (1 - (diff.abs() * 0.8)).clamp(0.0, 1);

    return Transform.scale(
      scale: scale,
      child: Opacity(
        opacity: opacity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                image,
                height: 350,
              ),
            ),
            const SizedBox(height: 30),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                desc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}