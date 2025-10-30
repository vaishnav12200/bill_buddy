import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
        return Scaffold(
          appBar: AppBar(
            title: Text(LanguageService.t('settings')),
            backgroundColor: const Color(0xFF9333EA),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF9333EA),
                  Color(0xFFEC4899),
                  Color(0xFFFB923C),
                ],
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Language Setting
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.language,
                      color: Color(0xFF9333EA),
                      size: 28,
                    ),
                    title: Text(
                      LanguageService.t('language'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      _getCurrentLanguageName(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: _showLanguageDialog,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Total Amount Spent
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.account_balance_wallet,
                      color: Color(0xFF9333EA),
                      size: 28,
                    ),
                    title: Text(
                      LanguageService.t('total_spent'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '₹${_settingsService.totalAmountSpent.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9333EA),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // App Info
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.currency_rupee_rounded,
                          size: 48,
                          color: Color(0xFF9333EA),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          LanguageService.t('app_name'),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9333EA),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          LanguageService.t('split_expenses'),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getCurrentLanguageName() {
    final currentLang = _settingsService.currentLanguage;
    for (var lang in LanguageService.supportedLanguages) {
      if (lang['code'] == currentLang) {
        return lang['nativeName'] ?? lang['name'] ?? 'Unknown';
      }
    }
    return 'English';
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LanguageService.t('select_language')),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: LanguageService.supportedLanguages.length,
              itemBuilder: (context, index) {
                final language = LanguageService.supportedLanguages[index];
                final isSelected = language['code'] == _settingsService.currentLanguage;
                
                return ListTile(
                  leading: Radio<String>(
                    value: language['code']!,
                    groupValue: _settingsService.currentLanguage,
                    onChanged: (String? value) {
                      if (value != null) {
                        LanguageService.setLanguage(value);
                        Navigator.of(context).pop();
                      }
                    },
                    activeColor: const Color(0xFF9333EA),
                  ),
                  title: Text(
                    language['nativeName']!,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? const Color(0xFF9333EA) : null,
                    ),
                  ),
                  subtitle: Text(
                    language['name']!,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  onTap: () {
                    LanguageService.setLanguage(language['code']!);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                LanguageService.t('cancel'),
                style: const TextStyle(color: Color(0xFF9333EA)),
              ),
            ),
          ],
        );
      },
    );
  }
}