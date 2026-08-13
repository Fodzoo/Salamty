import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicinesScreen extends StatefulWidget {
  const MedicinesScreen({super.key});

  @override
  State<MedicinesScreen> createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {
  final supabase = Supabase.instance.client;

  List medicines = [];
  List takenToday = [];
  int completed = 0;

  final medicineNameController = TextEditingController();
  final dosageController = TextEditingController();
  final frequencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    medicineNameController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    await getMedicines();
    await getCompletedMedicines();
  }

  Future<void> getMedicines() async {
    final userId = supabase.auth.currentUser!.id;
    final data = await supabase
        .from('medicines')
        .select()
        .eq('user_id', userId);
    setState(() => medicines = data);
  }

  Future<void> getCompletedMedicines() async {
    final userId = supabase.auth.currentUser!.id;
    final today = DateTime.now().toUtc(); // ← UTC
    final startOfDay = DateTime.utc(today.year, today.month, today.day); // ← UTC

    final data = await supabase
        .from('medicine_logs')
        .select()
        .eq('user_id', userId)
        .gte('taken_at', startOfDay.toIso8601String());

    final ids = data.map((e) => e['medicine_id'].toString()).toList();
    setState(() {
      completed = data.length;
      takenToday = ids;
    });
  }
  Future<void> markAsTaken(String medicineId) async {
    debugPrint("=== markAsTaken called with id: $medicineId");
    debugPrint("=== takenToday: $takenToday");
    debugPrint("=== contains: ${takenToday.contains(medicineId)}");

    if (takenToday.contains(medicineId)) return;

    final userId = supabase.auth.currentUser!.id;

    try {
      await supabase.from('medicine_logs').insert({
        'medicine_id': medicineId,
        'user_id': userId,
        'taken': true,
        'taken_at': DateTime.now().toUtc().toIso8601String(),
      });
      debugPrint("=== Insert successful");
    } catch (e) {
      debugPrint("=== Insert ERROR: $e");
    }

    // تأكد إن getCompletedMedicines اتكلمت
    debugPrint("=== Calling getCompletedMedicines...");
    await getCompletedMedicines();
    debugPrint("=== After getCompletedMedicines, takenToday: $takenToday");
  }

  Future<void> addMedicine() async {
    final userId = supabase.auth.currentUser!.id;
    await supabase.from('medicines').insert({
      'user_id': userId,
      'medicine_name': medicineNameController.text,
      'dosage': dosageController.text,
      'frequency': frequencyController.text,
    });
    medicineNameController.clear();
    dosageController.clear();
    frequencyController.clear();
    if (!mounted) return;
    Navigator.pop(context);
    await getMedicines();
  }

  Future<void> deleteMedicine(String id) async {
    await supabase.from('medicines').delete().eq('id', id);
    await getMedicines();
    await getCompletedMedicines();
  }

  void showDeleteDialog(String id, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: cs.surfaceContainer,
          title: Text(
            isArabic ? "حذف الدواء" : "Delete Medicine",
            style: TextStyle(color: cs.onSurface),
          ),
          content: Text(
            isArabic
                ? "هل أنت متأكد من حذف هذا الدواء؟"
                : "Are you sure you want to delete this medicine?",
            style: TextStyle(color: cs.onSurfaceVariant),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                isArabic ? "إلغاء" : "Cancel",
                style: TextStyle(color: cs.primary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.error,
                foregroundColor: cs.onError,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await deleteMedicine(id);
              },
              child: Text(
                isArabic ? "حذف" : "Delete",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void showAddDialog(bool isArabic, ColorScheme cs) {
    showDialog(
      context: context,
      builder: (context) {
        final cs = Theme.of(context).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: cs.surfaceContainer,
          title: Text(
            isArabic ? "إضافة دواء" : "Add Medicine",
            style: TextStyle(color: cs.onSurface),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: medicineNameController,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: TextStyle(color: cs.onSurface),
                  decoration: InputDecoration(
                    hintText: isArabic ? "اسم الدواء" : "Medicine Name",
                    hintStyle: TextStyle(color: cs.onSurfaceVariant),
                    filled: true,
                    fillColor: cs.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: dosageController,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: TextStyle(color: cs.onSurface),
                  decoration: InputDecoration(
                    hintText: isArabic ? "الجرعة" : "Dosage",
                    hintStyle: TextStyle(color: cs.onSurfaceVariant),
                    filled: true,
                    fillColor: cs.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: frequencyController,
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                  style: TextStyle(color: cs.onSurface),
                  decoration: InputDecoration(
                    hintText: isArabic ? "التكرار" : "Frequency",
                    hintStyle: TextStyle(color: cs.onSurfaceVariant),
                    filled: true,
                    fillColor: cs.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async => await addMedicine(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      isArabic ? "إضافة" : "Add",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';
    final double progress = medicines.isEmpty
        ? 0
        : completed / medicines.length;

    return Scaffold(
      backgroundColor: cs.surface,

      floatingActionButton: FloatingActionButton(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        onPressed: () => showAddDialog(isArabic, cs),
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
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
                    isArabic ? "أدويتي" : "My Medicines",
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
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.medication, color: cs.primary, size: 24),
                  ),
                ],
              ),
            ),

            /// PROGRESS CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      isArabic
                          ? "$completed/${medicines.length} أدوية مكتملة"
                          : "$completed/${medicines.length} medicines completed",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: cs.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 15),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(20),
                      backgroundColor: cs.onPrimaryContainer.withOpacity(0.15),
                      valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isArabic
                          ? "أكملت ${(progress * 100).toInt()}% اليوم"
                          : "You completed ${(progress * 100).toInt()}% today",
                      style: TextStyle(
                        color: cs.onPrimaryContainer.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// LIST
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  final med = medicines[index];

                  // ✅ toString عشان المقارنة تشتغل صح
                  final bool isTaken = takenToday.contains(
                    med['id'].toString(),
                  );

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: cs.outlineVariant),
                      boxShadow: [
                        BoxShadow(
                          color: cs.shadow.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: isArabic
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            med['medicine_name'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            isArabic
                                ? "الجرعة: ${med['dosage']}"
                                : "Dosage: ${med['dosage']}",
                            style: TextStyle(color: cs.onSurfaceVariant),
                          ),
                          Text(
                            isArabic
                                ? "التكرار: ${med['frequency']}"
                                : "Frequency: ${med['frequency']}",
                            style: TextStyle(color: cs.onSurfaceVariant),
                          ),

                          const SizedBox(height: 15),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: isTaken
                                  ? null
                                  : () async =>
                                        await markAsTaken(med['id'].toString()),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isTaken
                                    ? Colors.green
                                    : cs.primary,
                                disabledBackgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                disabledForegroundColor: Colors.white,
                                padding: const EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              icon: Icon(
                                isTaken ? Icons.check_circle : Icons.check,
                                color: Colors.white,
                              ),
                              label: Text(
                                isTaken
                                    ? (isArabic ? "تم الأخذ" : "Taken")
                                    : (isArabic
                                          ? "تسجيل الأخذ"
                                          : "Mark as Taken"),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => showDeleteDialog(
                                med['id'].toString(),
                                isArabic,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cs.errorContainer,
                                foregroundColor: cs.onErrorContainer,
                                padding: const EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              icon: const Icon(Icons.delete),
                              label: Text(
                                isArabic ? "حذف" : "Delete",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
