import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../../../../core/theme_provider/theme_provider.dart';

class DailyMedicalTip extends StatelessWidget {
  const DailyMedicalTip({super.key});

  static final List<Map<String, String>> englishTips = [
    {
      "title": "The Power of Breathing",
      "text":
          "Taking just 5 minutes of deep, controlled breathing each day can significantly lower cortisol levels, reduce anxiety symptoms, and improve overall heart rate variability, which supports long-term cardiovascular health.",
      "image": "assets/images/breathing.png",
    },
    {
      "title": "Hydration and Brain Performance",
      "text":
          "Even mild dehydration of 1–2% of body weight can negatively affect concentration, short-term memory, and mood, while maintaining proper hydration helps optimize brain function and mental clarity throughout the day.",
      "image": "assets/images/hydration.jpg",
    },
    {
      "title": "Sleep and Immune Function",
      "text":
          "Consistently sleeping between 7 to 9 hours per night strengthens the immune system, enhances cognitive performance, and helps regulate hormones responsible for stress, appetite, and recovery.",
      "image": "assets/images/sleep.jpg",
    },
    {
      "title": "Daily Walking Benefits",
      "text":
          "Walking for at least 20–30 minutes daily has been shown to reduce the risk of cardiovascular diseases, improve insulin sensitivity, and release endorphins that naturally boost mood and energy levels.",
      "image": "assets/images/walking.png",
    },
    {
      "title": "Reducing Sugar Intake",
      "text":
          "Lowering added sugar consumption can significantly reduce the risk of type 2 diabetes, obesity, and chronic inflammation, while also stabilizing energy levels and preventing sudden fatigue crashes.",
      "image": "assets/images/sugar.jpg",
    },
  ];

  static final List<Map<String, String>> arabicTips = [
    {
      "title": "قوة التنفس العميق",
      "text":
          "ممارسة التنفس العميق المتحكم فيه لمدة 5 دقائق يومياً يمكن أن تخفض مستويات الكورتيزول بشكل ملحوظ، وتقلل أعراض القلق، وتحسن معدل ضربات القلب، مما يدعم صحة القلب على المدى البعيد.",
      "image": "assets/images/breathing.png",
    },
    {
      "title": "الترطيب وأداء الدماغ",
      "text":
          "حتى الجفاف الخفيف بنسبة 1-2٪ من وزن الجسم يمكن أن يؤثر سلباً على التركيز والذاكرة قصيرة المدى والمزاج، بينما يساعد الحفاظ على الترطيب المناسب في تحسين وظائف المخ والوضوح الذهني طوال اليوم.",
      "image": "assets/images/hydration.jpg",
    },
    {
      "title": "النوم ووظيفة المناعة",
      "text":
          "النوم بانتظام من 7 إلى 9 ساعات يومياً يقوي جهاز المناعة ويعزز الأداء المعرفي ويساعد في تنظيم الهرمونات المسؤولة عن التوتر والشهية والتعافي.",
      "image": "assets/images/sleep.jpg",
    },
    {
      "title": "فوائد المشي اليومي",
      "text":
          "المشي لمدة 20-30 دقيقة يومياً على الأقل يقلل من خطر الإصابة بأمراض القلب والأوعية الدموية ويحسن حساسية الأنسولين ويطلق الإندورفين الذي يرفع المزاج ومستويات الطاقة بشكل طبيعي.",
      "image": "assets/images/walking.png",
    },
    {
      "title": "تقليل استهلاك السكر",
      "text":
          "تقليل استهلاك السكر المضاف يمكن أن يقلل بشكل كبير من خطر الإصابة بالسكري من النوع الثاني والسمنة والالتهابات المزمنة، مع تثبيت مستويات الطاقة ومنع انهيارات التعب المفاجئة.",
      "image": "assets/images/sugar.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    final tips = isArabic ? arabicTips : englishTips;
    final tip = tips[Random(DateTime.now().day).nextInt(tips.length)];

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              tip["image"]!,
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? "نصيحة طبية يومية" : "DAILY MEDICAL TIP",
                    style: TextStyle(
                      color: cs.primary,
                      fontSize: 11,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    tip["title"]!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: cs.onSurface,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    tip["text"]!,
                    style: TextStyle(
                      fontSize: 13,
                      color: cs.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
