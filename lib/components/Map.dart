import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_home101/components/Button.dart';
import 'package:smart_home101/providers/locale_provider.dart';
import 'package:smart_home101/utils/global.dart';
import 'package:http/http.dart' as http;
import 'package:heroicons/heroicons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapComponent extends StatefulWidget {
  final void Function(LatLng, String) onNextRouted;

  const MapComponent({
    super.key,
    required this.onNextRouted,
  });

  @override
  _MapComponentState createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  LatLng? currentPosition;
  String address = "";
  String subAddress = "";
  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        address = AppLocalizations.of(context)!.mapGetCurrentLocation;
      });
    });
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentPosition != null) {
        mapController.animateCamera(
          CameraUpdate.newLatLng(currentPosition!),
        );
      }
    });
  }

  void _onPositionChanged(LatLng newPosition) async {
    if (newPosition == currentPosition) return;

    setState(() {
      currentPosition = newPosition;
    });

    try {
      final localeProvider =
          Provider.of<LocaleProvider>(context, listen: false);
      final locale = localeProvider.locale.languageCode;

      final subAddress2 = await AddressUtils.getAddress(
        newPosition.latitude,
        newPosition.longitude,
        quarter: true,
        suburb: true,
        city: true,
        localeCode: locale,
      );

      // const apiKey = dotenv.env['GOOGLE_API_KEY'];
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json'
        '?latlng=${newPosition.latitude},${newPosition.longitude}'
        '&key=${dotenv.env['GOOGLE_API_KEY']}'
        '&language=$locale',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'].isNotEmpty) {
          final addressComponents = data['results'][0]['address_components'];

          setState(() {
            address =
                "${addressComponents[0]['long_name']} ${addressComponents[1]['long_name']}";
            subAddress = subAddress2;
          });
        }
      } else {
        setState(() {
          address = 'Failed to fetch address';
          subAddress = '';
        });
      }
    } catch (e) {
      setState(() {
        address = AppLocalizations.of(context)!.mapGetCurrentLocationError;
        subAddress = '';
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraIdle() {
    mapController
        .getLatLng(ScreenCoordinate(
      x: MediaQuery.of(context).size.width ~/ 2,
      y: MediaQuery.of(context).size.height ~/ 2,
    ))
        .then((latLng) {
      if (latLng != currentPosition) {
        _onPositionChanged(latLng);
      }
      setState(() {
        currentPosition = latLng;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                  target:
                      currentPosition ?? const LatLng(13.7282785, 100.5413736),
                  zoom: 18,
                ),
                onCameraIdle: _onCameraIdle,
              ),
              const Center(
                child: Icon(
                  Icons.location_pin,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(9)),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Container(
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
                    child: const Center(
                      child: HeroIcon(
                        HeroIcons.mapPin,
                        size: 20,
                        color: Color.fromRGBO(44, 131, 181, 1),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (subAddress.isNotEmpty)
                        Text(
                          subAddress,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 126, 126, 126)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Button(
              text: AppLocalizations.of(context)!.done,
              onPressed: () {
                if (currentPosition != null) {
                  widget.onNextRouted(currentPosition!, address);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context)!
                          .mapSelectCurrentLocation),
                    ),
                  );
                }
              },
              bgColor: const Color.fromRGBO(44, 131, 181, 1),
              textColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
