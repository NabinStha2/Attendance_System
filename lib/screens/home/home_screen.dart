import 'package:attendance_system/core/app/states.dart';
import 'package:attendance_system/provider/home_provider.dart';
import 'package:attendance_system/screens/calendar/calendar_screen.dart';
import 'package:attendance_system/screens/datagrid/datagrid_screen.dart';
import 'package:attendance_system/screens/home/components/home_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../provider/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Consumer<HomeProvider>(
        builder: (context, _, child) => Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _.homeBottomindex,
            onTap: (ind) {
              _.changeHomeBottomIndex(ind);
            },
            items: const [
              BottomNavigationBarItem(
                label: "Home",
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: "Attendance",
                icon: Icon(Icons.calendar_month_rounded),
              ),
              BottomNavigationBarItem(
                label: "DataGrid",
                icon: Icon(Icons.table_view_rounded),
              ),
            ],
          ),
          appBar: AppBar(
            title: const Text(MyApp.title),
            elevation: 4.0,
            actions: [
              Consumer<ThemeProvider>(
                builder: (context, __, child) => Switch.adaptive(
                  value: __.isDarkTheme,
                  onChanged: (val) {
                    __.darkTheme = val;
                    themeBox?.put("isDarkTheme", val);
                  },
                  activeThumbImage: const AssetImage(
                    "assets/images/dark_theme.png",
                  ),
                  inactiveThumbImage: const AssetImage(
                    "assets/images/light_theme.png",
                  ),
                ),
              ),
            ],
          ),
          body: IndexedStack(
            index: _.homeBottomindex,
            children: const [
              HomeBody(),
              CalendarScreen(),
              DataGridScreen(),
            ],
          ),
        ),
      );
}
