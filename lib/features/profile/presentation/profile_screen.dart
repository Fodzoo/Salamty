import 'package:flutter/material.dart';
import 'package:salamty/features/profile/presentation/widgets/profile_app_bar.dart';
import 'package:salamty/features/profile/presentation/widgets/profile_header.dart';
import 'package:salamty/features/profile/presentation/widgets/profile_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final user = Supabase.instance.client.auth.currentUser;
    final data = user?.userMetadata;

    return Scaffold(
      backgroundColor: cs.surface,
      body: Column(
        children: [
          const SizedBox(height: 24),

          /// TOP BAR
          const ProfileAppBar(),

          /// CONTENT
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const ProfileHeader(),

                    const SizedBox(height: 25),

                    /// ACCOUNT INFO
                    Text(
                      "Account Information",
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ProfileItem(
                      icon: Icons.person_outline,
                      title: "First Name",
                      value: data?['first_name'] ?? "N/A",
                    ),
                    ProfileItem(
                      icon: Icons.person_outline,
                      title: "Last Name",
                      value: data?['last_name'] ?? "N/A",
                    ),
                    ProfileItem(
                      icon: Icons.male_outlined,
                      title: "Gender",
                      value: data?['gender'] ?? "N/A",
                    ),
                    ProfileItem(
                      icon: Icons.email_outlined,
                      title: "Email",
                      value: user?.email ?? "N/A",
                    ),
                    ProfileItem(
                      icon: Icons.call_outlined,
                      title: "Phone Number",
                      value: data?['phone'] ?? "N/A",
                    ),
                    ProfileItem(
                      icon: Icons.calendar_month_outlined,
                      title: "Date of Birth",
                      value: data?['date_of_birth'] ?? "N/A",
                    ),

                    const SizedBox(height: 20),

                    /// HEALTH INFO
                    Text(
                      "Health Information",
                      style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ProfileItem(
                      icon: Icons.height,
                      title: "Height",
                      value: data?['height']?.toString() ?? "N/A",
                    ),
                    ProfileItem(
                      icon: Icons.monitor_weight_outlined,
                      title: "Weight",
                      value: data?['weight']?.toString() ?? "N/A",
                    ),
                    ProfileItem(
                      icon: Icons.bloodtype_outlined,
                      title: "Blood Type",
                      value: data?['blood_type'] ?? "N/A",
                    ),
                    ProfileItem(
                      icon: Icons.local_hospital_outlined,
                      title: "Chronic Diseases",
                      value: data?['chronic_diseases'] ?? "N/A",
                    ),
                    ProfileItem(
                      icon: Icons.warning_amber_outlined,
                      title: "Allergies",
                      value: data?['allergies'] ?? "N/A",
                    ),

                    const SizedBox(height: 10),
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