import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:salamty/features/bmi_calculator/presentation/widgets/bmi_calc_appbar.dart';

class ResultScreen extends StatelessWidget {
  final double bmi;
  final String gender;
  final int age;

  const ResultScreen({
    super.key,
    required this.bmi,
    required this.gender,
    required this.age,
  });

  String getResultText(bool isArabic) {
    if (bmi >= 30) return isArabic ? "سمنة" : "Obese";
    if (bmi >= 25) return isArabic ? "زيادة وزن" : "Overweight";
    if (bmi >= 18.5) return isArabic ? "طبيعي" : "Normal";
    return isArabic ? "نحافة" : "Underweight";
  }

  Color get resultColor {
    if (bmi >= 30) return const Color(0xFFB71C1C);
    if (bmi >= 25) return const Color(0xFFE53935);
    if (bmi >= 18.5) return const Color(0xFF2E7D32);
    return const Color(0xFFF57F17);
  }

  String getResultDescription(bool isArabic) {
    if (bmi < 18.5) {
      return isArabic
          ? "وزنك أقل من المعدل الطبيعي. حاول تحسين التغذية وممارسة تمارين القوة."
          : "You're below the ideal range. Add balanced nutrition and strength training.";
    }

    if (bmi < 25) {
      return isArabic
          ? "ممتاز! وزنك ضمن المعدل الطبيعي. حافظ على نمط حياتك الحالي."
          : "Perfect range! Keep your lifestyle steady.";
    }

    if (bmi < 30) {
      return isArabic
          ? "وزنك أعلى من المعدل الطبيعي. بعض التغييرات البسيطة قد تحسن صحتك."
          : "Above ideal range. Small consistent changes can improve your health.";
    }

    return isArabic
        ? "مؤشر كتلة الجسم مرتفع. يُفضل استشارة مختص صحي."
        : "High BMI detected. Consider consulting a healthcare professional.";
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const BMICalcAppbar(),

              const SizedBox(height: 25),

              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainer,
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(color: cs.outlineVariant),
                    boxShadow: [
                      BoxShadow(
                        color: cs.shadow.withOpacity(0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            gender == "Male" ? Icons.male : Icons.female,
                            color: gender == "Male" ? cs.primary : cs.tertiary,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isArabic
                                ? "${gender == "Male" ? "ذكر" : "أنثى"} · $age سنة"
                                : "$gender · $age yrs",
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: resultColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          getResultText(isArabic),
                          style: TextStyle(
                            color: resultColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        bmi.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.w900,
                          color: cs.primary,
                        ),
                      ),

                      Text(
                        isArabic ? "مؤشر كتلة الجسم" : "Body Mass Index",
                        style: TextStyle(
                          fontSize: 14,
                          color: cs.onSurfaceVariant,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Stack(
                        children: [
                          Container(
                            height: 14,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: cs.surfaceContainerHighest,
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: (bmi / 40).clamp(0.05, 1.0),
                            child: Container(
                              height: 14,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: resultColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isArabic ? "نحافة" : "Under",
                            style: TextStyle(
                              fontSize: 10,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            isArabic ? "طبيعي" : "Normal",
                            style: TextStyle(
                              fontSize: 10,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            isArabic ? "زيادة وزن" : "Over",
                            style: TextStyle(
                              fontSize: 10,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            isArabic ? "سمنة" : "Obese",
                            style: TextStyle(
                              fontSize: 10,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      Text(
                        getResultDescription(isArabic),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    isArabic ? "إعادة الحساب" : "RE-CALCULATE",
                    style: const TextStyle(
                      fontSize: 17,
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
