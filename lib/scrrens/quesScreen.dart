
import 'package:dsain/utils/constants.dart';
import 'package:flutter/material.dart';
import '../widget/customElevatedButton.dart';
import '../widget/custom_button.dart';
import '../widget/custom_step_app_bar.dart';
import 'Moody_Screen.dart';

class Quesscreen extends StatefulWidget {
  static const routname = "/Quesscreen";
  const Quesscreen({super.key});

  @override
  State<Quesscreen> createState() => _QuesscreenState();
}

class _QuesscreenState extends State<Quesscreen> {
  String? selectedLocation;
  @override
  Widget build(BuildContext context) {
    // final List<Meal> displayMeals = DUMMY_MEALS.where((meal) {
    //   if (selectedLocation == null || selectedLocation!.isEmpty) {
    //     return true;
    //   }
    //   return meal.location == selectedLocation;
    // }).toList();
    return Scaffold(
      appBar: CustomStepAppBar(text: "الخطوة 1 من 5"),

      body: Padding(
        padding: EdgeInsetsGeometry.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: AppDimens.paddingMedium),
            Directionality(
              textDirection:
                  TextDirection.rtl, // هذا سيجعل التقدم يبدأ من اليمين
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppDimens.paddingSmall,
                ), // استخدام الثوابت
                child: LinearProgressIndicator(
                  value: 0.2, // الخطوة الأولى
                  minHeight: 5,
                  backgroundColor: AppColors.greyLight,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: AppDimens.paddingLarge),
            const Text("انت فين دلوقتي؟", style: AppTextStyles.heading2),
            SizedBox(height: AppDimens.paddingLarge),

            CustomButton(
              isSelected: selectedLocation == "في البيت",
              onPressed: () {
                setState(() {
                  selectedLocation = "في البيت";
                });
              },
              icon: "🏠",
              title: "في البيت",
            ),
            CustomButton(
              isSelected: selectedLocation == 'في الشغل',
              onPressed: () {
                setState(() {
                  selectedLocation = 'في الشغل';
                });
              },
              icon: "🏢",
              title: 'في الشغل',
            ),
            CustomButton(
              isSelected: selectedLocation == "مع أصحابي",
              onPressed: () {
                setState(() {
                  selectedLocation = "مع أصحابي";
                });
              },
              title: "مع أصحابي",
              icon: "🎮",
            ),
            Spacer(),
            Customelevatedbutton(
              text: " <--   التالي",
              width: double.infinity,
              onpressed: () {
                Navigator.of(context).pushNamed(
                  moodyScreen.routname,
                  arguments: {
                    'location': selectedLocation, // ✅ تمرير Map بدلاً من String
                  },
                );
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
