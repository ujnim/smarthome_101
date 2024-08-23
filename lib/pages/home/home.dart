import 'package:flutter/material.dart';
import 'package:smart_home101/components/AirThai.dart';
import 'package:smart_home101/components/Navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Navbar(
      body:  Column(
        children: [
          AirThai()
        ],
      ),
      currentIndex: 0,
      showAppBar: false,
    );
  }
}
