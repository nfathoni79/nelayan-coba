import 'package:flutter/material.dart';
import 'package:nelayan_coba/view/screen/home_screen.dart';
import 'package:nelayan_coba/view/screen/register_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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
              const Text(
                'Verifikasi',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Masukkan kode OTP yang telah dikirimkan melalui SMS.'),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false,
                ),
                child: const Text('Verifikasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}