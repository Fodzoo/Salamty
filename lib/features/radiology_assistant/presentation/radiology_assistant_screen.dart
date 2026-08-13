import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:salamty/features/radiology_assistant/presentation/radiology_history_screen.dart';

class RadiologyAssistantScreen extends StatefulWidget {
  const RadiologyAssistantScreen({super.key});

  @override
  State<RadiologyAssistantScreen> createState() =>
      _RadiologyAssistantScreenState();
}

class _RadiologyAssistantScreenState extends State<RadiologyAssistantScreen>
    with SingleTickerProviderStateMixin {
  bool uploaded = false;
  bool analyzing = false;

  PlatformFile? selectedFile;
  Map<String, dynamic>? analysisResult;

  late AnimationController _anim;
  late Animation<double> _fade;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeIn);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> analyzeRadiology({
    required String fileUrl,
    required String scanType,
  }) async {
    final token = supabase.auth.currentSession?.accessToken;
    final user = supabase.auth.currentUser;

    final response = await http.post(
      Uri.parse(
        'https://emdrsbvdwazingirktby.supabase.co/functions/v1/analyze-radiology',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "fileUrl": fileUrl,
        "scanType": scanType,
        "userId": user?.id,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("AI error: ${response.body}");
    }
  }

  Future<String> uploadFile(PlatformFile file, bool isArabic) async {
    final path = file.path;
    if (path == null)
      throw Exception(
        isArabic
            ? "ملف الأشعة غير موجود على الجهاز"
            : "Radiology file not found on device",
      );

    final sizeInMb = file.size / (1024 * 1024);
    if (sizeInMb > 10)
      throw Exception(
        isArabic
            ? "حجم الملف كبير جداً، يجب أن يكون أقل من 10 ميجا"
            : "File too large, must be under 10MB",
      );

    final user = supabase.auth.currentUser;
    if (user == null)
      throw Exception(
        isArabic
            ? "لم يتم العثور على بيانات مستخدم نشطة."
            : "No active user session found.",
      );

    final fileName = "${DateTime.now().millisecondsSinceEpoch}_${file.name}";
    final storagePath = "radiology/${user.id}/$fileName";

    try {
      await supabase.storage
          .from('radiology')
          .upload(
            storagePath,
            File(path),
            fileOptions: const FileOptions(upsert: false),
          );
    } catch (storageError) {
      throw Exception(
        isArabic
            ? "فشل رفع الملف: $storageError"
            : "File upload failed: $storageError",
      );
    }

    return supabase.storage.from('radiology').getPublicUrl(storagePath);
  }

  Future<void> pickFile(bool isArabic) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result == null) return;

    setState(() {
      uploaded = false;
      analysisResult = null;
      selectedFile = result.files.first;
      analyzing = true;
    });

    try {
      final fileUrl = await uploadFile(selectedFile!, isArabic);
      const scanType = "Radiology Scan";

      final response = await analyzeRadiology(
        fileUrl: fileUrl,
        scanType: scanType,
      );

      if (!mounted) return;
      setState(() {
        analysisResult = response;
        uploaded = true;
        analyzing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => analyzing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll("Exception:", "")),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'danger':
        return const Color(0xFFDC2626);
      case 'warning':
        return const Color(0xFFFBBF24);
      case 'safe':
      default:
        return const Color(0xFF10B981);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            children: [
              /// HEADER
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  textDirection: isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: cs.primary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isArabic ? "مساعد الأشعة" : "Radiology AI",
                      style: TextStyle(
                        color: cs.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.history, color: cs.primary, size: 20),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RadiologyHistoryScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              /// BODY
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: !uploaded
                      /// UPLOAD STATE
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 400),
                            scale: analyzing ? 0.95 : 1,
                            child: Container(
                              padding: const EdgeInsets.all(26),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: cs.surfaceContainer,
                                border: Border.all(color: cs.outlineVariant),
                                boxShadow: [
                                  BoxShadow(
                                    color: cs.shadow.withOpacity(0.06),
                                    blurRadius: 30,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  /// ICON BOX
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(26),
                                      color: cs.primaryContainer,
                                    ),
                                    child: Center(
                                      child: analyzing
                                          ? CircularProgressIndicator(
                                              color: cs.primary,
                                            )
                                          : Icon(
                                              Icons.medical_services,
                                              color: cs.primary,
                                              size: 45,
                                            ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  Text(
                                    isArabic
                                        ? "رفع صورة أشعة"
                                        : "Upload Radiology Scan",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: cs.onSurface,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    isArabic
                                        ? "سيقوم الذكاء الاصطناعي بتحليل الصورة وإنشاء تشخيص"
                                        : "AI will analyze your scan and generate diagnosis",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  /// UPLOAD BUTTON
                                  GestureDetector(
                                    onTap: analyzing
                                        ? null
                                        : () => pickFile(isArabic),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(18),
                                        color: analyzing
                                            ? cs.surfaceContainerHighest
                                            : cs.primary,
                                      ),
                                      child: Center(
                                        child: Text(
                                          analyzing
                                              ? (isArabic
                                                    ? "جاري التحليل..."
                                                    : "Analyzing...")
                                              : (isArabic
                                                    ? "رفع وتحليل"
                                                    : "Upload & Analyze"),
                                          style: TextStyle(
                                            color: analyzing
                                                ? cs.onSurfaceVariant
                                                : cs.onPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  if (selectedFile != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: Text(
                                        selectedFile!.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: cs.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        )
                      /// RESULT STATE
                      : Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: isArabic
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              /// DIAGNOSIS CARD
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: cs.primaryContainer,
                                  border: Border.all(color: cs.outlineVariant),
                                ),
                                child: Column(
                                  crossAxisAlignment: isArabic
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isArabic
                                          ? "تشخيص الذكاء الاصطناعي"
                                          : "AI Diagnosis",
                                      style: TextStyle(
                                        color: cs.onPrimaryContainer
                                            .withOpacity(0.7),
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      analysisResult?['diagnosis'] ??
                                          (isArabic
                                              ? "لا يوجد تشخيص"
                                              : "No diagnosis"),
                                      style: TextStyle(
                                        color: cs.onPrimaryContainer,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              /// SEVERITY CARD
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: cs.surfaceContainer,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: cs.outlineVariant),
                                  boxShadow: [
                                    BoxShadow(
                                      color: cs.shadow.withOpacity(0.05),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  textDirection: isArabic
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: _getStatusColor(
                                        analysisResult?['status'],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "${isArabic ? 'الشدة' : 'Severity'}: ${analysisResult?['severity'] ?? (isArabic ? 'غير معروف' : 'Unknown')}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: cs.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              Text(
                                isArabic ? "الملخص" : "Summary",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSurface,
                                ),
                              ),

                              const SizedBox(height: 10),

                              /// SUMMARY CARD
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    color: cs.surfaceContainer,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: cs.outlineVariant,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: cs.shadow.withOpacity(0.05),
                                        blurRadius: 25,
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      analysisResult?['summary_ar'] ??
                                          (isArabic
                                              ? "لا يوجد ملخص"
                                              : "No summary available"),
                                      textAlign: isArabic
                                          ? TextAlign.right
                                          : TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 16,
                                        height: 1.8,
                                        fontWeight: FontWeight.w500,
                                        color: cs.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              /// NEW SCAN BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      uploaded = false;
                                      analysisResult = null;
                                      selectedFile = null;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cs.primary,
                                    foregroundColor: cs.onPrimary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  icon: const Icon(Icons.refresh),
                                  label: Text(
                                    isArabic
                                        ? "تحليل أشعة أخرى"
                                        : "Analyze Another Scan",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
