import 'package:flutter/material.dart';
import 'package:smart_home101/components/Navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navbar(
      body: Container(
        child: ElevatedButton(
          onPressed: () {
            print("Asd");
          },
          child: const Text("sasdadadaadasdadaddasdadadaadada"),
        ),
      ),
      currentIndex: 0,
      showAppBar: false
    );
  }
}
