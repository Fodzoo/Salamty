import 'package:flutter/material.dart';
import 'package:salamty/core/resourses/app_colors.dart';
import 'package:salamty/features/login/presentation/login_screen.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  void goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
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
                Icons.lock_outline,
                color: Color(0xFF0059BB),
                size: 32,
              ),
            ),
          ),
          SizedBox(height: 12),
          const Text(
            "Reset Password",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 24),

          const Text(
            "Verification Code",
            style: TextStyle(color: Color(0x88000000)),
          ),

          const SizedBox(height: 6),

          TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "* * * * *",
              hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 18),
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

          const SizedBox(height: 24),

          const Text(
            "New Password",
            style: TextStyle(color: Color(0x88000000)),
          ),


          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline,color: Colors.grey,),
              hintText: "New Password",
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

          const SizedBox(height: 12),

          const Text(
            "Confirm Password",
            style: TextStyle(color: Color(0x88000000)),
          ),

          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline,color: Colors.grey,),
              hintText: "Confirm Password",
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
                goToLogin();
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
                "Reset Password",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
