import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'on_boarding_screen.dart'; // Assurez-vous d'importer votre écran Onboarding

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Attendre 30 secondes puis naviguer vers OnboardingScreen
    Future.delayed(const Duration(seconds: 20), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SizedBox(
          width: 106.w,
          height: 137.h,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Image.asset('assets/images/Logo.png'),
          ),
        ),
      ),
    );
  }
}
