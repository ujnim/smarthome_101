import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smart_home101/Components/Button.dart';
import 'package:smart_home101/components/Font.dart';
import 'package:smart_home101/components/MultiTextSpan.dart';
import 'package:smart_home101/components/Navbar.dart';
import 'package:smart_home101/components/colors/AppColor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:el_tooltip/el_tooltip.dart';

class ProfileQRCodeScreen extends StatefulWidget {
  const ProfileQRCodeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileQRCodeScreen createState() => _ProfileQRCodeScreen();
}

class _ProfileQRCodeScreen extends State<ProfileQRCodeScreen> {
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
    String userDataJson = user != null ? _getUserDataAsJson(user!) : '';

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
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Column(
                        children: [
                          QrImageView(
                            data: userDataJson,
                            version: QrVersions.auto,
                            size: 200.0,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10),
                            child: Font(
                              text: "fulname", // ตรวจสอบความถูกต้องของการสะกด
                              fontSize: 20,
                              fontWeight: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Font(
                          text: AppLocalizations.of(context)!
                              .profileQRCodeShowQRCode,
                          fontSize: 14),
                      Font(
                          text: AppLocalizations.of(context)!
                              .profileQRCodeHomeOwnerScan,
                          fontSize: 14),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Font(
                              text: AppLocalizations.of(context)!
                                  .profileQRCodeWhatScan,
                              fontSize: 10),
                          const SizedBox(width: 5),
                          ElTooltip(
                            content: SizedBox(
                              width: 200,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .profileQRCodeAccessHome,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            position: ElTooltipPosition.bottomEnd,
                            color: Colors.black,
                            showModal: true,
                            radius: const Radius.circular(19),
                            modalConfiguration:
                                const ModalConfiguration(color: Colors.white),
                            child: const HeroIcon(
                              HeroIcons.questionMarkCircle,
                              size: 14,
                              color: AppColor.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Font(
                              text: AppLocalizations.of(context)!
                                  .profileQRCodeHowScan,
                              fontSize: 10),
                          const SizedBox(width: 5),
                          ElTooltip(
                            content: SizedBox(
                              width: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      AppLocalizations.of(context)!
                                          .profileQRCodeScanStep1,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                      softWrap: true,
                                      overflow: TextOverflow.visible),
                                  Text(
                                      AppLocalizations.of(context)!
                                          .profileQRCodeScanStep2,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                      softWrap: true,
                                      overflow: TextOverflow.visible),
                                  Text(
                                      AppLocalizations.of(context)!
                                          .profileQRCodeScanStep3,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                      softWrap: true,
                                      overflow: TextOverflow.visible),
                                  Text(
                                      AppLocalizations.of(context)!
                                          .profileQRCodeScanStep4,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                      softWrap: true,
                                      overflow: TextOverflow.visible),
                                ],
                              ),
                            ),
                            position: ElTooltipPosition.bottomEnd,
                            color: Colors.black,
                            showModal: true,
                            radius: const Radius.circular(19),
                            modalConfiguration:
                                const ModalConfiguration(color: Colors.white),
                            child: const HeroIcon(
                              HeroIcons.questionMarkCircle,
                              size: 14,
                              color: AppColor.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          MultiTextSpan(
                            align: TextAlign.center,
                            texts: [
                              {
                                'text': AppLocalizations.of(context)!
                                    .profileQRCodeSuccessAccess,
                              },
                              {
                                'text': AppLocalizations.of(context)!
                                    .profileQRCodeRefresh,
                                'color': AppColor.primary,
                              },
                              {
                                'text': AppLocalizations.of(context)!
                                    .profileQRCodeCheckStatusOfHome,
                              },
                            ],
                          ),
                          const SizedBox(height: 15),
                          Button(
                            text: AppLocalizations.of(context)!
                                .profileQRCodeCheckStatus,
                            onPressed: () {
                              // Add your onPressed action here
                            },
                          ),
                        ],
                      ),
                    ),
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
      titleMenu: AppLocalizations.of(context)!.profileQRCodeMyQRCode,
    );
  }
}
