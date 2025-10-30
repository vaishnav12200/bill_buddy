import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAi4Uq0OYG6DnFV2ra7Ln8GYJYzNjZugjY",
        authDomain: "billbuddy-90b14.firebaseapp.com",
        projectId: "billbuddy-90b14",
        storageBucket: "billbuddy-90b14.firebasestorage.app",
        messagingSenderId: "809324892509",
        appId: "1:809324892509:web:23d12579e6b8407c4018b4",
      ),
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