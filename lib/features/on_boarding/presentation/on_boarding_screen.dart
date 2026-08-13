import 'package:flutter/material.dart';
import 'package:salamty/features/login/presentation/login_screen.dart';
import 'package:salamty/features/on_boarding/presentation/data/onboarding_data.dart';
import 'widgets/top_bar.dart';
import 'widgets/page_item.dart';
import 'widgets/indicator.dart';
import 'widgets/button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  double currentPage = 0;

  final data = OnboardingData.items;
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        currentPage = controller.page ?? 0;
      });
    });
  }

  void goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              OnboardingTopBar(onSkip: goToLogin),

              const SizedBox(height: 20),

              Expanded(
                child: PageView.builder(
                  controller: controller,
                  itemCount: data.length,
                  itemBuilder: (_, index) {
                    return OnboardingPageItem(
                      title: data[index]["title"]!,
                      desc: data[index]["desc"]!,
                      image: data[index]["image"]!,
                      index: index,
                      currentPage: currentPage,
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              OnboardingIndicator(
                length: data.length,
                currentPage: currentPage,
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OnboardingButton(
                  isLast: currentPage.round() == data.length - 1,
                  onNext: () {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                    );
                  },
                  onFinish: goToLogin,
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}