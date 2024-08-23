import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:smart_home101/components/InputForm.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThaiAddress extends StatefulWidget {
  final ValueChanged<String?>? onProvinceSelected;
  final ValueChanged<String?>? onDistrictSelected;
  final ValueChanged<String?>? onSubDistrictSelected;
  final ValueChanged<String?>? onPostcodeSelected;

  const ThaiAddress({
    super.key,
    this.onProvinceSelected,
    this.onDistrictSelected,
    this.onSubDistrictSelected,
    this.onPostcodeSelected,
  });

  @override
  _ThaiAddressState createState() => _ThaiAddressState();
}

class _ThaiAddressState extends State<ThaiAddress> {
  List<dynamic>? _provinces;
  Map<int, List<dynamic>> _districts = {};
  Map<int, List<dynamic>> _subdistricts = {};

  int? _selectedProvinceId;
  int? _selectedDistrictId;
  int? _selectedSubdistrictId;
  String? _postcode;
  String? _selectedProvinceName;
  String? _selectedDistrictName;
  String? _selectedSubdistrictName;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final provincesData =
          await rootBundle.loadString('assets/data/provinces.json');
      final districtsData =
          await rootBundle.loadString('assets/data/districts.json');
      final subdistrictsData =
          await rootBundle.loadString('assets/data/subdistricts.json');

      final provinces = json.decode(provincesData) as List<dynamic>;
      final districts = json.decode(districtsData) as List<dynamic>;
      final subdistricts = json.decode(subdistrictsData) as List<dynamic>;

      setState(() {
        _provinces = [...provinces];

        _districts = {
          for (var district in districts)
            int.parse(district['province_id']): [
              for (var d in districts
                  .where((d) => d['province_id'] == district['province_id']))
                {'id': int.parse(d['id']), 'name_th': d['name_th']}
            ]
        };

        _subdistricts = {};
        for (var subdistrict in subdistricts) {
          int amphurId = int.parse(subdistrict['amphur_id']);
          if (!_subdistricts.containsKey(amphurId)) {
            _subdistricts[amphurId] = [];
          }
          _subdistricts[amphurId]!.add({
            'id': int.parse(subdistrict['id']),
            'name_th': subdistrict['name_th'],
            'zipcode': subdistrict['zipcode']
          });
        }
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  void _showPicker(String type) {
    final List<Widget> pickerItems;
    int initialItem = 0;
    if (type == 'province') {
      pickerItems = _provinces!.map((province) {
        return Center(child: Text(province['name_th']));
      }).toList();
      initialItem = _selectedProvinceId != null
          ? _provinces!
              .indexWhere((p) => p['id'] == _selectedProvinceId.toString())
          : 0;
    } else if (type == 'district') {
      pickerItems = _districts[_selectedProvinceId]!.map((district) {
        return Center(child: Text(district['name_th']));
      }).toList();
      initialItem = _selectedDistrictId != null
          ? _districts[_selectedProvinceId]!
              .indexWhere((d) => d['id'] == _selectedDistrictId)
          : 0;
    } else {
      pickerItems = _subdistricts[_selectedDistrictId]!.map((subdistrict) {
        return Center(child: Text(subdistrict['name_th']));
      }).toList();
      initialItem = _selectedSubdistrictId != null
          ? _subdistricts[_selectedDistrictId]!
              .indexWhere((s) => s['id'] == _selectedSubdistrictId)
          : 0;
    }

    int selectedItem = initialItem;

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            SizedBox(
              height: 200.0, // Adjust the height of the picker as needed
              child: CupertinoPicker(
                itemExtent: 40.0,
                scrollController:
                    FixedExtentScrollController(initialItem: initialItem),
                onSelectedItemChanged: (int index) {
                  selectedItem = index;
                },
                children: pickerItems,
              ),
            ),
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context)!.done),
              onPressed: () {
                setState(() {
                  if (type == 'province') {
                    _selectedProvinceId =
                        int.parse(_provinces![selectedItem]['id']);
                    _selectedProvinceName =
                        _provinces![selectedItem]['name_th'];
                    _selectedDistrictId = null; // Reset district
                    _selectedSubdistrictId = null; // Reset subdistrict
                    _postcode = null; // Reset postcode

                    // Call the callback for Province
                    if (widget.onProvinceSelected != null) {
                      widget.onProvinceSelected!(_selectedProvinceName);
                    }
                  } else if (type == 'district') {
                    _selectedDistrictId =
                        _districts[_selectedProvinceId]![selectedItem]['id'];
                    _selectedDistrictName =
                        _districts[_selectedProvinceId]![selectedItem]
                            ['name_th'];
                    _selectedSubdistrictId = null; // Reset subdistrict
                    _postcode = null; // Reset postcode

                    // Call the callback for District
                    if (widget.onDistrictSelected != null) {
                      widget.onDistrictSelected!(_selectedDistrictName);
                    }
                  } else {
                    _selectedSubdistrictId =
                        _subdistricts[_selectedDistrictId]![selectedItem]['id'];
                    _postcode =
                        _subdistricts[_selectedDistrictId]![selectedItem]
                                ['zipcode']
                            .toString();
                    _selectedSubdistrictName =
                        _subdistricts[_selectedDistrictId]![selectedItem]
                            ['name_th'];

                    // Call the callbacks for Subdistrict and Postal Code
                    if (widget.onSubDistrictSelected != null) {
                      widget.onSubDistrictSelected!(_selectedSubdistrictName);
                    }
                    if (widget.onPostcodeSelected != null) {
                      widget.onPostcodeSelected!(_postcode);
                    }
                  }
                });
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                Navigator.pop(context);
              },
              isDestructiveAction: true,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField(
          label: AppLocalizations.of(context)!.province,
          value: _selectedProvinceName ?? '${AppLocalizations.of(context)!.select}${AppLocalizations.of(context)!.province}',
          onTap: () => _showPicker('province'),
        ),
        const SizedBox(height: 10),
        _selectedProvinceId == null || _selectedProvinceId == 0
            ? Container()
            : _buildInputField(
                label: AppLocalizations.of(context)!.district,
                value: _selectedDistrictName ?? '${AppLocalizations.of(context)!.select}${AppLocalizations.of(context)!.district}',
                onTap: () => _showPicker('district'),
              ),
        const SizedBox(height: 10),
        _selectedDistrictId == null || _selectedDistrictId == 0
            ? Container()
            : _buildInputField(
                label: AppLocalizations.of(context)!.subDistrict,
                value: _selectedSubdistrictName ?? '${AppLocalizations.of(context)!.select}${AppLocalizations.of(context)!.subDistrict}',
                onTap: () => _showPicker('subdistrict'),
              ),
        const SizedBox(height: 10),
        if (_postcode != null)
          _buildInputField(
            label: AppLocalizations.of(context)!.postalCode,
            value: _postcode ?? '${AppLocalizations.of(context)!.select}${AppLocalizations.of(context)!.postalCode}',
            onTap: () => {},
          ),
        // Text('Postal Code: $_postcode', style: const TextStyle(fontSize: 18)),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity, // Make sure the field takes full width
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: InputForm(
            hintText: label,
            controller: TextEditingController(text: value),
            isRequired: true,
          ),
        ),
      ),
    );
  }
}
