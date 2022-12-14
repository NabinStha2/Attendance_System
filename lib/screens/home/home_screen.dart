import 'package:flutter/material.dart';

import '../../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(MyApp.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Home',
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 48),
                buildLogoutButton(context)
              ],
            ),
          ),
        ),
      );

  Widget buildLogoutButton(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FingerPrintPage()));
        },
      );
}
