import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'lab_history_screen.dart';

class LabTestsScreen extends StatefulWidget {
  const LabTestsScreen({super.key});

  @override
  State<LabTestsScreen> createState() => _LabTestsScreenState();
}

class _LabTestsScreenState extends State<LabTestsScreen>
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

  String _getMimeType(String? ext) {
    switch (ext?.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }

  Future<Map<String, dynamic>> analyzeFile({
    required String fileUrl,
    required String fileType,
  }) async {
    final token = supabase.auth.currentSession?.accessToken;

    final res = await http.post(
      Uri.parse(
        'https://emdrsbvdwazingirktby.supabase.co/functions/v1/dynamic-responder',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"fileUrl": fileUrl, "fileType": fileType}),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception(res.body);
    }
  }

  Future<String> uploadFile(PlatformFile file) async {
    final filePath = file.path;
    if (filePath == null) throw Exception("File path is null");

    final user = supabase.auth.currentUser;
    final fileName = "${DateTime.now().millisecondsSinceEpoch}_${file.name}";
    final path = "medical/${user!.id}/$fileName";

    await supabase.storage.from('medical-reports').upload(path, File(filePath));
    return supabase.storage.from('medical-reports').getPublicUrl(path);
  }

  Future<void> saveRecord({
    required String fileUrl,
    required String fileType,
    required String testName,
    required Map analysis,
  }) async {
    final user = supabase.auth.currentUser;
    await supabase.from('medical_records').insert({
      'user_id': user?.id,
      'file_url': fileUrl,
      'file_type': fileType,
      'test_name': testName,
      'status_text': analysis['status_text'],
      'results_data': analysis['results_data'],
      'alert_status': analysis['alert_status'],
      'medical_advice': analysis['medical_advice'],
      'ai_insights': analysis['ai_insights'],
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
    );

    if (result == null) return;

    setState(() {
      selectedFile = result.files.first;
      analyzing = true;
    });

    try {
      final fileUrl = await uploadFile(selectedFile!);
      final mimeType = _getMimeType(selectedFile!.extension);

      final response = await analyzeFile(fileUrl: fileUrl, fileType: mimeType);

      await saveRecord(
        fileUrl: fileUrl,
        fileType: mimeType,
        testName: selectedFile!.name,
        analysis: response,
      );

      setState(() {
        analysisResult = response;
        analyzing = false;
        uploaded = true;
      });
    } catch (e) {
      setState(() => analyzing = false);
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
                      isArabic ? "تحليل التحاليل الطبية" : "Lab Analysis",
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
                              builder: (_) => const LabHistoryScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // status_text
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
                                              Icons.cloud_upload,
                                              color: cs.primary,
                                              size: 45,
                                            ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  Text(
                                    isArabic
                                        ? "رفع تقرير التحاليل"
                                        : "Upload Lab Report",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: cs.onSurface,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    isArabic
                                        ? "سيقوم الذكاء الاصطناعي بتحليل نتائجك الطبية"
                                        : "AI will analyze your medical results",
                                    style: TextStyle(
                                      color: cs.onSurfaceVariant,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  /// UPLOAD BUTTON
                                  GestureDetector(
                                    onTap: analyzing ? null : pickFile,
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
                                              ? isArabic
                                                    ? "جاري التحليل..."
                                                    : "Analyzing..."
                                              : isArabic
                                              ? "رفع وتحليل"
                                              : "Upload & Analyze",
                                          style: TextStyle(
                                            color: analyzing
                                                ? cs.onSurfaceVariant
                                                : cs.onPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  if (selectedFile != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// STATUS CARD
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: cs.primaryContainer,
                                  border: Border.all(color: cs.outlineVariant),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: cs.primary,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        // ✅ صح
                                        analysisResult?['status_text'] ??
                                            (isArabic
                                                ? "لا توجد حالة"
                                                : "No status"),
                                        style: TextStyle(
                                          color: cs.onPrimaryContainer,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // analysisResult?['ai_insights'] ?? isArabic ? "لا توجد نتائج متاحة" : "No insights available"
                              const SizedBox(height: 16),

                              Text(
                                isArabic
                                    ? "تحليل الذكاء الاصطناعي"
                                    : "AI Insights",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSurface,
                                ),
                              ),

                              const SizedBox(height: 10),

                              /// INSIGHTS CARD
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: cs.surfaceContainer,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: cs.outlineVariant,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: cs.shadow.withOpacity(0.05),
                                        blurRadius: 25,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      // ✅ صح
                                      analysisResult?['ai_insights'] ??
                                          (isArabic
                                              ? "لا توجد نتائج متاحة"
                                              : "No insights available"),
                                      style: TextStyle(
                                        fontSize: 15,
                                        height: 1.8,
                                        color: cs.onSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              /// NEW ANALYSIS BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      uploaded = false;
                                      selectedFile = null;
                                      analysisResult = null;
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
                                    isArabic ? "تحليل جديد" : "New Analysis",
                                    style: TextStyle(
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
