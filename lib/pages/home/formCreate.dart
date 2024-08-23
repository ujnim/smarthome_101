import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heroicons/heroicons.dart';
import 'package:smart_home101/components/Button.dart';
import 'package:smart_home101/components/Font.dart';
import 'package:smart_home101/components/InputForm.dart';
import 'package:smart_home101/components/Navbar.dart';
import 'package:smart_home101/components/TextArea.dart';
import 'package:smart_home101/components/ThaiAddress.dart';
import 'package:smart_home101/components/colors/AppColor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:smart_home101/controllers/FireBaseController.dart';
import 'package:smart_home101/utils/global.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FormCreateScreen extends StatefulWidget {
  final double lat;
  final double long;
  final String address;

  const FormCreateScreen({
    super.key,
    required this.lat,
    required this.long,
    this.address = '',
  });

  @override
  _FormCreateScreenState createState() => _FormCreateScreenState();
}

class _FormCreateScreenState extends State<FormCreateScreen> {
  LatLng? currentPosition;
  String? address;
  bool isButtonDisabled = true;
  String errorMessage = '';
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _homeKey = GlobalKey<FormState>();

  String? selectedProvince;
  String? selectedDistrict;
  String? selectedSubDistrict;
  String? selectedPostalCode;

  final fireBaseController = FireBaseController();

  @override
  void initState() {
    super.initState();
    _initializePositionAndAddress();
    _nameController.addListener(_checkFormValidity);
    _addressController.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    setState(() {
      isButtonDisabled = _nameController.text.isEmpty ||
          _addressController.text.isEmpty ||
          selectedProvince == null ||
          selectedDistrict == null ||
          selectedSubDistrict == null ||
          selectedPostalCode == null;
    });
  }

  void _initializePositionAndAddress() {
    setState(() {
      currentPosition = LatLng(widget.lat, widget.long);
      address = widget.address.isNotEmpty
          ? widget.address
          : AppLocalizations.of(context)!.aqiLoadingAddress;
    });
  }

  Future<void> _createHome() async {
    if (_homeKey.currentState?.validate() ?? false) {
      try {
        setState(() {
          errorMessage = '';
        });

        final userId = getCurrentUser();
        if (userId == null) {
          setState(() {
            errorMessage = 'ไม่สามารถดึงข้อมูลผู้ใช้ได้';
          });
          return;
        }

        await fireBaseController.create("homes", {
          'name': _nameController.text,
          'address': _addressController.text,
          'province': selectedProvince,
          'district': selectedDistrict,
          'subDistrict': selectedSubDistrict,
          'postalCode': selectedPostalCode,
          'latitude': currentPosition?.latitude,
          'longitude': currentPosition?.longitude,
          'owner': userId,
        });

        Navigator.popUntil(context, (route) {
          // ถ้าหน้าไหนมีชื่อเป็น '/settings/home/list' ให้คงไว้
          return route.settings.name == '/settings/home/list';
        });

        Navigator.pushNamed(context, '/settings/home/list');
      } catch (e) {
        setState(() {
          errorMessage = "การสร้างบ้านล้มเหลว: $e";
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navbar(
      body: SingleChildScrollView(
        child: Form(
          key: _homeKey,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(4),
                  dashPattern: const [4, 4],
                  color: AppColor.gray,
                  strokeWidth: 2,
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    child: Container(
                      color: const Color.fromARGB(255, 245, 245, 245),
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const HeroIcon(
                            HeroIcons.informationCircle,
                            color: Color.fromARGB(255, 83, 83, 83),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Font(
                              text:
                                  AppLocalizations.of(context)!.homeCreateDescription,
                              fontSize: 10,
                              textColor: const Color.fromARGB(255, 83, 83, 83),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InputForm(
                  controller: _nameController,
                  hintText: AppLocalizations.of(context)!.homeCreateHomeName,
                  isRequired: true,
                  description:
                      AppLocalizations.of(context)!.homeCreateHomeNameDescription,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.homeCreateHomeNameError;
                    }
                    return null;
                  },
                ),
                TextArea(
                  controller: _addressController,
                  maxLength: 250,
                  title: AppLocalizations.of(context)!.homeCreateHomeAddress,
                ),
                ThaiAddress(
                  onProvinceSelected: (province) {
                    setState(() {
                      selectedProvince = province;
                      _checkFormValidity();
                    });
                  },
                  onDistrictSelected: (district) {
                    setState(() {
                      selectedDistrict = district;
                      _checkFormValidity();
                    });
                  },
                  onSubDistrictSelected: (subDistrict) {
                    setState(() {
                      selectedSubDistrict = subDistrict;
                      _checkFormValidity();
                    });
                  },
                  onPostcodeSelected: (postcode) {
                    setState(() {
                      selectedPostalCode = postcode;
                      _checkFormValidity();
                    });
                  },
                ),
                const SizedBox(height: 20),
                Button(
                  text: AppLocalizations.of(context)!.homeCreateSubmit,
                  onPressed: isButtonDisabled ? null : _createHome,
                ),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      currentIndex: 0,
      showAppBar: true,
      titleMenu: AppLocalizations.of(context)!.homeCreateFromTitle,
      backStep: true,
      showNavbar: false,
    );
  }
}
