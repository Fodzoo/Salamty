import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:salamty/features/forgot_password/presentation/forgot_password_screen.dart';
import 'package:salamty/features/home/presentation/home_screen.dart';
import 'package:salamty/features/login/presentation/widgets/create_account_text_body.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginFormBody extends StatefulWidget {
  const LoginFormBody({super.key});

  @override
  State<LoginFormBody> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginFormBody> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isHidden = true;
  String _resultTest = '';
  bool isLoading = false;

  final supabase = Supabase.instance.client;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login(bool isArabic) async {
    setState(() {
      isLoading = true;
      _resultTest = '';
    });
    try {
      final response = await supabase.auth.signInWithPassword(
        password: passwordController.text,
        email: emailController.text,
      );
      if (response.session != null) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        setState(() {
          isLoading = false;
          _resultTest = isArabic
              ? 'بريد إلكتروني أو كلمة مرور خاطئة'
              : 'Wrong Email or Password';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        _resultTest = isArabic
            ? 'بريد إلكتروني أو كلمة مرور خاطئة'
            : 'Wrong Email or Password';
      });
    }
  }

  void goToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.15),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: cs.shadow.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isArabic ? "تسجيل الدخول" : "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),

          const SizedBox(height: 24),

          /// EMAIL
          Text(
            isArabic ? "البريد الإلكتروني" : "Email",
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: TextField(
              controller: emailController,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: TextStyle(fontSize: 14, color: cs.onSurface),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: cs.onSurfaceVariant,
                ),
                hintText: isArabic ? "البريد الإلكتروني" : "Email",
                hintStyle: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// PASSWORD
          Text(
            isArabic ? "كلمة المرور" : "Password",
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: TextField(
              controller: passwordController,
              obscureText: isHidden,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: TextStyle(fontSize: 14, color: cs.onSurface),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: cs.onSurfaceVariant,
                ),
                suffixIcon: IconButton(
                  splashRadius: 20,
                  onPressed: () => setState(() => isHidden = !isHidden),
                  icon: Icon(
                    isHidden ? Icons.visibility_off : Icons.visibility,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                hintText: isArabic ? "كلمة المرور" : "Password",
                hintStyle: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// FORGOT PASSWORD
          GestureDetector(
            onTap: goToForgotPassword,
            child: Text(
              isArabic ? "نسيت كلمة المرور؟" : "Forgot Password ?",
              textAlign: isArabic ? TextAlign.left : TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: cs.primary,
                fontSize: 14,
              ),
            ),
          ),

          const SizedBox(height: 24),

          /// LOGIN BUTTON
          SizedBox(
            height: 48,
            child: isLoading
                ? Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: cs.primary,
                        strokeWidth: 3,
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () => login(isArabic),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isArabic ? "دخول" : "Login",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
          ),

          const SizedBox(height: 12),

          /// ERROR MESSAGE
          if (_resultTest.isNotEmpty)
            Text(
              _resultTest,
              style: TextStyle(color: cs.error),
              textAlign: TextAlign.center,
            ),

          const SizedBox(height: 16),

          const CreateAccountTextBody(),
        ],
      ),
    );
  }
}
