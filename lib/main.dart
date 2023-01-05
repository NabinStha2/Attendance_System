import 'package:attendance_system/core/app/theme.dart';
import 'package:attendance_system/provider/home_provider.dart';
import 'package:attendance_system/provider/theme_provider.dart';
import 'package:attendance_system/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/app/states.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // Hive.registerAdapter(AttendanceModelAdapter());
  attendanceModelBox = await Hive.openBox("attendanceBox");
  await Hive.openBox("checkInOrOutBox");
  themeBox = await Hive.openBox("themeBox");

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'Time Attendance';

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()..darkTheme = themeBox?.get("isDarkTheme") ?? false),
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, _, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: title,
            theme: CustomTheme.themeData(_.isDarkTheme, context),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
