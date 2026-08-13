import 'package:flutter/material.dart';
import 'package:salamty/features/profile/presentation/setting_screen.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          /// BACK
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: cs.onSurface,
              ),
            ),
          ),

          /// TITLE
          Expanded(
            child: Center(
              child: Text(
                "Profile",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
          ),

          /// SETTINGS
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(Icons.settings, size: 22, color: cs.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
