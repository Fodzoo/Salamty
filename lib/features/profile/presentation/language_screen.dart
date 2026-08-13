import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final provider = context.watch<ThemeProvider>();
    final isAr = provider.locale.languageCode == 'ar';

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
                  isAr ? "اللغة" : "Language",
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  /// INFO
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.language, color: cs.primary),
                        const SizedBox(width: 12),
                        Text(
                          isAr ? "اختر لغة التطبيق" : "Choose app language",
                          style: TextStyle(
                            color: cs.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ENGLISH OPTION
                  GestureDetector(
                    onTap: () =>
                        context.read<ThemeProvider>().changeLocale('en'),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: !isAr ? cs.primary : cs.surfaceContainer,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: !isAr ? cs.primary : cs.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "🇺🇸",
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "English",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !isAr ? cs.onPrimary : cs.onSurface,
                                  ),
                                ),
                                Text(
                                  "English Language",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: !isAr
                                        ? cs.onPrimary.withOpacity(0.8)
                                        : cs.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isAr)
                            Icon(Icons.check_circle, color: cs.onPrimary),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// ARABIC OPTION
                  GestureDetector(
                    onTap: () =>
                        context.read<ThemeProvider>().changeLocale('ar'),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isAr ? cs.primary : cs.surfaceContainer,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isAr ? cs.primary : cs.outlineVariant,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "🇪🇬",
                            style: const TextStyle(fontSize: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "العربية",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isAr ? cs.onPrimary : cs.onSurface,
                                  ),
                                ),
                                Text(
                                  "اللغة العربية",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isAr
                                        ? cs.onPrimary.withOpacity(0.8)
                                        : cs.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isAr)
                            Icon(Icons.check_circle, color: cs.onPrimary),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}