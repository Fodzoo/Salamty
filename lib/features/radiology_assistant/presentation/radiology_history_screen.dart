import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:salamty/features/radiology_assistant/presentation/radiology_details_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RadiologyHistoryScreen extends StatefulWidget {
  const RadiologyHistoryScreen({super.key});

  @override
  State<RadiologyHistoryScreen> createState() => _RadiologyHistoryScreenState();
}

class _RadiologyHistoryScreenState extends State<RadiologyHistoryScreen> {
  final supabase = Supabase.instance.client;

  List records = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    final user = supabase.auth.currentUser;
    final response = await supabase
        .from('radiology_records')
        .select()
        .eq('user_id', user!.id)
        .order('created_at', ascending: false);

    setState(() {
      records = response;
      loading = false;
    });
  }

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
    if (!isArabic) return level ?? "low";
    switch (level?.toLowerCase()) {
      case 'high':
        return 'مرتفع';
      case 'medium':
        return 'متوسط';
      default:
        return 'منخفض';
    }
  }

  String getScanTypeLabel(String? scanType, bool isArabic) {
    if (!isArabic) return scanType ?? "Radiology Scan";
    final type = scanType?.toLowerCase() ?? "";
    if (type.contains("ct")) return "أشعة مقطعية";
    if (type.contains("mri")) return "رنين مغناطيسي";
    if (type.contains("xray")) return "أشعة سينية";
    if (type.contains("radiology")) return "أشعة طبية";
    return scanType ?? "أشعة طبية";
  }

  String formatDate(String date) {
    final d = DateTime.parse(date);
    return "${d.day}/${d.month}/${d.year}";
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

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
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
                    isArabic ? "سجل الأشعة" : "Radiology History",
                    style: TextStyle(
                      color: cs.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: fetchRecords,
                color: cs.primary,
                child: loading
                    ? Center(
                        child: CircularProgressIndicator(color: cs.primary),
                      )
                    : records.isEmpty
                    /// EMPTY STATE
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medical_information_outlined,
                              size: 70,
                              color: cs.onSurfaceVariant,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isArabic
                                  ? "لا توجد أشعة محللة بعد"
                                  : "No scans analyzed yet",
                              style: TextStyle(color: cs.onSurfaceVariant),
                            ),
                          ],
                        ),
                      )
                    /// LIST
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: records.length,
                        itemBuilder: (context, index) {
                          final item = records[index];
                          final severityColor = getSeverityColor(
                            item['severity_level'],
                          );

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      RadiologyDetailsScreen(data: item),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: cs.surfaceContainer,
                                border: Border.all(color: cs.outlineVariant),
                                boxShadow: [
                                  BoxShadow(
                                    color: cs.shadow.withOpacity(0.05),
                                    blurRadius: 25,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Row(
                                textDirection: isArabic
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                children: [
                                  /// SEVERITY BAR
                                  Container(
                                    width: 6,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: severityColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  /// ICON
                                  Container(
                                    width: 55,
                                    height: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: severityColor.withOpacity(0.12),
                                    ),
                                    child: Icon(
                                      getScanIcon(item['scan_type']),
                                      color: severityColor,
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  /// CONTENT
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: isArabic
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          getScanTypeLabel(
                                            item['scan_type'],
                                            isArabic,
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: cs.onSurface,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          item['ai_diagnosis'] ??
                                              (isArabic
                                                  ? "لا يوجد تشخيص"
                                                  : "No diagnosis"),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: isArabic
                                              ? TextAlign.right
                                              : TextAlign.left,
                                          style: TextStyle(
                                            color: cs.onSurfaceVariant,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          textDirection: isArabic
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5,
                                                  ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: severityColor
                                                    .withOpacity(0.12),
                                              ),
                                              child: Text(
                                                getSeverityLabel(
                                                  item['severity_level'],
                                                  isArabic,
                                                ),
                                                style: TextStyle(
                                                  color: severityColor,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            Icon(
                                              Icons.calendar_today,
                                              size: 12,
                                              color: cs.onSurfaceVariant,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              formatDate(item['created_at']),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: cs.onSurfaceVariant,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  /// ARROW
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: cs.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      isArabic
                                          ? Icons.arrow_back_ios
                                          : Icons.arrow_forward_ios,
                                      size: 14,
                                      color: cs.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
