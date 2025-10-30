import 'package:flutter/material.dart';
import 'dart:math';
import '../services/firestore_service.dart';
import '../services/language_service.dart';
import '../services/settings_service.dart';
import 'group_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _groupCodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  late SettingsService _settingsService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _settingsService = SettingsService();
  }

  // Generate random 6-digit code
  String _generateCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Create new group
  Future<void> _createGroup() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LanguageService.t('enter_name_error'))),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String code = _generateCode();
      
      // Check if code already exists (rare but possible)
      while (await _firestoreService.groupExists(code)) {
        code = _generateCode();
      }

      await _firestoreService.createGroup(code, [_nameController.text.trim()]);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GroupScreen(
              groupCode: code,
              userName: _nameController.text.trim(),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Join existing group
  Future<void> _joinGroup() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    if (_groupCodeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter group code')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String code = _groupCodeController.text.trim().toUpperCase();
      
      bool exists = await _firestoreService.groupExists(code);
      
      if (!exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Group not found')),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      // Add member to group
      await _firestoreService.addMember(code, _nameController.text.trim());

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GroupScreen(
              groupCode: code,
              userName: _nameController.text.trim(),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settingsService,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(LanguageService.t('app_name')),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                },
              ),
            ],
          ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9333EA), // Purple
              Color(0xFFEC4899), // Pink
              Color(0xFFFB923C), // Orange
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.currency_rupee_rounded,
                      size: 50,
                      color: Color(0xFF9333EA),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    LanguageService.t('app_name'),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    LanguageService.t('split_expenses'),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Card
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Name Input
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: LanguageService.t('your_name'),
                            hintText: LanguageService.t('enter_name'),
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 16),

                        // Group Code Input
                        TextField(
                          controller: _groupCodeController,
                          decoration: InputDecoration(
                            labelText: LanguageService.t('group_code'),
                            hintText: LanguageService.t('enter_code'),
                            prefixIcon: const Icon(Icons.tag),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          textCapitalization: TextCapitalization.characters,
                          maxLength: 6,
                        ),
                        const SizedBox(height: 24),

                        // Create Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _createGroup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9333EA),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.add_circle_outline),
                                    const SizedBox(width: 8),
                                    Text(
                                      LanguageService.t('create_group'),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 12),

                        // Join Button
                        OutlinedButton(
                          onPressed: _isLoading ? null : _joinGroup,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF9333EA),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(
                              color: Color(0xFF9333EA),
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.group_add_outlined),
                              const SizedBox(width: 8),
                              Text(
                                LanguageService.t('join_group'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Footer
                  Text(
                    LanguageService.t('no_login'),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
        );
      },
    );
  }

  @override
  void dispose() {
    _groupCodeController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}