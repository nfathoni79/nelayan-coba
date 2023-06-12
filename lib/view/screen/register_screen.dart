import 'package:flutter/material.dart';
import 'package:nelayan_coba/view/screen/otp_screen.dart';
import 'package:nelayan_coba/view/widget/my_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

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
              colors: <Color>[
                Colors.blue.shade50,
                Colors.blue.shade200,
                Colors.blue.shade600,
              ],
            )
        ),
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
                const SizedBox(height: 16),
                const MyTextFormField(
                  labelText: 'Nomor Ponsel',
                  prefixText: '+62',
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                  textInputAction: TextInputAction.next,
                ),
                const MyTextFormField(
                  labelText: 'Nama Lengkap',
                  keyboardType: TextInputType.name,
                  maxLength: 50,
                  textInputAction: TextInputAction.next,
                ),
                const MyTextFormField(
                  labelText: 'Nomor KTP',
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const OtpScreen())
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
}