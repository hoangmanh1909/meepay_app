import 'package:flutter/material.dart';
import 'package:meepay_app/view/account/login_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:meepay_app/view/account/otp_mp_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeePay',
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      supportedLocales: const [
        Locale('vi', ''),
      ],
      home: const LoginView(),
    );
  }
}
