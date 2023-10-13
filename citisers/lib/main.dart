import 'package:citisers/pages/home_page.dart';
import 'package:citisers/pages/number_page.dart';
import 'package:citisers/pages/otp_page.dart';
import 'package:citisers/pages/setting.dart';
import 'package:citisers/utils/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(main_page());
}

class main_page extends StatefulWidget {
  const main_page({super.key});

  @override
  State<main_page> createState() => _main_pageState();
}

class _main_pageState extends State<main_page> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, _) {
          return MaterialApp(
            theme: themeModel.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            debugShowCheckedModeBanner: false,
            initialRoute: 'number_page',
            routes: {
              'number_page': (context) => number_page(),
              'otp_page': (context) => otp_page(),
              'home_page': (context) => home_page(),
              'setting_page': (context) => setting_page(),
            },
          );
        },
      ),
    );
  }
}
