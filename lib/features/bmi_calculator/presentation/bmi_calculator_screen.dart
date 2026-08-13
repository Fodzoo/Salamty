import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:salamty/features/bmi_calculator/presentation/ResultScreen.dart';
import 'package:salamty/features/bmi_calculator/presentation/widgets/bmi_calc_appbar.dart';

class BMICalculatorScreen extends StatefulWidget {
  const BMICalculatorScreen({super.key});

  @override
  State<BMICalculatorScreen> createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen> {
  int? selectedIndex;
  double heightValue = 170;
  int weight = 65;
  int age = 20;

  void goToResult(bool isArabic) {
    if (selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? "من فضلك اختر الجنس أولاً"
                : "Please select your gender first",
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          bmi: weight / ((heightValue / 100) * (heightValue / 100)),
          gender: selectedIndex == 0
              ? (isArabic ? "ذكر" : "Male")
              : (isArabic ? "أنثى" : "Female"),
          age: age,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              /// APPBAR
              const BMICalcAppbar(),

              const SizedBox(height: 25),

              /// GENDER
              Row(
                children: [
                  /// MALE
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedIndex = 0),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: selectedIndex == 0
                              ? cs.primary
                              : cs.surfaceContainer,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selectedIndex == 0
                                ? cs.primary
                                : cs.outlineVariant,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: cs.shadow.withOpacity(0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.male,
                              size: 55,
                              color: selectedIndex == 0
                                  ? cs.onPrimary
                                  : cs.primary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isArabic ? "ذكر" : "MALE",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: selectedIndex == 0
                                    ? cs.onPrimary
                                    : cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// FEMALE
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selectedIndex = 1),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: selectedIndex == 1
                              ? cs.tertiary
                              : cs.surfaceContainer,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selectedIndex == 1
                                ? cs.tertiary
                                : cs.outlineVariant,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: cs.shadow.withOpacity(0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.female,
                              size: 55,
                              color: selectedIndex == 1
                                  ? cs.onTertiary
                                  : cs.tertiary,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isArabic ? "أنثى" : "FEMALE",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: selectedIndex == 1
                                    ? cs.onTertiary
                                    : cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// HEIGHT
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cs.surfaceContainer,
                  borderRadius: BorderRadius.circular(22),
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
                  children: [
                    Text(
                      isArabic ? "الطول" : "HEIGHT",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${heightValue.toInt()} ${isArabic ? 'سم' : 'cm'}",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                    Slider(
                      value: heightValue,
                      min: 100,
                      max: 220,
                      activeColor: cs.primary,
                      inactiveColor: cs.outlineVariant,
                      onChanged: (v) => setState(() => heightValue = v),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// WEIGHT + AGE
              Row(
                children: [
                  /// WEIGHT
                  Expanded(
                    child: Container(
                      height: 160,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainer,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: cs.outlineVariant),
                        boxShadow: [
                          BoxShadow(
                            color: cs.shadow.withOpacity(0.06),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isArabic ? "الوزن" : "WEIGHT",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                          ),
                          Text(
                            "$weight ${isArabic ? 'كجم' : 'kg'}",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () => setState(() {
                                  if (weight > 1) weight--;
                                }),
                                icon: Icon(
                                  Icons.remove_circle,
                                  size: 30,
                                  color: cs.primary,
                                ),
                              ),
                              IconButton(
                                onPressed: () => setState(() => weight++),
                                icon: Icon(
                                  Icons.add_circle,
                                  size: 30,
                                  color: cs.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// AGE
                  Expanded(
                    child: Container(
                      height: 160,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainer,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: cs.outlineVariant),
                        boxShadow: [
                          BoxShadow(
                            color: cs.shadow.withOpacity(0.06),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isArabic ? "العمر" : "AGE",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                          ),
                          Text(
                            "$age",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: cs.tertiary,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () => setState(() {
                                  if (age > 1) age--;
                                }),
                                icon: Icon(
                                  Icons.remove_circle,
                                  size: 30,
                                  color: cs.tertiary,
                                ),
                              ),
                              IconButton(
                                onPressed: () => setState(() => age++),
                                icon: Icon(
                                  Icons.add_circle,
                                  size: 30,
                                  color: cs.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// CALCULATE BUTTON
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => goToResult(isArabic),
                  child: Text(
                    isArabic ? "احسب" : "CALCULATE",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
