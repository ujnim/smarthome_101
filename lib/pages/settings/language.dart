import 'package:flutter/material.dart';
import 'package:smart_home101/components/Font.dart';
import 'package:smart_home101/components/Navbar.dart';
import 'package:smart_home101/components/colors/AppColor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:smart_home101/providers/locale_provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  void _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'en';

    setState(() {
      _selectedLanguage = languageCode == 'th' ? 'Thai' : 'English';
    });
  }

  void _changeLanguage(String? language) async {
    if (language == null) return;

    Locale locale =
        (language == 'Thai') ? const Locale('th', '') : const Locale('en', '');

    Provider.of<LocaleProvider>(context, listen: false).setLocale(locale);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);

    setState(() {
      _selectedLanguage = language;
    });
  }

  bool get _isSubmitEnabled {
    return _selectedLanguage != null;
  }

  Color _getTileColor(String language) {
    return _selectedLanguage == language
        ? const Color.fromARGB(255, 208, 231, 245)
        : Colors.white;
  }

  Color _getTileMainColor(String language) {
    return _selectedLanguage == language ? AppColor.primary : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Navbar(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // ElevatedButton(
            //   onPressed: () => _changeLanguage(const Locale('th', '')),
            //   child: const Text('ไทย'),
            // ),
            // ElevatedButton(
            //   onPressed: () => _changeLanguage(const Locale('en', '')),
            //   child: const Text('English'),
            // ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: _getTileMainColor('Thai')),
                borderRadius: BorderRadius.circular(10),
                color: _getTileColor('Thai'),
              ),
              child: RadioListTile<String>(
                title: const Font(
                  text: "Thai",
                  fontSize: 14,
                  fontWeight: true,
                ),
                value: "Thai",
                groupValue: _selectedLanguage,
                onChanged: _changeLanguage,
                controlAffinity: ListTileControlAffinity.trailing,
                activeColor: AppColor.primary,
                contentPadding: const EdgeInsets.only(right: 0, left: 15),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: _getTileMainColor('English')),
                borderRadius: BorderRadius.circular(10),
                color: _getTileColor('English'),
              ),
              child: RadioListTile<String>(
                title: const Font(
                  text: "English",
                  fontSize: 14,
                  fontWeight: true,
                ),
                value: "English",
                groupValue: _selectedLanguage,
                onChanged: _changeLanguage,
                controlAffinity: ListTileControlAffinity.trailing,
                activeColor: AppColor.primary,
                contentPadding: const EdgeInsets.only(right: 0, left: 15),
              ),
            ),

            // const SizedBox(
            //   height: 20,
            // ),
            // Button(
            //   text: AppLocalizations.of(context)!.done,
            //   onPressed: _isSubmitEnabled
            //       ? () async {
            //           final prefs = await SharedPreferences.getInstance();
            //           await prefs.setString(
            //               'languageCode', _locale.languageCode);
            //           // ปิดหน้าหลังจากเปลี่ยนภาษา
            //           Navigator.pop(context);
            //           // รีโหลดข้อมูลในหน้าปัจจุบัน
            //           setState(() {});
            //         }
            //       : null, // ปิดการทำงานของปุ่มถ้าไม่ได้เลือกภาษาที่ต่างจากปัจจุบัน
            //   bgColor: _isSubmitEnabled ? AppColor.primary : Colors.grey,
            // )
          ],
        ),
      ),
      currentIndex: 2,
      showAppBar: true,
      backStep: true,
      showNavbar: false,
      titleMenu: AppLocalizations.of(context)!.settingsLanguage,
    );
  }
}
