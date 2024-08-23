import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_home101/components/Map.dart';
import 'package:smart_home101/components/Navbar.dart';
import 'package:smart_home101/pages/home/formCreate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeCreateScreen extends StatefulWidget {
  const HomeCreateScreen({super.key});

  @override
  _HomeCreateScreen createState() => _HomeCreateScreen();
}

class _HomeCreateScreen extends State<HomeCreateScreen> {
  LatLng? currentPosition;
  String? address;

  void _navigateToFormCreateScreen(LatLng position, String address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormCreateScreen(
          lat: position.latitude,
          long: position.longitude,
          address: address,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Navbar(
      body: MapComponent(
        onNextRouted: (LatLng position, String address) {
          setState(() {
            currentPosition = position;
            this.address = address;
          });
          _navigateToFormCreateScreen(position, address);
        },
        
      ),
      currentIndex: 2,
      showAppBar: true,
      backStep: true,
      showNavbar: false,
      titleMenu: AppLocalizations.of(context)!.homeCreateTitle,
    );
  }
}
