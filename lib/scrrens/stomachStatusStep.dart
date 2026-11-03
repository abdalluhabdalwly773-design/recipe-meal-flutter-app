import 'package:dsain/utils/constants.dart';
import 'package:flutter/material.dart';

import '../widget/customElevatedButton.dart';
import '../widget/custom_button.dart';
import '../widget/custom_step_app_bar.dart';
import 'Budget_selection.dart';

class Stomachstatusstep extends StatefulWidget {
  static const routname = "/Stomachstatusstep";
  const Stomachstatusstep({super.key});

  @override
  State<Stomachstatusstep> createState() => _StomachstatusstepState();
}

class _StomachstatusstepState extends State<Stomachstatusstep> {
  // 1. تعريف المتغير لحفظ اختيار "حالة المعدة"
  String? _selectedStomachStatus;
  Map<String,dynamic>? args;
    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ هنا فقط
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print("📦 Stomachstatusstep - args: $args");
  }
  @override
  Widget build(BuildContext context) {
    final String? locations = args?['location'];
    final String? moods = args?['mood'];

    return Scaffold(
      appBar: CustomStepAppBar(text: "الخطوة 3 من 5"),
      body: Padding(
        padding: EdgeInsetsGeometry.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: AppDimens.paddingMedium),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.paddingSmall),
                child: LinearProgressIndicator(
                  value: 0.6,
                  minHeight: 5,
                  backgroundColor: AppColors.greyLight,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: AppDimens.paddingLarge),
            const Text("ماذا تخبرك معدتك الآن", style: AppTextStyles.heading2),
            SizedBox(height: AppDimens.paddingLarge),
            CustomButton(
              icon: "🥤",
              title: 'أرغب في شرب',
              isSelected: _selectedStomachStatus == 'أرغب في شرب',
              onPressed: () =>
                  setState(() => _selectedStomachStatus = 'أرغب في شرب'),
            ),
            CustomButton(
              icon: "🍕",
              title: 'أرغب في الأكل',
              isSelected: _selectedStomachStatus == 'أرغب في الأكل',
              onPressed: () {
                setState(() {
                  _selectedStomachStatus = 'أرغب في الأكل';
                });
              },
            ),
            CustomButton(
              icon: "🧁",
              title: "أرغب أحلي",
              isSelected: _selectedStomachStatus == "أرغب أحلي",
              onPressed: () {
                setState(() {
                  _selectedStomachStatus = "أرغب أحلي";
                });
              },
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: Customelevatedbutton(
                    text: " <-- التالي",
                    onpressed: _selectedStomachStatus == null
                        ? null
                        : () {
                            Navigator.of(context).pushNamed(
                              BudgetSelection.routname,
                              arguments: {
                                'location': locations,
                                'mood': moods,
                                'stomachStatus': _selectedStomachStatus,
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
