import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class IconMenu extends StatelessWidget {
  final HeroIcons icon;

  const IconMenu({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(9)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color.fromARGB(255, 202, 229, 255),
            Color.fromARGB(255, 255, 255, 255),
          ],
          tileMode: TileMode.mirror,
        ),
      ),
      child: Center(
        // child: icon,
        child: HeroIcon(
          icon,
          size: 20,
          color: const Color.fromRGBO(44, 131, 181, 1),
        ),
      ),
    );
  }
}
