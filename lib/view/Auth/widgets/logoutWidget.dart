import 'package:bid4style/view/FirstPage.dart';
import 'package:bid4style/viewModal/AuthviewModel/logoutViewModel.dart';
import 'package:bid4style/widgets/ButtonWidget.dart' show ButtonWidget;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class logoutwidget extends StatelessWidget {
  const logoutwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Logoutviewmodel(),
      child: Consumer<Logoutviewmodel>(
        builder: (context, logoutViewModel, child) {
          return ButtonWidget(
            name: "Logout",
            loading: logoutViewModel.isLoading,
            ontap: () async {
              final success = await logoutViewModel.appDataLogout(context);
              if (success && context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const FirstPage()),
                );
              }
            },
          );
        },
      ),
    );
  }
}
