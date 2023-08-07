import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nelayan_coba/app/locator.dart';
import 'package:nelayan_coba/view/screen/home_screen.dart';
import 'package:nelayan_coba/view/screen/intro_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  setupLocator();

  Widget home = const HomeScreen();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (prefs.getString('accessToken') == null) {
    home = const IntroScreen();
  }

  runApp(MyApp(home: home));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.home,
  });

  final Widget home;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nelayan Coba',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          // primary: Colors.blue,
          onPrimary: Colors.blue.shade100,
        ),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}
