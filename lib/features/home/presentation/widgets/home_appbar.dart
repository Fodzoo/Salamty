import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme_provider/theme_provider.dart';

final supabase = Supabase.instance.client;

class HomeAppbar extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeAppbar({super.key, required this.scaffoldKey});

  @override
  State<HomeAppbar> createState() => _HomeAppbarState();
}

class _HomeAppbarState extends State<HomeAppbar> {
  String getGreeting(bool isArabic, String firstName) {
    final hour = DateTime.now().hour;

    if (isArabic) {
      if (hour < 12) return "صباح الخير،\n$firstName";
      if (hour < 18) return "مساء الخير،\n$firstName";
      return "مساء الخير،\n$firstName";
    } else {
      if (hour < 12) return "Good Morning,\n$firstName";
      if (hour < 18) return "Good Afternoon,\n$firstName";
      return "Good Evening,\n$firstName";
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final firstName = user?.userMetadata?['first_name'] ?? 'User';

    final isArabic =
        context.watch<ThemeProvider>().locale.languageCode == 'ar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                widget.scaffoldKey.currentState!.openDrawer();
              },
            ),
            Text(
              isArabic?"سلامتي":"Salamty",
              style: TextStyle(
                color: const Color(0xFF0059BB),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
          ],
        ),

        const SizedBox(height: 30),

        Text(
          isArabic
              ? "ملاذك الصحي"
              : "YOUR WELLNESS SANCTUARY",
          style: TextStyle(
            fontSize: 12,
            color: Colors.teal,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          getGreeting(isArabic, firstName),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}