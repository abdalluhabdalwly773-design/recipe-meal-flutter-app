import 'package:dsain/scrrens/onboarding_screen.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
          Container(
            height: 60,
            width: 60,
            child: Image.asset("image/log.jpg"),
          ),

            SizedBox(height: AppDimens.paddingSmall),
            Text("مزاج", style: AppTextStyles.heading1),
            SizedBox(height: AppDimens.borderRadius),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(OnboardingScreen.routname);
              },
              child: Text(
                "هنختارلك الاكلة على مزاجك",
                style: AppTextStyles.bodyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
