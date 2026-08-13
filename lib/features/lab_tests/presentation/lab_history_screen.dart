import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme_provider/theme_provider.dart';
import 'lab_details_screen.dart';

class LabHistoryScreen extends StatefulWidget {
  const LabHistoryScreen({super.key});

  @override
  State<LabHistoryScreen> createState() => _LabHistoryScreenState();
}

class _LabHistoryScreenState extends State<LabHistoryScreen> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> records = [];
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchRecords();
  }

  Future<void> fetchRecords() async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      final isArabic =
          context.watch<ThemeProvider>().locale.languageCode == 'ar';
      setState(() {
        loading = false;
        errorMessage = isArabic
            ? "انتهت الجلسة، يرجى تسجيل الدخول مرة أخرى."
            : "User session expired. Please log in again.";
      });
      return;
    }

    try {
      if (!mounted) return;
      setState(() {
        loading = true;
        errorMessage = null;
      });

      final List<Map<String, dynamic>> res = await supabase
          .from('medical_records')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          records = res;
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        final isArabic =
            WidgetsBinding.instance.platformDispatcher.locale.languageCode == 'ar';
        setState(() {
          loading = false;
          errorMessage = isArabic
              ? "حدث خطأ أثناء جلب التحاليل، يرجى المحاولة مجدداً."
              : "An error occurred while loading analyses. Please try again.";        });
      }
    }
  }

  // الألوان دي ثابتة عشان بتعبر عن حالة طبية مش عن ثيم
  Color getStatusColor(String? status) {
    switch (status) {
      case 'critical':
        return const Color(0xFFDC2626);
      case 'warning':
        return const Color(0xFFFBBF24);
      default:
        return const Color(0xFF10B981);
    }
  }

  String formatDate(String? date) {
    if (date == null) return "--/--/----";
    try {
      final d = DateTime.parse(date);
      final day = d.day.toString().padLeft(2, '0');
      final month = d.month.toString().padLeft(2, '0');
      return "$day/$month/${d.year}";
    } catch (_) {
      return "--/--/----";
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            _header(cs),
            Expanded(
              child: RefreshIndicator(
                onRefresh: fetchRecords,
                color: cs.primary,
                child: loading
                    ? Center(
                        child: CircularProgressIndicator(color: cs.primary),
                      )
                    : errorMessage != null
                    ? _errorWidget(errorMessage!, cs)
                    : records.isEmpty
                    ? _empty(cs)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: records.length,
                        itemBuilder: (context, i) => _card(records[i], cs),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(ColorScheme cs) {
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';
    return Padding(
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
            isArabic ? "سجل التحاليل" : "Lab History",
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _empty(ColorScheme cs) {
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 70,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(height: 12),
              Text(
                isArabic ? "لا توجد تحاليل حتى الآن" : "No analyses found yet",
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _errorWidget(String message, ColorScheme cs) {
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Center(
          child: Column(
            children: [
              Icon(Icons.wifi_off_rounded, size: 60, color: cs.error),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: cs.onSurfaceVariant, fontSize: 15),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: fetchRecords,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(isArabic ? "إعادة المحاولة" : "Retry"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _card(Map<String, dynamic> item, ColorScheme cs) {
    final color = getStatusColor(item['alert_status']);
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LabDetailsScreen(data: item)),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: cs.surfaceContainer,
          border: Border.all(color: cs.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            /// STATUS BAR
            Container(
              width: 5,
              height: 65,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(width: 14),

            /// CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['test_name'] ??
                        (isArabic ? "تحليل غير معروف" : "Unknown Test"),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['status_text'] ??
                        (isArabic
                            ? "لا يوجد وصف متاح"
                            : "No description available"),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
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

            /// ARROW
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.arrow_forward_ios, size: 12, color: cs.primary),
            ),
          ],
        ),
      ),
    );
  }
}
