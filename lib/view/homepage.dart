import 'package:bid4style/services/session_manager.dart';
import 'package:bid4style/view/FirstPage.dart';
import 'package:bid4style/widgets/ButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Welcome to the Homepage!')),

          ButtonWidget(
            name: "Logout",
            ontap: () {
              SharedPreferencesHelper.clearAllData();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const FirstPage()),
              );
              // Navigator.pushNamed(context, '/first');
            },
          ),
        ],
      ),
    );
  }
}
