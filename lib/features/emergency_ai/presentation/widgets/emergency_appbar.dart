import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';

class EmergencyAppbar extends StatelessWidget {
  const EmergencyAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isArabic = context.watch<ThemeProvider>().locale.languageCode == 'ar';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(Icons.arrow_back_ios_new, size: 20, color: cs.primary),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isArabic ? "مساعدة الطوارئ" : "Emergency Assistance",
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
              color: cs.errorContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.emergency, color: cs.error, size: 24),
          ),
        ],
      ),
    );
  }
}