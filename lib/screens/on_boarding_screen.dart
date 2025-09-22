import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cagnotte_app/screens/home_screen.dart';
import 'package:cagnotte_app/screens/login_signup_screen.dart';
import 'package:cagnotte_app/widgets/horizontal_spacer.dart';
import 'package:cagnotte_app/widgets/primary_button.dart';
import 'package:cagnotte_app/widgets/vertical_spacer.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<OnBoardingTemplateData> pages = [
    OnBoardingTemplateData(
      title: "Gagnez des points à chaque paiement",
      description:
          "Effectuez vos achats et accumulez automatiquement des points pour chaque transaction.",
      image: "illustration-1",
    ),
    OnBoardingTemplateData(
      title: "Suivez votre cagnotte en temps réel",
      description:
          "Visualisez vos points accumulés, vos transactions et votre progression vers vos récompenses.",
      image: "illustration-2",
    ),
    OnBoardingTemplateData(
      title: "Échangez vos points facilement",
      description:
          "Convertissez vos points en cadeaux, réductions ou offres exclusives, directement depuis l’application.",
      image: "illustration-3",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != currentPage) {
        setState(() => currentPage = newPage);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToLoginSignup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginSignupScreen()),
    );
  }

  void _goToHome() {
    // Magouille : customerId fictif pour test
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(customerId: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              final page = pages[index];
              return OnBoardingTemplate(
                title: page.title,
                description: page.description,
                image: page.image,
                index: index + 1,
                currentIndex: currentPage,
              );
            },
          ),
          // Header avec pagination et bouton "Passer"
          Positioned(
            top: 32.h,
            left: 0,
            right: 0,
            child: OnBoardingHeader(
              index: currentPage + 1,
              onSkip: _goToHome,
            ),
          ),
          // Bouton "Commencer" seulement sur la dernière page
          if (currentPage == pages.length - 1)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 32.h),
                child: PrimaryButton(
                  text: "Commencer",
                  onPressed: _goToLoginSignup,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OnBoardingHeader extends StatelessWidget {
  const OnBoardingHeader({Key? key, required this.index, this.onSkip})
      : super(key: key);

  final int index;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '$index/3',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            index != 3
                ? InkWell(
                    onTap: onSkip,
                    child: Text(
                      'Passer',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class OnBoardingTemplateData {
  final String title;
  final String description;
  final String image;

  OnBoardingTemplateData({
    required this.title,
    required this.description,
    required this.image,
  });
}

class OnBoardingTemplate extends StatelessWidget {
  const OnBoardingTemplate({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.index,
    required this.currentIndex,
  }) : super(key: key);

  final String title;
  final String description;
  final String image;
  final int index;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 375.w,
          height: 279.42.h,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Image.asset('assets/images/$image.png'),
          ),
        ),
        const VerticalSpacer(height: 65),
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const VerticalSpacer(height: 8),
        SizedBox(
          width: 240.w,
          child: Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1A1A1A).withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const VerticalSpacer(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++) ...[
              PageViewButton(isActive: i == currentIndex),
              const HorizontalSpacer(width: 8),
            ]
          ],
        ),
      ],
    );
  }
}

class PageViewButton extends StatelessWidget {
  const PageViewButton({Key? key, this.isActive = false}) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.h,
      width: 15.w,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(35.w),
      ),
    );
  }
}
