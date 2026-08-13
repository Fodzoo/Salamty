import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:salamty/features/ai_health_chat/presentation/ai_chat_health_screen.dart';
import 'package:salamty/features/bmi_calculator/presentation/bmi_calculator_screen.dart';
import 'package:salamty/features/drug_interactions/presentation/drug_interactions_screen.dart';
import 'package:salamty/features/emergency_ai/presentation/emergency_ai_screen.dart';
import 'package:salamty/features/find_care/presentation/find_care_screen.dart';
import 'package:salamty/features/home/presentation/home_drawer.dart';
import 'package:salamty/features/home/presentation/widgets/daily_medical_tip.dart';
import 'package:salamty/features/home/presentation/widgets/home_appbar.dart';
import 'package:salamty/features/home/presentation/widgets/home_feature_item.dart';
import 'package:salamty/features/lab_tests/presentation/lab_history_screen.dart';
import 'package:salamty/features/lab_tests/presentation/lab_tests_screen.dart';
import 'package:salamty/features/login/presentation/login_screen.dart';
import 'package:salamty/features/medicines/presentation/medicines_screen.dart';
import 'package:salamty/features/profile/presentation/profile_screen.dart';
import 'package:salamty/features/profile/presentation/setting_screen.dart';
import 'package:salamty/features/radiology_assistant/presentation/radiology_assistant_screen.dart';
import 'package:salamty/features/radiology_assistant/presentation/radiology_history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool aiPressed = false;


  void goToAiHealthChat() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AiChatHealthScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
  void goToEmergencyAi() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EmergencyScreen()),
    );
  }
  void goToRadiology() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RadiologyAssistantScreen()),
    );
  }
  void goToMedicines() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MedicinesScreen()),
    );
  }
  void goToBmiCalculator() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BMICalculatorScreen()),
    );
  }
  void goToFindCare() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FindCareScreen()),
    );
  }
  void goToLabTests() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LabTestsScreen()),
    );
  }
  void goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }
  void goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
  void goToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingScreen()),
    );
  }
  void goToDrugInteractions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DrugInteractionsScreen()),
    );
  }
  void goToLapHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LabHistoryScreen()),
    );
  }
  void goToRadiologyHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RadiologyHistoryScreen()),
    );
  }

  @override

  Widget build(BuildContext context) {

    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';
    return Scaffold(
      key: _scaffoldKey,

      drawer: Drawer(
        child: HomeDrawer(
          goToLap: goToLapHistory,
          goToRadiology: goToRadiologyHistory,
          goToProfile: goToProfile,
          goToSettings: goToSettings,
          goToLogin: goToLogin,
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP BAR
              HomeAppbar(scaffoldKey: _scaffoldKey),

              const SizedBox(height: 24),

              /// AI Health Chat
              GestureDetector(
                onTap: goToAiHealthChat,
                child: Center(
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 120),
                    scale: aiPressed ? 0.97 : 1,
                    child: Container(
                      // width: 340,
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0059BB),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0059BB).withOpacity(0.4),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.health_and_safety,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(height: 15),
                          Text(
                            isArabic ? "الدردشة الطبية الذكية" : "AI Health Chat",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            isArabic
                                ? "تحليل ذكي للأعراض باستخدام الذكاء الاصطناعي"
                                : "Smart symptom analysis powered by AI.",
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                isArabic
                                    ? "ابدأ الاستشارة"
                                    : "START CONSULTATION",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// Drug Interactions
              HomeFeatureItem(
                context: context,
                onTap: goToDrugInteractions,
                icon: Icons.warning_amber_rounded,
                iconColor: Colors.purple,
                iconBgColor: Colors.purple.withOpacity(0.15),
                title: isArabic
                    ? "تداخلات الأدوية"
                    : "Drug Interactions",

                subtitle: isArabic
                    ? "تحقق من تداخلات الأدوية بأمان"
                    : "Check medicine interactions safely",
              ),

              const SizedBox(height: 18),

              /// Emergency AI
              HomeFeatureItem(
                context: context,
                onTap: goToEmergencyAi,
                icon: Icons.emergency,
                iconColor: Colors.red,
                iconBgColor: Colors.red.withOpacity(0.15),
                title: isArabic
                    ? "طوارئ الذكاء الاصطناعي"
                    : "Emergency Assistance",

                subtitle: isArabic
                    ? "إرشادات فورية للطوارئ بالذكاء الاصطناعي"
                    : "Instant emergency guidance powered by AI",
              ),

              const SizedBox(height: 18),

              /// Medicines
              HomeFeatureItem(
                context: context,
                onTap: goToMedicines,
                icon: Icons.medication,
                iconColor: Colors.blue,
                iconBgColor: Colors.blue.withOpacity(0.15),
                title: isArabic
                    ? "الأدوية"
                    : "Medicines",

                subtitle: isArabic
                    ? "استعرض الأدوية وتعليمات استخدامها"
                    : "Browse medicines and usage details",
              ),

              const SizedBox(height: 18),

              /// BMI Calculator
              HomeFeatureItem(
                context: context,
                onTap: goToBmiCalculator,
                icon: Icons.monitor_weight,
                iconColor: Colors.green,
                iconBgColor: Colors.green.withOpacity(0.15),
                title: isArabic
                    ? "حاسبة مؤشر كتلة الجسم"
                    : "BMI Calculator",

                subtitle: isArabic
                    ? "احسب مؤشر كتلة جسمك فوراً"
                    : "Check your Body Mass Index instantly",
              ),

              const SizedBox(height: 18),

              /// Lab Tests
              HomeFeatureItem(
                context: context,
                onTap: goToLabTests,
                icon: Icons.science,
                iconColor: Colors.cyan,
                iconBgColor: Colors.cyan.withOpacity(0.15),
                title: isArabic
                    ? "التحاليل الطبية"
                    : "Lab Tests & Analysis",

                subtitle: isArabic
                    ? "ارفع نتائج التحاليل واحصل على تحليل فوري"
                    : "Upload and analyze your lab results instantly",
              ),

              const SizedBox(height: 18),

              /// Radiology Assistant
              HomeFeatureItem(
                context: context,
                onTap: goToRadiology,
                icon: Icons.document_scanner,
                iconColor: Colors.cyan,
                iconBgColor: Colors.cyan.withOpacity(0.15),
                title: isArabic
                    ? "مساعد الأشعة"
                    : "Radiology Assistant",

                subtitle: isArabic
                    ? "ارفع صور الأشعة واحصل على تحليل فوري"
                    : "Upload and analyze your radiology images instantly",
              ),

              const SizedBox(height: 18),

              /// Find Care
              HomeFeatureItem(
                context: context,
                onTap: goToFindCare,
                icon: Icons.location_pin,
                iconColor: Colors.red,
                iconBgColor: Colors.red.withOpacity(0.15),
                title: isArabic
                    ? "البحث عن رعاية"
                    : "Find Care",

                subtitle: isArabic
                    ? "اعثر على عيادات ومستشفيات وصيدليات قريبة منك"
                    : "Find nearby clinics, hospitals & pharmacies",
              ),

              const SizedBox(height: 36),

              /// DAILY TIP
              const DailyMedicalTip(),
            ],
          ),
        ),
      ),
    );
  }
}
