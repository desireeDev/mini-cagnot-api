import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cagnotte_app/widgets/primary_button.dart';
import 'signup_screen.dart'; // écran de création de compte
import 'login_screen.dart'; // écran de connexion

class LoginSignupScreen extends StatelessWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 375.w,
            height: 812.h,
            child: Stack(
              children: [
                // Cercles décoratifs
                Positioned(
                  top: -120.h,
                  left: -155.w,
                  child: Container(
                    width: 734.w,
                    height: 734.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF3F4F5),
                    ),
                  ),
                ),
                Positioned(
                  top: -137.h,
                  left: -180.w,
                  child: Container(
                    width: 734.w,
                    height: 734.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                // Logo
                Positioned(
                  top: 212.h,
                  left: 134.w,
                  child: SizedBox(
                    width: 106.w,
                    height: 137.h,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Image.asset('assets/images/Logo.png'),
                    ),
                  ),
                ),
                // Texte descriptif adapté pour la mini cagnotte
                Positioned(
                  top: 464.h,
                  width: 375.w,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w300,
                        ),
                        children: const [
                          TextSpan(text: "Gagnez des points et suivez votre"),
                          TextSpan(
                              text: ' cagnotte ',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          TextSpan(text: "facilement à chaque paiement"),
                        ],
                      ),
                    ),
                  ),
                ),
                // Bouton "Créer un compte"
                Positioned(
                  top: 686.h,
                  width: 375.w,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: PrimaryButton(
                      text: "Créer un nouveau compte",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()),
                        );
                      },
                    ),
                  ),
                ),
                // Bouton "Already have account?"
                Positioned(
                  top: 759.h,
                  width: 375.w,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      "Already have account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
