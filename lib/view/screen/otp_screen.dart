import 'package:flutter/material.dart';
import 'package:nelayan_coba/main.dart';
import 'package:nelayan_coba/service/fishon_service.dart';
import 'package:nelayan_coba/util/my_utils.dart';
import 'package:nelayan_coba/view/screen/home_screen.dart';
import 'package:nelayan_coba/view/screen/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.login,
    required this.phoneNumber,
    this.fullName,
    this.ktpNumber,
  });

  final bool login;
  final String phoneNumber;
  final String? fullName;
  final String? ktpNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => _prefs = prefs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
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
              const Text(
                  'Masukkan kode OTP yang telah dikirimkan melalui SMS.'),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  filled: true,
                  fillColor: Colors.blue.shade50,
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (widget.login) {
                    _login(context, 'u${widget.phoneNumber}', '12345678');
                    return;
                  }

                  _register(context, widget.phoneNumber, widget.fullName!, widget.ktpNumber!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade300,
                  foregroundColor: Colors.grey.shade900,
                  elevation: 2,
                ),
                child: const Text('Verifikasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login(BuildContext context, String username, String password) {
    MyUtils.showLoading(context);

    FishonService.getToken(username, password)
        .then((value) {
      Navigator.pop(context);

      _prefs.setString('accessToken', value.accessToken);
      _prefs.setString('refreshToken', value.refreshToken);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => const HomeScreen()),
            (route) => false,
      );
    }).catchError((error) {
      Navigator.pop(context);
    });
  }

  void _register(BuildContext context, String phone, String name, String ktp) {
    MyUtils.showLoading(context);

    FishonService.createUser(phone, name, ktp).then((value) {
      Navigator.pop(context);

      _login(context, 'u${widget.phoneNumber}', '12345678');
    }).catchError((error) {
      Navigator.pop(context);
      debugPrint('error register');
      debugPrint(error.toString());
    });
  }
}
