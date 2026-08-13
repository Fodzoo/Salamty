import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:salamty/features/sign_up/presentation/sign_up_screen.dart';

class CreateAccountTextBody extends StatelessWidget {
  const CreateAccountTextBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    void goToSignUp() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SignUpScreen()),
      );
    }

    return Column(
      children: [
        Text(
          isArabic ? "ليس لديك حساب؟" : "Don't have an account?",
          style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: goToSignUp,
          child: Text(
            isArabic ? "إنشاء حساب جديد" : "Create New Account",
            textAlign: TextAlign.center,
            style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}