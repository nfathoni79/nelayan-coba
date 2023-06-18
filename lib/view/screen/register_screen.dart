import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nelayan_coba/view/screen/otp_screen.dart';
import 'package:nelayan_coba/view/widget/my_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _ktpController = TextEditingController();
  File? _ktpImage;
  File? _selfieImage;

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade200,
            Colors.blue.shade600,
          ],
        )),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                  child: Image.asset(
                    'assets/images/perindo_nelayan.png',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Daftar Akun Baru',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      MyTextFormField(
                        controller: _phoneController,
                        labelText: 'Nomor Ponsel',
                        prefixText: '+62',
                        keyboardType: TextInputType.number,
                        maxLength: 12,
                        textInputAction: TextInputAction.next,
                        enabled: false,
                      ),
                      const SizedBox(height: 16),
                      MyTextFormField(
                        controller: _nameController,
                        labelText: 'Nama Lengkap',
                        keyboardType: TextInputType.name,
                        maxLength: 50,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            _validateEmpty(value, 'Isi nama lengkap Anda'),
                      ),
                      const SizedBox(height: 16),
                      MyTextFormField(
                        controller: _ktpController,
                        labelText: 'Nomor KTP',
                        keyboardType: TextInputType.number,
                        maxLength: 16,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Isi nomor KTP Anda';
                          }

                          if (value.length < 16) {
                            return 'Nomor KTP harus 16 digit';
                          }

                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildKtpImageInput(),
                const SizedBox(height: 8),
                _buildSelfieImageInput(),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OtpScreen(
                              login: false,
                              phoneNumber: widget.phoneNumber,
                              fullName: _nameController.text,
                              ktpNumber: _ktpController.text,
                            )));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade300,
                    foregroundColor: Colors.grey.shade900,
                    elevation: 2,
                  ),
                  child: const Text('Daftar'),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKtpImageInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Foto KTP'),
        _ktpImage == null
            ? ElevatedButton(
                onPressed: () => _pickKtpImage(),
                child: const Text('Pilih foto'),
              )
            : const SizedBox.shrink(),
        _ktpImage != null
            ? InkWell(
                onTap: () => _pickKtpImage(),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                  child: Image.file(_ktpImage!),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildSelfieImageInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Foto Selfie'),
        _selfieImage == null
            ? ElevatedButton(
                onPressed: () => _pickSelfieImage(),
                child: const Text('Pilih foto'),
              )
            : const SizedBox.shrink(),
        _selfieImage != null
            ? InkWell(
                onTap: () => _pickSelfieImage(),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(32, 8, 32, 8),
                  child: Image.file(_selfieImage!),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  String? _validateEmpty(String? value, String error) {
    if (value == null || value.isEmpty) {
      return error;
    }

    return null;
  }

  void _pickKtpImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() => _ktpImage = File(image.path));
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  void _pickSelfieImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() => _selfieImage = File(image.path));
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }
}
