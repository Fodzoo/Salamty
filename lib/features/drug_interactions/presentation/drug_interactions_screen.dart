import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/theme_provider/theme_provider.dart';

class DrugInteractionsScreen extends StatefulWidget {
  const DrugInteractionsScreen({super.key});

  @override
  State<DrugInteractionsScreen> createState() => _DrugInteractionsScreenState();
}

class _DrugInteractionsScreenState extends State<DrugInteractionsScreen> {
  final TextEditingController input1 = TextEditingController();
  final TextEditingController input2 = TextEditingController();
  bool loading = false;
  String result = "";
  bool hasError = false;

  Future<void> sendToFunction() async {
    if (loading) return;
    final isArabic = context.read<ThemeProvider>().locale.languageCode == 'ar';
    if (input1.text.trim().isEmpty || input2.text.trim().isEmpty) {
      setState(() {
        result = isArabic
            ? "برجاء إدخال اسم الدواءين للفحص"
            : "Please enter both medicine names";
        hasError = true;
      });
      return;
    }
    setState(() {
      loading = true;
      result = "";
      hasError = false;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;
      final session = Supabase.instance.client.auth.currentSession;

      if (session == null) {
        setState(() {
          loading = false;
          result = isArabic ? "يجب تسجيل الدخول أولاً" : "You must login first";
          hasError = true;
        });
        return;
      }

      final response = await http.post(
        Uri.parse(
          "https://emdrsbvdwazingirktby.supabase.co/functions/v1/super-task",
        ),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${session.accessToken}",
        },
        body: jsonEncode({
          "userId": user?.id,
          "userName": user?.userMetadata?['full_name'] ?? "مستخدم سلامتي",
          "type": "drug_interaction",
          "medicines": [
            {"name": input1.text.trim()},
            {"name": input2.text.trim()},
          ],
        }),
      );

      final data = jsonDecode(response.body);

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          loading = false;
          result =
              data["description_ar"]?.toString() ??
              (isArabic ? "تم الفحص بنجاح" : "Analysis completed successfully");
          hasError = data["hasInteraction"] ?? false;
        });
      } else {
        setState(() {
          loading = false;
          result =
              data["error"]?.toString() ??
              (isArabic ? "حدث خطأ في السيرفر" : "Server error occurred");
          hasError = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        result = isArabic
            ? "خطأ في الاتصال: تأكد من الإنترنت"
            : "Connection error: Check your internet connection";
        hasError = true;
      });
    }
  }

  @override
  void dispose() {
    input1.dispose();
    input2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // APP BAR
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: cs.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isArabic ? "تداخلات الأدوية" : "Drug Interactions",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.purple,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // كارت الإدخال
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainer,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            color: cs.shadow.withOpacity(0.03),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildTextField(
                            context,
                            input1,
                            isArabic
                                ? "اسم الدواء الأول (مثال: Aspirin)"
                                : "First drug name (e.g., Aspirin)",
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            context,
                            input2,
                            isArabic
                                ? "اسم الدواء الثاني (مثال: Warfarin)"
                                : "Second drug name (e.g., Warfarin)",
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: loading ? null : sendToFunction,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cs.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      isArabic
                                          ? "تحليل التداخلات بالذكاء الاصطناعي"
                                          : "AI Interaction Analysis",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // كارت النتيجة
                    if (result.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: hasError
                              ? cs.errorContainer
                              : cs.surfaceContainer,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: hasError
                                ? cs.error.withOpacity(0.4)
                                : cs.outline.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  hasError
                                      ? Icons.warning_amber_rounded
                                      : Icons.check_circle_outline,
                                  color: hasError ? cs.error : cs.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  hasError
                                      ? (isArabic
                                            ? "تحذير طبي"
                                            : "Medical Warning")
                                      : (isArabic
                                            ? "نتيجة الفحص"
                                            : "Analysis Result"),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: hasError ? cs.error : cs.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SelectableText(
                              result,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                color: hasError
                                    ? cs.onErrorContainer
                                    : cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    TextEditingController controller,
    String hint,
  ) {
    final cs = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      style: TextStyle(color: cs.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
        filled: true,
        fillColor: cs.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
