import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:salamty/core/theme/theme.dart';
import 'package:salamty/core/theme_provider/theme_provider.dart';
import 'package:salamty/features/on_boarding/presentation/on_boarding_screen.dart';
import 'package:salamty/features/splash/presentation/splash_screen.dart';
import 'package:salamty/l10n/app_localizations.dart';
import 'package:salamty/supabase_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, notifier, child) {
          return MaterialApp(
            locale: context.watch<ThemeProvider>().locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            supportedLocales: const [Locale('en'), Locale('ar')],

            routes: {"OnBoarding": (context) => const OnboardingScreen()},
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData(
              colorScheme: MaterialTheme.darkScheme(),
              useMaterial3: true,
            ),
            theme: ThemeData(
              colorScheme: MaterialTheme.lightScheme(),
              useMaterial3: true,
            ),
            themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
