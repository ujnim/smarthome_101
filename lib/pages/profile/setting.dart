import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:smart_home101/Components/Button.dart';
import 'package:smart_home101/components/InputForm.dart';
import 'package:smart_home101/components/Navbar.dart';
import 'package:smart_home101/utils/global.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final VoidCallback onSave;
  
  const ProfileSettingsScreen({super.key, required this.onSave});
  @override
  // ignore: library_private_types_in_public_api
  _ProfileSettingsScreenState createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();

  File? _profileImage;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  DateTime? _selectedDate;

  final email = getCurrentUserData(UserDataField.email);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      minDateTime: DateTime(1900, 1, 1),
      maxDateTime: DateTime.now(),
      initialDateTime: _selectedDate ?? DateTime.now(),
      dateFormat: 'dd-MM-yyyy', // ปรับตามที่คุณต้องการ เช่น ว-ด-ป
      locale: DateTimePickerLocale.en_us,
      pickerMode: DateTimePickerMode.date,
      pickerTheme: DateTimePickerTheme(
        backgroundColor: Colors.white,
        itemTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
        cancel: Text(AppLocalizations.of(context)!
                                          .cancel, style: const TextStyle(color: Colors.red)),
        confirm: Text(AppLocalizations.of(context)!
                                          .done, style: const TextStyle(color: Colors.blue)),
        itemHeight: 36,
      ),
      onConfirm: (date, List<int> index) {
        setState(() {
          // เพิ่ม 543 ปีเพื่อแสดงเป็นปีพุทธศักราช
          // int buddhistYear = date.year + 543;
          _dobController.text =
              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString()}';
          _selectedDate = date;
        });
      },
    );
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('profiles').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _nameController.text = data['firstname'] ?? '';
        _surnameController.text = data['lastname'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _dobController.text = data['dob'] ?? '';
        // Load profile image if available
        // ...
      }

      _emailController.text = email ?? '';
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('profiles').doc(user.uid).set({
          'firstname': _nameController.text,
          'lastname': _surnameController.text,
          'phone': _phoneController.text,
          'dob': _dobController.text,
          'email': _emailController.text,
          // Include profile image URL if uploaded
          // ...
        }, SetOptions(merge: true));

        // Optionally, update the user profile (Firebase Authentication profile)
        await user.updateDisplayName(_nameController.text);
        // If you want to update the profile image URL
        // await user.updatePhotoURL(profileImageUrl);
        widget.onSave();
        Navigator.pop(context);
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      // Upload the image and get URL
      // ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navbar(
      titleMenu: AppLocalizations.of(context)!
                                          .profileSettingTitle,
      currentIndex: 2,
      showAppBar: true,
      backStep: true,
      showNavbar: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt, size: 50)
                      : null,
                ),
              ),
              InputForm(
                hintText: AppLocalizations.of(context)!
                                          .profileSettingName,
                controller: _nameController,
                isRequired: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                                          .profileSettingNameIsEmpty;
                  }
                  return null;
                },
              ),
              InputForm(
                hintText: AppLocalizations.of(context)!
                                          .profileSettingLastname,
                controller: _surnameController,
                isRequired: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                                          .profileSettingLastNameIsEmpty;
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: _showDatePicker,
                child: AbsorbPointer(
                  child: InputForm(
                    hintText: AppLocalizations.of(context)!
                                          .profileSettingBOD,
                    controller: _dobController,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                                          .profileSettingBODIsEmpty;
                      }
                      return null;
                    },
                  ),
                ),
              ),
              InputForm(
                hintText: AppLocalizations.of(context)!
                                          .profileSettingPhone,
                controller: _phoneController,
                isRequired: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                                          .profileSettingPhoneIsEmpty;
                  }
                  return null;
                },
              ),
              InputForm(
                hintText: AppLocalizations.of(context)!
                                          .profileSettingEmail,
                controller: _emailController,
                isRequired: true,
                isEnabled: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                                          .profileSettingEmailIsEmpty;
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return AppLocalizations.of(context)!
                                          .profileSettingEmailValidation;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Button(text: AppLocalizations.of(context)!
                                          .submit, onPressed: _updateProfile),
            ],
          ),
        ),
      ),
    );
  }
}
