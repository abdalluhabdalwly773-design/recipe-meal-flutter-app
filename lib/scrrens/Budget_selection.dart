import 'package:dsain/scrrens/LastMealStep.dart';
import 'package:dsain/utils/constants.dart';
import 'package:dsain/widget/customElevatedButton.dart';
import 'package:flutter/material.dart';
import '../widget/custom_button.dart';
import '../widget/custom_step_app_bar.dart';

class BudgetSelection extends StatefulWidget {
  static const routname = "/BudgetSelection";
  const BudgetSelection({super.key});

  @override
  State<BudgetSelection> createState() => _BudgetSelectionState();
}

class _BudgetSelectionState extends State<BudgetSelection> {
  // 1. متغير لحفظ الميزانية المختارة
  String? _selectedBudget;
  Map<String,dynamic>? args;
    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ هنا فقط
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print("📦 BudgetSelection - args: $args");
  }
  @override
  Widget build(BuildContext context) {
    final String? locations = args?['location'];
    final String? moods = args?['mood'];
    final String? stomachStatus = args?['stomachStatus'];

    return Scaffold(
      appBar: CustomStepAppBar(
        text: "الخطوة 4 من 5",
        showExitDialogs: true,
        onItemSelected: (navigator) {
          navigator.pushReplacementNamed('/');
        },
      ),
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
                  value: 0.8,
                  minHeight: 5,
                  backgroundColor: AppColors.greyLight,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: AppDimens.paddingLarge),
            const Text("كم ميزانيتك الان", style: AppTextStyles.heading2),
            SizedBox(height: AppDimens.paddingLarge),
            CustomButton(
              icon: "💸",
              title: 'تحت 3500 يمني',
              isSelected: _selectedBudget == 'تحت 3500 يمني',
              onPressed: () {
                setState(() {
                  _selectedBudget = 'تحت 3500 يمني';
                });
              },
            ),
            CustomButton(
              icon: "💵",
              title: "يمني 3500-7000",
              isSelected: _selectedBudget == "يمني 3500-7000",
              onPressed: () {
                setState(() {
                  _selectedBudget = "يمني 3500-7000";
                });
              },
            ),
            CustomButton(
              icon: "🤷‍♂️",
              title: "ليست مهم السعر",
              isSelected: _selectedBudget == "ليست مهم السعر",
              onPressed: () {
                setState(() {
                  _selectedBudget = "ليست مهم السعر";
                });
              },
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: Customelevatedbutton(
                    text: " <-- التالي",
                    onpressed: _selectedBudget == null
                        ? null
                        : () {
                            Navigator.of(context).pushNamed(
                              LastMealStep.routname,
                              arguments: {
                                'location': locations,
                                'mood': moods,
                                'stomachStatus': stomachStatus,
                                'budget': _selectedBudget,
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

// في صفحة النتائج (الخطوة الأخيرة)
// final displayMeals = DUMMY_MEALS.where((meal) {
//   return meal.location == selectedLocation && 
//          meal.mood == selectedMood &&
//          meal.hungerType == selectedStomach;
// }).toList();

// // إذا كانت القائمة فارغة، اعرض رسالة لطيفة أو اقتراحات عامة
// if (displayMeals.isEmpty) {
//   return Center(
//     child: Text("يا فندم، حالياً مفيش مشروب يطابق مزاجك، جرب تختار 'أرغب في الأكل'!"),
//   );
// }