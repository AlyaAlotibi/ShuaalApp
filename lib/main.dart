import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shuaalapp/Pages/Home/home_screen.dart';
import 'package:shuaalapp/utils/colors.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Pages/Auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      locale: const Locale('ar'),
      theme: ThemeData(
        primarySwatch: createMaterialColor(primary),
      ),
      home: const SplashScreen(),
    );
  }

  createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((sp) =>
        Future.delayed(const Duration(seconds: 4)).then((value) =>
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => sp.getString('uid') != null
                        ? const HomeScreen()
                        : const Login()),
                    (route) => false)));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
      backgroundColor: HexColor('#EEEEEE'),
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            width: double.infinity,
            child: Image.asset(
              "assets/images/corner.png",
              width: 200,
            ),
          ),
          Image.asset(
            "assets/images/logo.png",
            width: 200,
          ),
          Image.asset(
            "assets/images/logo_text.png",
            width: 200,
          ),
        ],
      ),
    );
  }
}
