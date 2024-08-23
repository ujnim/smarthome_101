import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heroicons/heroicons.dart';
import 'package:smart_home101/components/Font.dart';
import 'package:smart_home101/components/IconMenu.dart';
import 'package:smart_home101/components/Navbar.dart';
import 'package:smart_home101/components/colors/AppColor.dart';
import 'package:smart_home101/controllers/FireBaseController.dart';
import 'package:smart_home101/pages/profile/setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileDetailScreen createState() => _ProfileDetailScreen();
}

class _ProfileDetailScreen extends State<ProfileDetailScreen> {
  LatLng? currentPosition;
  String? address;
  User? user;
  final profileController = ProfileController(FirebaseFirestore.instance);

  Map<String, dynamic>? profile;
  String? fullname;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      fetchUserProfile(user!.uid);
    } else {
      print('No user is currently signed in.');
    }
  }

  Future<void> fetchUserProfile(String userId) async {
    final profileJson = await profileController.getProfile(userId);
    if (profileJson != null) {
      setState(() {
        profile = profileJson;
        fullname = (profileJson['firstname'] ?? '') +
            " " +
            (profileJson['lastname'] ?? '');
      });
    } else {
      setState(() {
        profile = null;
        fullname = null; // Update the profile data
      });
    }
  }

  void _refreshProfile() {
    if (user != null) {
      fetchUserProfile(user!.uid);
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Navbar(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Center(
            child: Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png',
              width: 120,
              height: 120,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Font(
              text: fullname ?? AppLocalizations.of(context)!
                                          .profileDetailErrorDataName,
              fontSize: 20,
              fontWeight: true,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    const IconMenu(icon: HeroIcons.phone),
                    const SizedBox(
                      width: 15,
                    ),
                    Font(
                      text: profile?['phone'] ??  AppLocalizations.of(context)!
                                          .profileDetailErrorDataPhone,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
              const Divider(
                color: AppColor.gray, // Color of the divider
                thickness: 1, // Thickness of the divider
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    const IconMenu(icon: HeroIcons.cake),
                    const SizedBox(
                      width: 15,
                    ),
                    Font(
                      text: profile?['dob'] ?? AppLocalizations.of(context)!
                                          .profileDetailErrorDataBOD,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
              const Divider(
                color: AppColor.gray, // Color of the divider
                thickness: 1, // Thickness of the divider
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    const IconMenu(icon: HeroIcons.inbox),
                    const SizedBox(
                      width: 15,
                    ),
                    Font(
                      text: user?.email ?? AppLocalizations.of(context)!
                                          .profileDetailErrorDataEmail,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      currentIndex: 2,
      showAppBar: true,
      backStep: true,
      showNavbar: false,
      titleMenu: '',
      rightIcon: IconButton(
        icon: const HeroIcon(HeroIcons.pencilSquare, size: 24),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileSettingsScreen(onSave: _refreshProfile)),
          );
        },
      ),
    );
  }
}
