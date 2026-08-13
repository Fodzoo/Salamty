import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:salamty/core/widgets/logo_body.dart';
import 'package:salamty/features/login/presentation/login_screen.dart';
import 'package:salamty/features/sign_up/presentation/widgets/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final PageController _controller = PageController();
  final supabase = Supabase.instance.client;

  String? gender;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final dobController = TextEditingController();

  String? bloodType;
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final diseasesController = TextEditingController();
  final allergiesController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    dobController.dispose();
    heightController.dispose();
    weightController.dispose();
    diseasesController.dispose();
    allergiesController.dispose();
    super.dispose();
  }

  Future<bool> signUp() async {
    setState(() => isLoading = true);
    try {
      final res = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {
          'first_name': firstNameController.text.trim(),
          'last_name': lastNameController.text.trim(),
          'phone': phoneController.text.trim(),
          'gender': gender,
          'date_of_birth': dobController.text.trim(),
          'height': int.tryParse(heightController.text),
          'weight': int.tryParse(weightController.text),
          'chronic_diseases': diseasesController.text.trim(),
          'allergies': allergiesController.text.trim(),
          'blood_type': bloodType,
        },
      );
      return res.user != null;
    } catch (e) {
      debugPrint("ERROR: $e");
      return false;
    } finally {
      setState(() => isLoading = false);
    }
  }

  void goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  InputDecoration _inputDecoration(
    ColorScheme cs, {
    String? hint,
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
      prefixIcon: icon != null ? Icon(icon, color: cs.onSurfaceVariant) : null,
      filled: true,
      fillColor: cs.surfaceContainerHighest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    );
  }

  Widget _label(String text, ColorScheme cs) {
    return Text(
      text,
      style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: cs.surface,
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          /// ===== STEP 1 =====
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// BACK BUTTON
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    children: [
                      Icon(Icons.arrow_back, color: cs.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(
                        isArabic ? "العودة لتسجيل الدخول" : "Back to Login",
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const LogoBody(),
                const SizedBox(height: 24),

                /// CARD
                Container(
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
                        isArabic ? "إنشاء حساب" : "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        isArabic ? "الخطوة 1 من 2" : "Step 1 of 2",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// FIRST NAME
                      _label(isArabic ? "الاسم الأول" : "First Name", cs),
                      const SizedBox(height: 6),
                      TextField(
                        controller: firstNameController,
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: TextStyle(color: cs.onSurface),
                        decoration: _inputDecoration(
                          cs,
                          icon: Icons.person_outline,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// LAST NAME
                      _label(isArabic ? "الاسم الأخير" : "Last Name", cs),
                      const SizedBox(height: 6),
                      TextField(
                        controller: lastNameController,
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: TextStyle(color: cs.onSurface),
                        decoration: _inputDecoration(
                          cs,
                          icon: Icons.person_outline,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// GENDER
                      _label(isArabic ? "الجنس" : "Gender", cs),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          border: Border.all(color: cs.outlineVariant),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: const SizedBox(),
                          dropdownColor: cs.surfaceContainerHighest,
                          hint: Text(
                            isArabic ? "اختر الجنس" : "Select Gender",
                            style: TextStyle(color: cs.onSurfaceVariant),
                          ),
                          value: gender,
                          items: [
                            DropdownMenuItem(
                              value: "male",
                              child: Text(
                                isArabic ? "ذكر" : "Male",
                                style: TextStyle(color: cs.onSurface),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "female",
                              child: Text(
                                isArabic ? "أنثى" : "Female",
                                style: TextStyle(color: cs.onSurface),
                              ),
                            ),
                          ],
                          onChanged: (value) => setState(() => gender = value),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// DATE OF BIRTH
                      _label(isArabic ? "تاريخ الميلاد" : "Date Of Birth", cs),
                      const SizedBox(height: 6),
                      TextField(
                        controller: dobController,
                        readOnly: true,
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: TextStyle(color: cs.onSurface),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            dobController.text =
                                "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                          }
                        },
                        decoration: _inputDecoration(cs, hint: "DD/MM/YYYY"),
                      ),

                      const SizedBox(height: 16),

                      /// PHONE
                      _label(isArabic ? "رقم الهاتف" : "Phone Number", cs),
                      const SizedBox(height: 6),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: TextStyle(color: cs.onSurface),
                        decoration: _inputDecoration(
                          cs,
                          icon: Icons.call_outlined,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// EMAIL
                      _label(isArabic ? "البريد الإلكتروني" : "Email", cs),
                      const SizedBox(height: 6),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: cs.onSurface),
                        decoration: _inputDecoration(
                          cs,
                          icon: Icons.email_outlined,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// PASSWORD
                      _label(isArabic ? "كلمة المرور" : "Password", cs),
                      const SizedBox(height: 6),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(color: cs.onSurface),
                        decoration: _inputDecoration(
                          cs,
                          icon: Icons.lock_outline,
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// NEXT BUTTON
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.primary,
                            foregroundColor: cs.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            isArabic ? "التالي" : "Next",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Login(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ===== STEP 2 =====
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// BACK BUTTON
                GestureDetector(
                  onTap: () {
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    children: [
                      Icon(Icons.arrow_back, color: cs.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(
                        isArabic ? "رجوع" : "Back",
                        style: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const LogoBody(),
                const SizedBox(height: 18),

                /// CARD
                Container(
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
                        isArabic ? "الملف الصحي" : "Health Profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        isArabic ? "الخطوة 2 من 2" : "Step 2 of 2",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: cs.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// HEIGHT + WEIGHT
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label(
                                  isArabic ? "الطول (سم)" : "Height (cm)",
                                  cs,
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: heightController,
                                  keyboardType: TextInputType.number,
                                  textAlign: isArabic
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: TextStyle(color: cs.onSurface),
                                  decoration: _inputDecoration(cs),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label(
                                  isArabic ? "الوزن (كجم)" : "Weight (kg)",
                                  cs,
                                ),
                                const SizedBox(height: 6),
                                TextField(
                                  controller: weightController,
                                  keyboardType: TextInputType.number,
                                  textAlign: isArabic
                                      ? TextAlign.right
                                      : TextAlign.left,
                                  style: TextStyle(color: cs.onSurface),
                                  decoration: _inputDecoration(cs),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// BLOOD TYPE
                      _label(isArabic ? "فصيلة الدم" : "Blood Type", cs),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerHighest,
                          border: Border.all(color: cs.outlineVariant),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: const SizedBox(),
                          dropdownColor: cs.surfaceContainerHighest,
                          hint: Text(
                            isArabic ? "اختر فصيلة الدم" : "Select Blood Type",
                            style: TextStyle(color: cs.onSurfaceVariant),
                          ),
                          value: bloodType,
                          items:
                              ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
                                  .map(
                                    (type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(
                                        type,
                                        style: TextStyle(color: cs.onSurface),
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) =>
                              setState(() => bloodType = value),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// CHRONIC DISEASES
                      _label(
                        isArabic ? "الأمراض المزمنة" : "Chronic Diseases",
                        cs,
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: diseasesController,
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: TextStyle(color: cs.onSurface),
                        decoration: _inputDecoration(cs),
                      ),

                      const SizedBox(height: 16),

                      /// ALLERGIES
                      _label(isArabic ? "الحساسية" : "Allergies", cs),
                      const SizedBox(height: 6),
                      TextField(
                        controller: allergiesController,
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: TextStyle(color: cs.onSurface),
                        decoration: _inputDecoration(cs),
                      ),

                      const SizedBox(height: 24),

                      /// BACK + COMPLETE BUTTONS
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  _controller.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: cs.surfaceContainerHighest,
                                  foregroundColor: cs.onSurface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  isArabic ? "رجوع" : "Back",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SizedBox(
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
                                      onPressed: () async {
                                        if (isLoading) return;
                                        final ok = await signUp();
                                        if (ok && mounted) goToLogin();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: cs.primary,
                                        foregroundColor: cs.onPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        isArabic ? "إتمام" : "Complete",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Login(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
