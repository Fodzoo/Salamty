import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:salamty/features/login/presentation/login_screen.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      },
      child: Text(
        isArabic
            ? "لديك حساب بالفعل؟ تسجيل الدخول"
            : "Already have an account? Login",
        textAlign: TextAlign.center,
        style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold),
      ),
    );
  }
}
