import 'package:flutter/material.dart';
import 'package:salamty/core/resourses/app_colors.dart';
import 'package:salamty/features/forgot_password/presentation/reset_password_screen.dart';

class ForgotPasswordFormBody extends StatefulWidget {
  const ForgotPasswordFormBody({super.key});

  @override
  State<ForgotPasswordFormBody> createState() => _ForgotPasswordFormBodyState();
}

class _ForgotPasswordFormBodyState extends State<ForgotPasswordFormBody> {
  void goToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 20)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: Color(0xFF0059BB).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.email_outlined,
                color: Color(0xFF0059BB),
                size: 32,
              ),
            ),
          ),
          SizedBox(height: 12),
          const Text(
            "Forgot Password",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          const Text(
            "Enter your phone number or email and we'll send you a verification code",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),

          const SizedBox(height: 24),

          const Text(
            "Phone Number or Email",
            style: TextStyle(color: Color(0x88000000)),
          ),

          const SizedBox(height: 6),

          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email_outlined,color: Colors.grey,),
              hintText: "Phone Number or Email",
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: AppColors.borderColor,
                ),
              ),

            ),
          ),

          SizedBox(height: 24),

          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                goToResetPassword();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:Color(0xFF0059BB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: Color(0x33000000),
              ),
              child: Text(
                "Send Verification Code",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
