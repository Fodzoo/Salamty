// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
//
// class MedicinesScreen extends StatefulWidget {
//   const MedicinesScreen({super.key});
//
//   @override
//   State<MedicinesScreen> createState() => _MedicinesScreenState();
// }
//
// class _MedicinesScreenState extends State<MedicinesScreen> {
//   final supabase = Supabase.instance.client;
//
//   List medicines = [];
//   List takenToday = [];
//   int completed = 0;
//
//   final medicineNameController = TextEditingController();
//   final dosageController = TextEditingController();
//   final frequencyController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }
//
//   Future<void> loadData() async {
//     await getMedicines();
//     await getCompletedMedicines();
//   }
//
//   Future<void> getMedicines() async {
//     try {
//       final userId = supabase.auth.currentUser!.id;
//       final data = await supabase
//           .from('medicines')
//           .select()
//           .eq('user_id', userId);
//       setState(() => medicines = data);
//     } catch (e) {
//       debugPrint("Error fetching medicines: $e");
//     }
//   }
//
//   Future<void> getCompletedMedicines() async {
//     try {
//       final userId = supabase.auth.currentUser!.id;
//       final today = DateTime.now().toUtc();
//       final startOfDay = DateTime.utc(
//         today.year,
//         today.month,
//         today.day,
//         0,
//         0,
//         0,
//       );
//
//       final data = await supabase
//           .from('medicine_logs')
//           .select()
//           .eq('user_id', userId)
//           .gte('taken_at', startOfDay.toIso8601String());
//
//       final ids = data.map((e) => e['medicine_id']).toList();
//
//       if (mounted) {
//         setState(() {
//           completed = data.length;
//           takenToday = ids;
//         });
//       }
//     } catch (e) {
//       debugPrint("Error fetching completed medicines: $e");
//     }
//   }
//
//   Future<void> markAsTaken(dynamic medicineId) async {
//     if (takenToday.contains(medicineId)) return;
//
//     try {
//       final userId = supabase.auth.currentUser!.id;
//
//       debugPrint("جاري الإرسال للسيرفر... الـ medicineId هو: $medicineId");
//
//       // بنستنى السيرفر يرد الأول بدون setState مستعجلة
//       await supabase.from('medicine_logs').insert({
//         'medicine_id': medicineId,
//         'user_id': userId,
//         'taken': true,
//         'taken_at': DateTime.now().toUtc().toIso8601String(),
//       });
//
//       debugPrint("السيرفر وافق والعملية نجحت في الـ Database!");
//
//       // لو نجحت وتأكدنا، بنحدث الـ UI هنا علطول
//       if (mounted) {
//         setState(() {
//           if (!takenToday.contains(medicineId)) {
//             takenToday.add(medicineId);
//             completed++;
//           }
//         });
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Medication logged successfully!"),
//             backgroundColor: Colors.green,
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     } catch (e) {
//       // هنا هيمسك الأيرور الحقيقي ويطجعه في الـ Console وفي الشاشة
//       debugPrint("الأيرور الملعون هو: $e");
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("السيرفر رافض بسبب: $e"),
//             backgroundColor: Colors.red,
//             duration: const Duration(
//               seconds: 12,
//             ), // سبتها 12 ثانية عشان تلحقوا تقروها أو تصوروها
//           ),
//         );
//       }
//     }
//   }
//
//   Future<void> addMedicine() async {
//     try {
//       final userId = supabase.auth.currentUser!.id;
//       await supabase.from('medicines').insert({
//         'user_id': userId,
//         'medicine_name': medicineNameController.text,
//         'dosage': dosageController.text,
//         'frequency': frequencyController.text,
//       });
//       medicineNameController.clear();
//       dosageController.clear();
//       frequencyController.clear();
//       if (mounted) Navigator.pop(context);
//       await getMedicines();
//     } catch (e) {
//       debugPrint("Error adding medicine: $e");
//     }
//   }
//
//   Future<void> deleteMedicine(dynamic id) async {
//     try {
//       await supabase.from('medicines').delete().eq('id', id);
//       await getMedicines();
//       await getCompletedMedicines();
//     } catch (e) {
//       debugPrint("Error deleting medicine: $e");
//     }
//   }
//
//   void showDeleteDialog(dynamic id) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         final cs = Theme.of(context).colorScheme;
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: const Text("Delete Medicine"),
//           content: const Text("Are you sure you want to delete this medicine?"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: cs.error,
//                 foregroundColor: cs.onError,
//               ),
//               onPressed: () async {
//                 Navigator.pop(context);
//                 await deleteMedicine(id);
//               },
//               child: const Text(
//                 "Delete",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final cs = Theme.of(context).colorScheme;
//     final double progress = medicines.isEmpty
//         ? 0
//         : completed / medicines.length;
//
//     return Scaffold(
//       backgroundColor: cs.surface,
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: cs.primary,
//         foregroundColor: cs.onPrimary,
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (context) {
//               final cs = Theme.of(context).colorScheme;
//               return AlertDialog(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 backgroundColor: cs.surfaceContainer,
//                 title: Text(
//                   "Add Medicine",
//                   style: TextStyle(color: cs.onSurface),
//                 ),
//                 content: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       TextField(
//                         controller: medicineNameController,
//                         style: TextStyle(color: cs.onSurface),
//                         decoration: InputDecoration(
//                           hintText: "Medicine Name",
//                           hintStyle: TextStyle(color: cs.onSurfaceVariant),
//                           filled: true,
//                           fillColor: cs.surfaceContainerHighest,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       TextField(
//                         controller: dosageController,
//                         style: TextStyle(color: cs.onSurface),
//                         decoration: InputDecoration(
//                           hintText: "Dosage",
//                           hintStyle: TextStyle(color: cs.onSurfaceVariant),
//                           filled: true,
//                           fillColor: cs.surfaceContainerHighest,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       TextField(
//                         controller: frequencyController,
//                         style: TextStyle(color: cs.onSurface),
//                         decoration: InputDecoration(
//                           hintText: "Frequency",
//                           hintStyle: TextStyle(color: cs.onSurfaceVariant),
//                           filled: true,
//                           fillColor: cs.surfaceContainerHighest,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () async => await addMedicine(),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: cs.primary,
//                             foregroundColor: cs.onPrimary,
//                             padding: const EdgeInsets.all(15),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                           ),
//                           child: const Text(
//                             "Add",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             /// HEADER
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               child: Row(
//                 children: [
//                   InkWell(
//                     onTap: () => Navigator.pop(context),
//                     child: Padding(
//                       padding: const EdgeInsets.all(6),
//                       child: Icon(
//                         Icons.arrow_back_ios_new,
//                         size: 20,
//                         color: cs.primary,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     "My Medicines",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: cs.primary,
//                     ),
//                   ),
//                   const Spacer(),
//                   Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: cs.primaryContainer,
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: Icon(Icons.medication, color: cs.primary, size: 24),
//                   ),
//                 ],
//               ),
//             ),
//
//             /// PROGRESS CARD
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                   color: cs.primaryContainer,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       "$completed/${medicines.length} medicines completed",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         color: cs.onPrimaryContainer,
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     LinearProgressIndicator(
//                       value: progress.isNaN || progress.isInfinite
//                           ? 0
//                           : progress,
//                       minHeight: 10,
//                       borderRadius: BorderRadius.circular(20),
//                       backgroundColor: cs.onPrimaryContainer.withOpacity(0.15),
//                       valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       "You completed ${(progress.isNaN || progress.isInfinite ? 0 : progress * 100).toInt()}% today",
//                       style: TextStyle(
//                         color: cs.onPrimaryContainer.withOpacity(0.8),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             /// LIST
//             Expanded(
//               child: medicines.isEmpty
//                   ? const Center(child: Text("No medicines added yet."))
//                   : ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 itemCount: medicines.length,
//                 itemBuilder: (context, index) {
//                   final med = medicines[index];
//                   final bool isTaken = takenToday.contains(med['id']);
//
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 15),
//                     decoration: BoxDecoration(
//                       color: cs.surfaceContainer,
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: cs.outlineVariant),
//                       boxShadow: [
//                         BoxShadow(
//                           color: cs.shadow.withOpacity(0.05),
//                           blurRadius: 10,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(15),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             med['medicine_name'] ?? 'Unknown',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: cs.onSurface,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             "Dosage: ${med['dosage'] ?? ''}",
//                             style: TextStyle(color: cs.onSurfaceVariant),
//                           ),
//                           Text(
//                             "Frequency: ${med['frequency'] ?? ''}",
//                             style: TextStyle(color: cs.onSurfaceVariant),
//                           ),
//                           const SizedBox(height: 15),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton.icon(
//                               onPressed: isTaken
//                                   ? null
//                                   : () async =>
//                               await markAsTaken(med['id']),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: isTaken
//                                     ? Colors.green
//                                     : cs.primary,
//                                 disabledBackgroundColor: Colors.green,
//                                 foregroundColor: Colors.white,
//                                 disabledForegroundColor: Colors.white,
//                                 padding: const EdgeInsets.all(15),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                               ),
//                               icon: Icon(
//                                 isTaken
//                                     ? Icons.check_circle
//                                     : Icons.check,
//                                 color: Colors.white,
//                               ),
//                               label: Text(
//                                 isTaken ? "Taken" : "Mark as Taken",
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton.icon(
//                               onPressed: () =>
//                                   showDeleteDialog(med['id']),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: cs.errorContainer,
//                                 foregroundColor: cs.onErrorContainer,
//                                 padding: const EdgeInsets.all(15),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                               ),
//                               icon: const Icon(Icons.delete),
//                               label: const Text(
//                                 "Delete",
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
