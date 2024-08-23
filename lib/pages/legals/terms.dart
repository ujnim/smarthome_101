import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_home101/components/Font.dart';
import 'package:smart_home101/components/Navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  _TermsScreen createState() => _TermsScreen();
}

class _TermsScreen extends State<TermsScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  String _getUserDataAsJson(User user) {
    Map<String, dynamic> userData = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'phoneNumber': user.phoneNumber,
      'photoURL': user.photoURL,
    };
    return jsonEncode(userData);
  }

  @override
  Widget build(BuildContext context) {
    final termsData = [
      AppLocalizations.of(context)!.termsParagraph1,
      AppLocalizations.of(context)!.termsParagraph2,
      AppLocalizations.of(context)!.terms1,
      AppLocalizations.of(context)!.terms2,
      AppLocalizations.of(context)!.terms3,
      AppLocalizations.of(context)!.terms4,
      AppLocalizations.of(context)!.terms5,
      AppLocalizations.of(context)!.terms6,
      AppLocalizations.of(context)!.terms7,
      AppLocalizations.of(context)!.terms8,
      AppLocalizations.of(context)!.terms9,
      AppLocalizations.of(context)!.terms10,
      AppLocalizations.of(context)!.terms11,
      AppLocalizations.of(context)!.terms12,
      AppLocalizations.of(context)!.terms13,
      AppLocalizations.of(context)!.terms14,
      AppLocalizations.of(context)!.terms15,
      AppLocalizations.of(context)!.terms16,
      AppLocalizations.of(context)!.terms17,
      AppLocalizations.of(context)!.terms18,
    ];

    return Navbar(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Font(
                        text: AppLocalizations.of(context)!.termsDateStart,
                        fontSize: 14,
                        textColor: Colors.red,
                        fontWeight: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(termsData.length, (index) {
                      return Html(
                        data: termsData[index],
                        style: {
                          "pre": Style(
                            display: Display.inline,
                          ),
                          "*": Style(
                            fontSize: FontSize(10),
                          ),
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      currentIndex: 2,
      showAppBar: true,
      backStep: true,
      showNavbar: false,
      titleMenu: AppLocalizations.of(context)!.settingsTermsAndConditionsOfService,
    );
  }
}
