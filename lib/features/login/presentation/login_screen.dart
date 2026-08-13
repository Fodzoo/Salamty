import 'package:flutter/material.dart';
import 'package:salamty/core/widgets/logo_body.dart';
import 'package:salamty/features/login/presentation/widgets/login_form_body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [LogoBody(), SizedBox(height: 32), LoginFormBody()],
          ),
        ),
      ),
    );
  }
}
