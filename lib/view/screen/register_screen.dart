import 'package:flutter/material.dart';
import 'package:nelayan_coba/util/my_utils.dart';
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmpty(String? value, String error) {
    if (value == null || value.isEmpty) {
      return error;
    }

    return null;
  }
}
