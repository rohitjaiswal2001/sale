import 'dart:io';

import 'package:bid4style/services/session_manager.dart';
import 'package:bid4style/utils/Appcolor.dart';
import 'package:bid4style/view/homepage.dart';

import 'package:bid4style/viewModal/AuthviewModel/SignupViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'view/FirstPage.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // Allow all certificates
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase Setup

  try {
    // await checkPlayServices(); // Add this line
    // await Firebase.initializeApp();
    // await FireBaseSetup().initNotification();
  } catch (e) {
    print('Firebase initialization error: $e');
    // Handle the error appropriately
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, // Optional
  ]);

  // Determine the initial route
  String initialRoute = await getInitialRoute();
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MainApp(initialRoute: initialRoute),

    // MultiProvider(
    //   providers: [
    //     // ChangeNotifierProvider(create: (context) => LoginViewModel()),
    //     // ChangeNotifierProvider(create: (context) => SignupViewModel()),
    //     // // ChangeNotifierProvider(create: (context) => ForgotPasswordViewModel()),
    //     // ChangeNotifierProvider(create: (context) => ChoosePlanViewModel()),
    //     // // ChangeNotifierProvider(create: (context) => HelpViewmodal()),
    //     // // ChangeNotifierProvider(create: (context) => UpdateAccountViewModel()),
    //     // ChangeNotifierProvider(create: (context) => AddJournalViewModel()),
    //     // ChangeNotifierProvider(create: (context) => Homepageviewmodal()),
    //     // ChangeNotifierProvider(create: (context) => Userdetailviewmodel()),
    //     // // ChangeNotifierProvider(create: (context) => DetailsViewModal()),
    //     // ChangeNotifierProvider(create: (context) => UpdateProfileViewModel()),
    //     // // ChangeNotifierProvider(create: (context) => RenameJournalViewModel()),
    //     // ChangeNotifierProvider(create: (context) => ViewJournalViewModal()),
    //     // ChangeNotifierProvider(create: (context) => ShareViewModal()),
    //     // ChangeNotifierProvider(create: (context) => FolderViewmodel()),
    //     // ChangeNotifierProvider(create: (context) => FolderDetailViewModel()),
    //     // ChangeNotifierProvider(create: (context) => FolderSearchViewModel()),
    //     // ChangeNotifierProvider(create: (context) => SharedJournalViewModel()),
    //     // // ChangeNotifierProvider(create: (context) => PrivacyPolicyViewModel()),
    //     // ChangeNotifierProvider(create: (context) => JournalSearchViewModel()),
    //     // ChangeNotifierProvider(create: (context) => AudioAnimationViewModel()),
    //     // ChangeNotifierProvider(create: (context) => Subscriptionviewmodal()),
    //     // ChangeNotifierProvider(create: (context) => ResumeViewModel()),
    //     // ChangeNotifierProvider(create: (context) => Requestplanviewmodal()),
    //     // ChangeNotifierProvider(create: (context) => SharedFolderViewModel()),

    //     // // ChangeNotifierProvider(create: (context) => ActivityProvider()),
    //   ],
    //   child: MainApp(initialRoute: initialRoute),
    // ),
  );
}

class MainApp extends StatelessWidget {
  final String initialRoute;

  const MainApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        // statusBarColor: Colors.grey, // Grey background for the status bar
        statusBarIconBrightness: Brightness.dark, // Black text/icons
        statusBarBrightness: Brightness.light, // Adjust for iOS
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      darkTheme: ThemeData.light(), // Ensure darkTheme is also lightTheme
      themeMode: ThemeMode.light, // Always use light theme

      theme: ThemeData(
        primaryColor: AppColors.themecolor,
        colorScheme: ColorScheme.light(
          primary: Colors.orange, // Selected date highlight
          onPrimary: Colors.white, // Text/icon color on selected date
        ),
        primarySwatch: Colors.orange,
        textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Color(0xFFEA6920),
          cursorColor: Color(0xFFEA6920),
          selectionColor: Color(0xFFEA6920),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColors.themecolor, // Button color
          textTheme: ButtonTextTheme.primary, // Text color in buttons
        ),
        canvasColor: AppColors.themecolor,
      ),
      highContrastDarkTheme: ThemeData.light(),
      highContrastTheme: ThemeData.light(),

      initialRoute: initialRoute,
      routes: {
        '/home': (context) => Homepage(),
        '/first': (context) => FirstPage(),
        // '/introtap': (context) => TapToNextImageWidget()
      },
    );
  }
}

Future<String> getInitialRoute() async {
  final String? token = await SharedPreferencesHelper.getToken();
  // final String? intro = await SharedPreferencesHelper.getString('intro');
  if (token == null) {
    // if (intro == '1') {
    return '/first';
    // }
    // return '/introtap'; // Route name for Homepage
  } else {
    return '/home'; // Route name for LoginPage
  }
}
