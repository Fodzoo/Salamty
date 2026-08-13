import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final supabase = Supabase.instance.client;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final diseasesController = TextEditingController();
  final allergiesController = TextEditingController();

  String? gender;
  String? bloodType;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  void _loadCurrentData() {
    final data = supabase.auth.currentUser?.userMetadata;
    if (data == null) return;

    firstNameController.text = data['first_name'] ?? '';
    lastNameController.text = data['last_name'] ?? '';
    phoneController.text = data['phone'] ?? '';
    dobController.text = data['date_of_birth'] ?? '';
    heightController.text = data['height']?.toString() ?? '';
    weightController.text = data['weight']?.toString() ?? '';
    diseasesController.text = data['chronic_diseases'] ?? '';
    allergiesController.text = data['allergies'] ?? '';
    gender = data['gender'];
    bloodType = data['blood_type'];
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    dobController.dispose();
    heightController.dispose();
    weightController.dispose();
    diseasesController.dispose();
    allergiesController.dispose();
    super.dispose();
  }

  Future<void> saveChanges() async {
    setState(() => isLoading = true);

    try {
      await supabase.auth.updateUser(
        UserAttributes(
          data: {
            'first_name': firstNameController.text.trim(),
            'last_name': lastNameController.text.trim(),
            'phone': phoneController.text.trim(),
            'date_of_birth': dobController.text.trim(),
            'gender': gender,
            'height': int.tryParse(heightController.text),
            'weight': int.tryParse(weightController.text),
            'chronic_diseases': diseasesController.text.trim(),
            'allergies': allergiesController.text.trim(),
            'blood_type': bloodType,
          },
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Profile updated successfully"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
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

  Widget _sectionLabel(String text, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          color: cs.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';
    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        children: [
          const SizedBox(height: 24),

          /// HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, color: cs.onSurface),
                ),
                const SizedBox(width: 12),
                Text(
                  isArabic ? "تعديل الملف الشخصي" : "Edit Profile",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// PERSONAL INFO
                  _sectionLabel(
                    isArabic ? "المعلومات الشخصية" : "Personal Information",
                    cs,
                  ),

                  _label(isArabic ? "الاسم الأول" : "First Name", cs),
                  const SizedBox(height: 6),
                  TextField(
                    controller: firstNameController,
                    style: TextStyle(color: cs.onSurface),
                    decoration: _inputDecoration(
                      cs,
                      icon: Icons.person_outline,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _label(isArabic ? "اسم العائلة" : "Last Name", cs),
                  const SizedBox(height: 6),
                  TextField(
                    controller: lastNameController,
                    style: TextStyle(color: cs.onSurface),
                    decoration: _inputDecoration(
                      cs,
                      icon: Icons.person_outline,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _label(isArabic ? "النوع" : "Gender", cs),
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
                        isArabic ? "اختر النوع" : "Select Gender",
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

                  _label(isArabic ? "تاريخ الميلاد" : "Date of Birth", cs),
                  const SizedBox(height: 6),
                  TextField(
                    controller: dobController,
                    readOnly: true,
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
                    decoration: _inputDecoration(
                      cs,
                      hint: isArabic?"ي ي/ش ش/ع ع ع ع":"DD/MM/YYYY",
                      icon: Icons.calendar_month_outlined,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _label(isArabic ? "رقم الهاتف" : "Phone Number", cs),
                  const SizedBox(height: 6),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: cs.onSurface),
                    decoration: _inputDecoration(cs, icon: Icons.call_outlined),
                  ),

                  const SizedBox(height: 24),

                  /// HEALTH INFO
                  _sectionLabel(isArabic ? "المعلومات الصحية" : "Health Information", cs),

                  /// HEIGHT + WEIGHT
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label(isArabic ? "الطول (سم)" : "Height (cm)", cs),
                            const SizedBox(height: 6),
                            TextField(
                              controller: heightController,
                              keyboardType: TextInputType.number,
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
                            _label(isArabic ? "الوزن (كجم)" : "Weight (kg)", cs),
                            const SizedBox(height: 6),
                            TextField(
                              controller: weightController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: cs.onSurface),
                              decoration: _inputDecoration(cs),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

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
                      items: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
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
                      onChanged: (value) => setState(() => bloodType = value),
                    ),
                  ),

                  const SizedBox(height: 16),

                  _label(isArabic ? "الأمراض المزمنة" : "Chronic Diseases", cs),
                  const SizedBox(height: 6),
                  TextField(
                    controller: diseasesController,
                    style: TextStyle(color: cs.onSurface),
                    decoration: _inputDecoration(
                      cs,
                      icon: Icons.local_hospital_outlined,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _label(isArabic ? "الحساسية" : "Allergies", cs),
                  const SizedBox(height: 6),
                  TextField(
                    controller: allergiesController,
                    style: TextStyle(color: cs.onSurface),
                    decoration: _inputDecoration(
                      cs,
                      icon: Icons.warning_amber_outlined,
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// SAVE BUTTON
                  SizedBox(
                    height: 52,
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
                            onPressed: saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: cs.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              isArabic ? "حفظ التعديلات" : "Save Changes",

                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
