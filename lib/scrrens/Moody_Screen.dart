import 'package:dsain/scrrens/stomachStatusStep.dart';
import 'package:dsain/utils/constants.dart';
import 'package:dsain/widget/customElevatedButton.dart';
import 'package:flutter/material.dart';

import '../widget/custom_button.dart';
import '../widget/custom_step_app_bar.dart';

class moodyScreen extends StatefulWidget {
  static const routname = "/LocationSelectionScreen";
  const moodyScreen({super.key});

  @override
  State<moodyScreen> createState() =>
      _moodyScreenState();
}

class _moodyScreenState extends State<moodyScreen> {
  String? _selectedMood;
  Map<String,dynamic>? args;
    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ هنا فقط
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print("LocationSelectionScreen - args: $args");
  }
  @override
  Widget build(BuildContext context) {
    // استقبال المكان من الخطوة السابقة
    final String? selectlocation = args?['location'];

    return Scaffold(
      appBar: CustomStepAppBar(text: "الخطوة 2 من 5"),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                  value: 0.4, // الخطوة الأولى
                  minHeight: 5,
                  backgroundColor: AppColors.greyLight,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: AppDimens.paddingLarge),
            const Text(
              "ما هي حالتك المزاجيه الأن",
              style: AppTextStyles.heading2,
            ),
            SizedBox(height: AppDimens.paddingLarge),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomButton(
                      icon: "😊",
                      title: 'مبسوط',
                      isSelected: _selectedMood == 'مبسوط',
                      onPressed: () {
                        setState(() => _selectedMood = 'مبسوط');
                      },
                    ),
                    CustomButton(
                      icon: "😔",
                      title: "حزين",
                      isSelected: _selectedMood == "حزين",
                      onPressed: () {
                        setState(() => _selectedMood = "حزين");
                      },
                    ),
                    CustomButton(
                      icon: "😠",
                      title: 'غضبان',
                      isSelected: _selectedMood == 'غضبان',
                      onPressed: () {
                        setState(() => _selectedMood = 'غضبان');
                      },
                    ),
                    CustomButton(
                      icon: "🔋",
                      title: 'محتاج طاقة',
                      isSelected: _selectedMood == 'محتاج طاقة',
                      onPressed: () {
                        setState(() => _selectedMood = 'محتاج طاقة');
                      },
                    ),
                    CustomButton(
                      icon: "🤒",
                      title: 'مريض',
                      isSelected: _selectedMood == 'مريض',
                      onPressed: () {
                        setState(() => _selectedMood = 'مريض');
                      },
                    ),
                    CustomButton(
                      icon: "🥶",
                      title: 'بردان',
                      isSelected: _selectedMood == 'بردان',
                      onPressed: () {
                        setState(() => _selectedMood = 'بردان');
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppDimens.paddingMedium),
            Row(
              children: [
                Expanded(
                  child: Customelevatedbutton(
                    text: " <-- التالي ",
                    onpressed:  () {
                            Navigator.of(context).pushNamed(
                              Stomachstatusstep.routname,

                              arguments: {
                                'location': selectlocation,
                                'mood': _selectedMood,
                              },
                            );
                          },
                  ),
                ),
                Expanded(
                  child: Customelevatedbutton(
                    text: " رجوع -->",
                    onpressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
