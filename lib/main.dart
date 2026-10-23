import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_project5/config.dart';
import 'package:travel_project5/ui/style.dart';

import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kOfflineDemo) {
    await dotenv.load();
    await Supabase.initialize(
      url: dotenv.get('supabase-url'),
      publishableKey: dotenv.get('supabase-key'),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Saudi Escape',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: AppFonts.body,
        scaffoldBackgroundColor: AppColors.ground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.ground,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
