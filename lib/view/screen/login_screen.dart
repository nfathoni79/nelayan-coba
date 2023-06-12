import 'package:flutter/material.dart';
import 'package:nelayan_coba/view/screen/register_screen.dart';
import 'package:nelayan_coba/view/widget/my_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
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
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32),
                child: Image.asset(
                  'assets/images/perindo_nelayan.png',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Selamat Datang,',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const Text(
                'Masuk ke Akun Anda',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 24),
              const MyTextFormField(
                labelText: 'Nomor Ponsel',
                prefixText: '+62',
                keyboardType: TextInputType.number,
                maxLength: 12,
              ),
              const SizedBox(height: 16),
              const Text('Kami akan mengirimi pesan SMS untuk memverifikasi nomor ponsel Anda.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RegisterScreen())
                ),
                child: const Text('Masuk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}