import 'package:attendance_system/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // await storage.deleteAll(
  //   aOptions: AndroidOptions(),
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Auth App';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        // fontFamily: GoogleFonts.openSans(
        //   fontSize: 16.0,
        // ).fontFamily,
      ),
      home: HomeScreen(),
    );
  }
}