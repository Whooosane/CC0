import 'package:circleapp/view/check_invitation.dart';
import 'package:circleapp/view/screens/athentications/login_screen.dart';
import 'package:circleapp/view/screens/bottom_navigation_screen.dart';
import 'package:circleapp/view/screens/splash_screen.dart'; // Import the SplashScreen
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'controller/utils/preference_keys.dart';
import 'controller/utils/shared_preferences.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MySharedPreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (buildContext, orientation, screenType) {
        return GetMaterialApp(
          scaffoldMessengerKey: scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(useMaterial3: true),
          home: const SplashScreen(), // Set SplashScreen as the initial screen
        );
      },
    );
  }
}
