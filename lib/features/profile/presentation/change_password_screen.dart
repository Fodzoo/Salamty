import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isHiddenNew = true;
  bool isHiddenConfirm = true;
  bool isLoading = false;

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await supabase.auth.updateUser(
        UserAttributes(password: newPasswordController.text.trim()),
      );

      if (!mounted) return;

      final isArabic = context.read<ThemeProvider>().locale.languageCode == 'ar';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? "تم تغيير كلمة المرور بنجاح"
                : "Password changed successfully",
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';
    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        children: [
          const SizedBox(height: 24),

          /// HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, color: cs.onSurface),
                ),
                const SizedBox(width: 12),
                Text(
                  isArabic ? "تغيير كلمة المرور" : "Change Password",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /// ICON
                    Center(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lock_outline,
                          size: 44,
                          color: cs.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// NEW PASSWORD
                    Text(
                      isArabic ? "كلمة المرور الجديدة" : "New Password",
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: isHiddenNew,
                      style: TextStyle(color: cs.onSurface),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return isArabic
                              ? "يرجى إدخال كلمة مرور جديدة"
                              : "Please enter new password";
                        if (value.length < 6)
                          return isArabic
                              ? "يجب أن تكون كلمة المرور 6 أحرف على الأقل"
                              : "Password must be at least 6 characters";
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: isArabic
                            ? "أدخل كلمة المرور الجديدة"
                            : "Enter new password",
                        hintStyle: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: cs.onSurfaceVariant,
                        ),
                        suffixIcon: IconButton(
                          splashRadius: 20,
                          onPressed: () =>
                              setState(() => isHiddenNew = !isHiddenNew),
                          icon: Icon(
                            isHiddenNew
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        filled: true,
                        fillColor: cs.surfaceContainerHighest,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: cs.outlineVariant),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: cs.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: cs.primary, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: cs.error),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: cs.error, width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// CONFIRM PASSWORD
                    Text(
                      isArabic ? "تأكيد كلمة المرور" : "Confirm Password",
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: isHiddenConfirm,
                      style: TextStyle(color: cs.onSurface),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return isArabic
                              ? "يرجى تأكيد كلمة المرور"
                              : "Please confirm your password";
                        if (value != newPasswordController.text)
                          return isArabic
                              ? "كلمتا المرور غير متطابقتين"
                              : "Passwords do not match";
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: isArabic
                            ? "أكد كلمة المرور الجديدة"
                            : "Confirm new password",
                        hintStyle: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: cs.onSurfaceVariant,
                        ),
                        suffixIcon: IconButton(
                          splashRadius: 20,
                          onPressed: () => setState(
                            () => isHiddenConfirm = !isHiddenConfirm,
                          ),
                          icon: Icon(
                            isHiddenConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                        filled: true,
                        fillColor: cs.surfaceContainerHighest,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: cs.outlineVariant),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: cs.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: cs.primary, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: cs.error),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: cs.error, width: 1.5),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// SAVE BUTTON
                    SizedBox(
                      height: 52,
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
                              onPressed: changePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cs.primary,
                                foregroundColor: cs.onPrimary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                isArabic
                                    ? "تغيير كلمة المرور"
                                    : "Change Password",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
