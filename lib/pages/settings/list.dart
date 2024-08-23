import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_home101/Components/Button.dart';
import 'package:smart_home101/components/ListMenu.dart';
import 'package:smart_home101/components/Navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:heroicons/heroicons.dart';
import 'package:smart_home101/pages/home/list.dart';
import 'package:smart_home101/pages/legals/about.dart';
import 'package:smart_home101/pages/legals/policies.dart';
import 'package:smart_home101/pages/legals/report.dart';
import 'package:smart_home101/pages/legals/terms.dart';
import 'package:smart_home101/pages/profile/detail.dart';
import 'package:smart_home101/pages/profile/qrcode.dart';
import 'package:smart_home101/pages/settings/language.dart';
import 'package:smart_home101/providers/user_profile_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await userProfileProvider.fetchUserProfile(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfileProvider>(context).userProfile;
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': HeroIcons.home,
        'menuName': AppLocalizations.of(context)!.settingsHomeManagement,
        'link': const HomeListScreen()
      },
      {
        'icon': HeroIcons.language,
        'menuName': AppLocalizations.of(context)!.settingsLanguage,
        'description': AppLocalizations.of(context)!.settingsLanguageCurrent,
        'title': AppLocalizations.of(context)!.settings,
        'space': true,
        'border': true,
        'link': const LanguageScreen()
      },
      {
        'icon': HeroIcons.bellAlert,
        'menuName': AppLocalizations.of(context)!.settingsNotifications,
      },
      {
        'icon': HeroIcons.document,
        'menuName':
            AppLocalizations.of(context)!.settingsTermsAndConditionsOfService,
        'title': AppLocalizations.of(context)!.settingsTermsAndPolicies,
        'space': true,
        'border': true,
        'link': const TermsScreen()
      },
      {
        'icon': HeroIcons.documentText,
        'menuName': AppLocalizations.of(context)!.settingsPrivacyPolicy,
        'link': const PoliciesScreen()
      },
      {
        'icon': HeroIcons.deviceTablet,
        'menuName': AppLocalizations.of(context)!.settingsAboutTheApplication,
        'title': AppLocalizations.of(context)!.settingsApplication,
        'space': true,
        'link': const AboutScreen()
      },
      {
        'icon': HeroIcons.chatBubbleBottomCenterText,
        'menuName': AppLocalizations.of(context)!.settingsReport,
        'title': AppLocalizations.of(context)!.settingsHelp,
        'space': true,
        'link': const ReportScreen()
      },
    ];
    return Navbar(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ListMenu(
                icon: HeroIcons.user,
                menuName:
                    userProfile?.name ?? AppLocalizations.of(context)!.user,
                subText:
                    userProfile?.phone ?? AppLocalizations.of(context)!.mobile,
                onTab: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileDetailScreen()),
                  );
                },
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...menuItems.map(
                    (item) {
                      return ListMenu(
                        icon: item['icon'],
                        menuName: item['menuName'],
                        title: item.containsKey('title') ? item['title'] : "",
                        subText:
                            item.containsKey('subText') ? item['subText'] : "",
                        description: item.containsKey('description')
                            ? item['description']
                            : "",
                        border:
                            item.containsKey('border') ? item['border'] : false,
                        bold: item.containsKey('bold') ? item['bold'] : true,
                        space:
                            item.containsKey('space') ? item['space'] : false,
                        onTab: item.containsKey('link')
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => item['link']),
                                );
                              }
                            : null,
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Button(
                      text: AppLocalizations.of(context)!.logout,
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacementNamed(context, '/login');
                        } catch (e) {
                          print('Logout failed: $e');
                        }
                      },
                      bgColor: Colors.white,
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      currentIndex: 2,
      titleMenu: AppLocalizations.of(context)!.navBarProfile,
      backStep: false,
      rightIcon: IconButton(
        icon: const HeroIcon(HeroIcons.qrCode, size: 24),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProfileQRCodeScreen()),
          );
        },
      ),
    );
  }
}
