import 'package:flutter/material.dart';
import '../services/language_service.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = LanguageService.currentLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageService.t('language')),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF9333EA),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[50],
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: LanguageService.supportedLanguages.length,
        itemBuilder: (context, index) {
          final language = LanguageService.supportedLanguages[index];
          final isSelected = _selectedLanguage == language['code'];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFF9333EA) : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: RadioListTile<String>(
              value: language['code']!,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  LanguageService.setLanguage(value);
                  
                  // Show confirmation snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${LanguageService.t('language')} ${LanguageService.t('changed_to')} ${language['nativeName']}'),
                      backgroundColor: const Color(0xFF9333EA),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              title: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9333EA), Color(0xFFEC4899)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        language['nativeName']![0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language['nativeName']!,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: isSelected ? const Color(0xFF9333EA) : Colors.black87,
                        ),
                      ),
                      Text(
                        language['name']!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              activeColor: const Color(0xFF9333EA),
              controlAffinity: ListTileControlAffinity.trailing,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: const Color(0xFF9333EA),
        icon: const Icon(Icons.check),
        label: Text(LanguageService.t('done')),
      ),
    );
  }
}