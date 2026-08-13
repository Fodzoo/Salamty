import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:salamty/features/home/presentation/widgets/home_drawer_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
    required this.goToProfile,
    required this.goToSettings,
    required this.goToLogin,
    required this.goToLap,
    required this.goToRadiology,
  });

  final VoidCallback goToLap;
  final VoidCallback goToRadiology;
  final VoidCallback goToProfile;
  final VoidCallback goToSettings;
  final VoidCallback goToLogin;

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final data = user?.userMetadata;
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    return Container(
      color: cs.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF0059BB),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  '${data?['first_name'] ?? 'User'} 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  isArabic ? "مرحباً بعودتك" : "Welcome back",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          /// DRAWER ITEMS
          HomeDrawerItem(
            context: context,
            icon: Icons.science,
            label: isArabic ? "سجل التحاليل" : "Lap History",
            onTap: goToLap,
          ),
          HomeDrawerItem(
            context: context,
            icon: Icons.document_scanner,
            label: isArabic ? "سجل الأشعة" : "Radiology History",
            onTap: goToRadiology,
          ),
          HomeDrawerItem(
            context: context,
            icon: Icons.person,
            label: isArabic ? "الملف الشخصي" : "Profile",
            onTap: goToProfile,
          ),
          HomeDrawerItem(
            context: context,
            icon: Icons.settings,
            label: isArabic ? "الإعدادات" : "Settings",
            onTap: goToSettings,
          ),

          const Spacer(),

          /// LOGOUT
          GestureDetector(
            onTap: goToLogin,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      isArabic ? "تسجيل الخروج" : "Logout",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
