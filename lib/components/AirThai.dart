import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heroicons/heroicons.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smart_home101/components/Font.dart';
import 'package:smart_home101/utils/global.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_home101/providers/locale_provider.dart';

class AirThai extends StatefulWidget {
  final String? hitText;
  const AirThai({
    super.key,
    this.hitText,
  });

  @override
  _AirThaiState createState() => _AirThaiState();
}

class _AirThaiState extends State<AirThai> {
  String subAddress = "";
  num? aqi;
  String imagePath = "";
  num? temp;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        subAddress = AppLocalizations.of(context)!.aqiLoadingAddress;
      });
    });
    _getAir();
  }

  Future<void> _getAir() async {
    try {
      final localeProvider =
          Provider.of<LocaleProvider>(context, listen: false);
      final locale = localeProvider.locale.languageCode;

      Position position = await getLocationDevice();
      final dataAddress = await AddressUtils.getAddress(
          position.latitude, position.longitude,
          quarter: true, suburb: true, localeCode: locale);

      final getData = Uri.parse('${dotenv.env['AIRVISUAL_URL_NEAREST_CITY']}'
          '?lat=${position.latitude}&lon=${position.longitude}&key=${dotenv.env['AIRVISUAL_API_KEY']}');

      final response = await http.get(getData);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final pollution = data['data']['current']['pollution'];
        final weather = data['data']['current']['weather'];
        setState(() {
          subAddress = dataAddress;
          aqi = pollution['aqius'];
          temp = weather['tp'];
          imagePath = "https://www.airvisual.com/images/${weather['ic']}.png";
        });
      } else {
        setState(() {
          subAddress =
              AppLocalizations.of(context)!.aqiLoadingAddressUnableData;
          aqi = null;
          temp = null;
          imagePath = "";
        });
      }
    } catch (e) {
      setState(() {
        subAddress = AppLocalizations.of(context)!.aqiLoadingAddressError;
        aqi = null;
        temp = null;
        imagePath = "";
      });
    }
  }

  Map<String, dynamic> getAQIDetails(num aqi) {
    if (aqi >= 0 && aqi <= 50) {
      return {
        'color': const Color.fromRGBO(169, 223, 96, 1),
        'icon': dotenv.env['AIRVISUAL_URL_GREEN_FACE'],
        'iconColor': const Color.fromRGBO(95, 117, 51, 1),
        'subColor': const Color.fromRGBO(184, 229, 129, 1),
      };
    } else if (aqi > 50 && aqi <= 100) {
      return {
        'color': const Color.fromRGBO(253, 214, 77, 1),
        'icon': dotenv.env['AIRVISUAL_URL_YELLOW_FACE'],
        'iconColor': const Color.fromRGBO(139, 107, 29, 1),
        'subColor': const Color.fromRGBO(253, 239, 181, 1),
      };
    } else if (aqi > 100 && aqi <= 150) {
      return {
        'color': const Color.fromRGBO(254, 155, 84, 1),
        'icon': dotenv.env['AIRVISUAL_URL_ORANGE_FACE'],
        'iconColor': const Color.fromRGBO(151, 74, 30, 1),
        'subColor': const Color.fromRGBO(254, 173, 118, 1),
      };
    } else if (aqi > 150 && aqi <= 200) {
      return {
        'color': const Color.fromRGBO(254, 106, 105, 1),
        'icon': dotenv.env['AIRVISUAL_URL_RED_FACE'],
        'iconColor': const Color.fromRGBO(149, 36, 50, 1),
        'subColor': const Color.fromRGBO(255, 133, 132, 1),
      };
    } else if (aqi > 200 && aqi <= 300) {
      return {
        'color': const Color.fromRGBO(168, 122, 188, 1),
        'icon': dotenv.env['AIRVISUAL_URL_PUEPLE_FACE'],
        'iconColor': const Color.fromRGBO(82, 59, 99, 1),
        'subColor': const Color.fromRGBO(186, 146, 200, 1),
      };
    } else {
      return {
        'color': Color.fromRGBO(167, 114, 131, 1),
        'icon': dotenv.env['AIRVISUAL_URL_MAROON_FACE'],
        'iconColor': Color.fromRGBO(86, 51, 67, 1),
        'subColor': Color.fromRGBO(227, 204, 20, 19)
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final aqiDetails = getAQIDetails(aqi ?? 0);

    return Card(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const HeroIcon(
                  HeroIcons.mapPin,
                  size: 14,
                ),
                const SizedBox(
                  width: 8,
                ),
                Font(
                  text: subAddress,
                  textColor: Colors.grey,
                  fontSize: 12,
                  fontWeight: true,
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(9),
                    ),
                    color: aqiDetails['color'],
                  ),
                  alignment: Alignment.center,
                  height: 82,
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: SvgPicture.network(
                      aqiDetails['icon'],
                      height: 60,
                      width: 60,
                      color: aqiDetails['iconColor'],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(9),
                    ),
                    color: aqiDetails['subColor'],
                  ),
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  height: 82,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Font(
                              text: aqi != null ? aqi.toString() : '0',
                              fontSize: 30,
                              textColor: aqiDetails['iconColor'],
                            ),
                            Font(
                              text: "US AQI",
                              fontSize: 8,
                              textColor: aqiDetails['iconColor'],
                              fontWeight: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
