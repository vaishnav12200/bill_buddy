import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'services/settings_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase error: $e');
  }

  runApp(const BillBuddyApp());
}

class BillBuddyApp extends StatefulWidget {
  const BillBuddyApp({Key? key}) : super(key: key);

  @override
  State<BillBuddyApp> createState() => _BillBuddyAppState();
}

class _BillBuddyAppState extends State<BillBuddyApp> {
  late SettingsService _settingsService;

  @override
  void initState() {
    super.initState();
    _settingsService = SettingsService();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settingsService,
      builder: (context, child) {
        return MaterialApp(
          title: 'Bill Buddy',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFF9333EA),
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9333EA)),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}