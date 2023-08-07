import 'package:flutter/material.dart';
import 'package:nelayan_coba/model/coba_album.dart';
import 'package:nelayan_coba/service/coba_service.dart';
import 'package:nelayan_coba/service/fishon_service.dart';
import 'package:nelayan_coba/util/my_utils.dart';
import 'package:nelayan_coba/view/screen/otp_screen.dart';
import 'package:nelayan_coba/view/screen/register_screen.dart';
import 'package:nelayan_coba/view/widget/my_text_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();

  late Future<CobaAlbum> futureAlbum;
  late Future<bool> _phoneExist;
  late Future<String> accessToken;

  @override
  void initState() {
    super.initState();
    // futureAlbum = CobaService.fetchAlbum();
    // phoneExist = FishonService.doesPhoneExist('8888413685');
    // accessToken = FishonService.getToken('u8888413685', '12345678');
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
              Form(
                key: _formKey,
                child: MyTextFormField(
                  controller: _phoneController,
                  labelText: 'Nomor Ponsel',
                  prefixText: '+62',
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                  useLoginStyle: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Isi nomor ponsel Anda';
                    }

                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                  'Kami akan mengirimi pesan SMS untuk memverifikasi nomor ponsel Anda.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  _checkIfPhoneExists(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade300,
                  foregroundColor: Colors.grey.shade900,
                  elevation: 2,
                ),
                child: const Text('Masuk'),
              ),
              // FutureBuilder<String>(
              //   future: accessToken,
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       return Text(snapshot.data!);
              //     } else if (snapshot.hasError) {
              //       return Text('${snapshot.error}');
              //     }
              //
              //     return const CircularProgressIndicator();
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkIfPhoneExists(BuildContext context) {
    MyUtils.showLoading(context);

    FishonService.doesPhoneExist(_phoneController.text).then((value) {
      Navigator.pop(context);

      if (value) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OtpScreen(
                  login: true,
                  phoneNumber: _phoneController.text,
                )));
        return;
      }

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              RegisterScreen(phoneNumber: _phoneController.text)));
    });
  }
}
