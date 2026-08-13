import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = Supabase.instance.client.auth.currentUser;
    final data = user?.userMetadata;

    return Column(
      children: [
        /// AVATAR
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cs.primaryContainer,
            boxShadow: [
              BoxShadow(
                color: cs.primary.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(Icons.person, size: 55, color: cs.primary),
        ),

        const SizedBox(height: 14),

        /// NAME
        Text(
          "${data?['first_name'] ?? ''} ${data?['last_name'] ?? ''}".trim().isEmpty
              ? "N/A"
              : "${data?['first_name'] ?? ''} ${data?['last_name'] ?? ''}".trim(),
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 6),

        /// EMAIL
        Text(
          user?.email ?? "N/A",
          style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
        ),

        const SizedBox(height: 20),

        /// DIVIDER
        Divider(color: cs.outlineVariant, thickness: 1),
      ],
    );
  }
}
