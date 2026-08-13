import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:salamty/features/emergency_ai/presentation/widgets/emergency_appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final TextEditingController _controller = TextEditingController();
  final supabase = Supabase.instance.client;

  bool _isLoading = false;
  String _aiResponse = "";
  bool _isDanger = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _makeCall() async {
    final Uri url = Uri.parse('tel:123');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  Future<void> _handleEmergency() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _aiResponse = "";
    });

    try {
      final session = supabase.auth.currentSession;

      final response = await http.post(
        Uri.parse(
          'https://emdrsbvdwazingirktby.supabase.co/functions/v1/smart-rescue',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${session?.accessToken}',
        },
        body: jsonEncode({"user_input": text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _aiResponse = data['message'];
          _isDanger = data['is_danger'] ?? false;
        });

        await supabase.from('emergency_logs').insert({
          'user_query': text,
          'ai_response': _aiResponse,
          'is_danger': _isDanger,
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: isArabic
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              /// HEADER
              const EmergencyAppbar(),

              const SizedBox(height: 24),

              /// WELCOME SECTION
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.medical_services_rounded,
                        color: cs.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded( // ← ده هو الحل
                      child: Column(
                        crossAxisAlignment: isArabic
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic
                                ? "أهلاً بك في قسم الطوارئ"
                                : "Welcome to Emergency",
                            style: TextStyle(
                              color: cs.onPrimaryContainer.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isArabic
                                ? "ازاي نقدر نساعدك دلوقتي؟"
                                : "How can we help you right now?",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: cs.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              /// INPUT CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cs.surfaceContainer,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: isArabic
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic
                          ? "صف الحالة بالتفصيل"
                          : "Describe the situation in detail",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      maxLines: 4,
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      style: TextStyle(fontSize: 15, color: cs.onSurface),
                      decoration: InputDecoration(
                        hintText: isArabic
                            ? "مثلاً: ابني بلع جسم غريب ووشه بدأ يزرق.."
                            : "e.g. My son swallowed a foreign object and his face turned blue..",
                        hintStyle: TextStyle(
                          color: cs.onSurfaceVariant,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: cs.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleEmergency,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(color: cs.onPrimary)
                            : Text(
                                isArabic
                                    ? "تحليل الحالة وإسعافها"
                                    : "Analyze & Assist",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// RESULT CARD
              if (_aiResponse.isNotEmpty)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _isDanger ? cs.errorContainer : cs.surfaceContainer,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _isDanger
                          ? cs.error.withOpacity(0.3)
                          : cs.outlineVariant,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: isArabic
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      /// RESULT TITLE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!isArabic)
                            Icon(
                              _isDanger
                                  ? Icons.warning_amber_rounded
                                  : Icons.check_circle_outline_rounded,
                              color: _isDanger ? cs.error : cs.primary,
                              size: 26,
                            ),
                          Text(
                            _isDanger
                                ? (isArabic
                                      ? "خطوات إنقاذ عاجلة"
                                      : "Emergency Steps")
                                : (isArabic
                                      ? "إرشادات طبية"
                                      : "Medical Guidance"),
                            style: TextStyle(
                              color: _isDanger
                                  ? cs.onErrorContainer
                                  : cs.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          if (isArabic)
                            Icon(
                              _isDanger
                                  ? Icons.warning_amber_rounded
                                  : Icons.check_circle_outline_rounded,
                              color: _isDanger ? cs.error : cs.primary,
                              size: 26,
                            ),
                        ],
                      ),

                      Divider(
                        height: 28,
                        thickness: 1,
                        color: cs.outlineVariant,
                      ),

                      /// RESPONSE TEXT
                      Text(
                        _aiResponse,
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.8,
                          color: _isDanger ? cs.onErrorContainer : cs.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      /// CALL BUTTON
                      if (_isDanger) ...[
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: _makeCall,
                            icon: const Icon(
                              Icons.phone_forwarded,
                              color: Colors.white,
                            ),
                            label: Text(
                              isArabic
                                  ? "اتصال فوري بالإسعاف (123)"
                                  : "Call Ambulance Now (123)",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.error,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ],
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
