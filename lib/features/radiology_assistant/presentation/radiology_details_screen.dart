import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';

class RadiologyDetailsScreen extends StatelessWidget {
  final Map data;

  const RadiologyDetailsScreen({super.key, required this.data});

  Color getSeverityColor(String? level) {
    switch (level?.toLowerCase()) {
      case 'high':
        return const Color(0xFFDC2626);
      case 'medium':
        return const Color(0xFFFBBF24);
      default:
        return const Color(0xFF10B981);
    }
  }

  String getSeverityLabel(String? level, bool isArabic) {
    switch (level?.toLowerCase()) {
      case 'high':
        return isArabic ? 'مرتفع' : 'High';
      case 'medium':
        return isArabic ? 'متوسط' : 'Medium';
      default:
        return isArabic ? 'منخفض' : 'Low';
    }
  }

  IconData getScanIcon(String? scanType) {
    final type = scanType?.toLowerCase() ?? "";
    if (type.contains("ct")) return Icons.blur_circular;
    if (type.contains("mri")) return Icons.document_scanner;
    if (type.contains("xray")) return Icons.medical_services;
    return Icons.health_and_safety;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';
    final severityColor = getSeverityColor(data['severity_level']);

    return Scaffold(
      backgroundColor: cs.surface,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: cs.surface,
        centerTitle: true,
        iconTheme: IconThemeData(color: cs.onSurface),
        title: Text(
          isArabic ? "تفاصيل الأشعة" : "Radiology Details",
          style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// TOP CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: cs.primaryContainer,
                border: Border.all(color: cs.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: isArabic
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  /// SCAN TYPE + ICON
                  Row(
                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: cs.primary.withOpacity(0.15),
                        ),
                        child: Icon(
                          getScanIcon(data['scan_type']),
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: isArabic
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['scan_type'] ?? (isArabic ? "أشعة طبية" : "Radiology Scan"),
                              style: TextStyle(
                                color: cs.onPrimaryContainer,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isArabic
                                  ? "تحليل الأشعة بالذكاء الاصطناعي"
                                  : "AI Radiology Analysis",
                              style: TextStyle(
                                color: cs.onPrimaryContainer.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// DIAGNOSIS BOX
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: isArabic
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? "تشخيص الذكاء الاصطناعي" : "AI Diagnosis",
                          style: TextStyle(
                            color: cs.onPrimaryContainer.withOpacity(0.7),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data['ai_diagnosis'] ??
                              (isArabic ? "لا يوجد تشخيص" : "No diagnosis"),
                          textAlign: isArabic
                              ? TextAlign.right
                              : TextAlign.left,
                          style: TextStyle(
                            color: cs.onPrimaryContainer,
                            fontSize: 17,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// SEVERITY BADGE
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: severityColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      textDirection: isArabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: severityColor,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          getSeverityLabel(data['severity_level'], isArabic),
                          style: TextStyle(
                            color: severityColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// SUMMARY CARD
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cs.surfaceContainer,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: cs.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withOpacity(0.05),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: isArabic
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Row(
                      textDirection: isArabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      children: [
                        Icon(Icons.auto_awesome, color: cs.primary),
                        const SizedBox(width: 8),
                        Text(
                          isArabic ? "الملخص" : "Summary",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          data['summary_ar'] ??
                              (isArabic
                                  ? "لا يوجد ملخص"
                                  : "No summary available"),
                          textAlign: isArabic
                              ? TextAlign.right
                              : TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: cs.onSurfaceVariant,
                            height: 2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
