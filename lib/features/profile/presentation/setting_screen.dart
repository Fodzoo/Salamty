import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:salamty/features/profile/presentation/change_password_screen.dart';
import 'package:salamty/features/profile/presentation/edit_profile_screen.dart';
import 'package:salamty/features/profile/presentation/language_screen.dart';
import 'package:salamty/features/profile/presentation/privacy_policy_screen.dart';
import 'package:salamty/features/profile/presentation/terms_of_service_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final themeProvider = context.watch<ThemeProvider>();
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    void goToEditProfile() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
      );
    }

    void goToChangePassword() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
      );
    }

    void goToChangeLanguage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LanguageScreen()),
      );
    }

    void goToPrivacyPolicy() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
      );
    }

    void goToTermsOfService() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TermsOfServiceScreen()),
      );
    }

    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        children: [
          const SizedBox(height: 24),

          /// HEADER
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, color: cs.onSurface),
                ),
                const SizedBox(width: 12),
                Text(
                  isArabic ? "الإعدادات" : "Settings",
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// SECTION LABEL
                    Text(
                      isArabic ? "المظهر" : "Appearance",
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// DARK MODE TOGGLE
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            themeProvider.isDark
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            color: cs.primary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              isArabic ? "الوضع الداكن" : "Dark Mode",
                              style: TextStyle(
                                fontSize: 15,
                                color: cs.onSurface,
                              ),
                            ),
                          ),
                          Switch(
                            value: themeProvider.isDark,
                            onChanged: (_) => themeProvider.themeOnChanged(),
                            activeColor: cs.primary,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// SECTION LABEL
                    Text(
                      isArabic ? "الحساب" : "Account",
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _buildItem(
                      cs: cs,
                      icon: Icons.person_outline,
                      title: isArabic ? "تعديل الملف الشخصي" : "Edit Profile",
                      onTap: goToEditProfile,
                    ),

                    _buildItem(
                      cs: cs,
                      icon: Icons.lock_outline,
                      title: isArabic ? "تغيير كلمة المرور" : "Change Password",
                      onTap: goToChangePassword,
                    ),

                    const SizedBox(height: 24),

                    /// SECTION LABEL
                    Text(
                      isArabic ? "عام" : "General",
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    _buildItem(
                      cs: cs,
                      icon: Icons.language,
                      title: isArabic ? "اللغة" : "Languages",
                      onTap: goToChangeLanguage,
                    ),

                    _buildItem(
                      cs: cs,
                      icon: Icons.privacy_tip_outlined,
                      title: isArabic ? "سياسة الخصوصية" : "Privacy Policy",
                      onTap:goToPrivacyPolicy,
                    ),

                    _buildItem(
                      cs: cs,
                      icon: Icons.description_outlined,
                      title: isArabic ? "شروط الاستخدام" : "Terms of Service",
                      onTap:goToTermsOfService,
                      showDivider: false,
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

  Widget _buildItem({
    required ColorScheme cs,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: cs.onSurfaceVariant),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 15, color: cs.onSurface),
                  ),
                ),
                Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
              ],
            ),
          ),
        ),
        if (showDivider) Divider(color: cs.outlineVariant, height: 1),
      ],
    );
  }
}
