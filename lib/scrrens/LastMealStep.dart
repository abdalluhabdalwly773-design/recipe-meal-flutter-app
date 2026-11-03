import 'package:dsain/dummy.dart';
import 'package:dsain/scrrens/LoadingScreen.dart';
import 'package:dsain/utils/constants.dart';
import 'package:dsain/widget/customElevatedButton.dart';
import 'package:dsain/widget/custom_button.dart';
import 'package:dsain/widget/custom_step_app_bar.dart';
import 'package:flutter/material.dart';

class LastMealStep extends StatefulWidget {
  static const routname = "/LastMealStep";
  // final String? selectedMeal;
  // const LastMealStep({super.key, this.selectedMeal});

  @override
  State<LastMealStep> createState() => _LastMealStepState();
}

class _LastMealStepState extends State<LastMealStep> {
  String? _lastEatenCategoryId; // لحفظ الفئة التي سيتم استبعادها
   Map<String,dynamic>? args;
   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ هنا فقط
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null) {
      args = {};
    }
    print("📦 LastMealStep - args: $args");
  }
  @override
  Widget build(BuildContext context) {
  
    final String? locations = args?['location'];
    final String? moods = args?['mood'];
    final String? stomachStatus = args?['stomachStatus'];
    final String? budget = args?['budget'];
    final String? excluded = args?['excludedCategory'];

    return Scaffold(
      appBar: CustomStepAppBar(text: "الخطوة 5 من 5"),
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
                  value: 1.0,
                  minHeight: 5,
                  backgroundColor: AppColors.greyLight,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: AppDimens.paddingLarge),
            const Text(
              "أخر وجبه أكلته ايش كانت",
              style: AppTextStyles.heading2,
            ),
            SizedBox(height: AppDimens.paddingLarge),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 3.50,
                  ),
                  itemCount: DUMMY_CATEGORIES.length,
                  itemBuilder: (context, index) {
                    final cat = DUMMY_CATEGORIES[index];
                    return CustomButton(
                      title: cat.title,
                      icon: cat.icon, // يمكنك إضافة إيموجي لكل فئة لو أردت
                      isSelected: _lastEatenCategoryId == cat.id,
                      onPressed: () {
                        setState(() {
                          _lastEatenCategoryId = cat.id;
                        });
                      },
                    );
                  },
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Customelevatedbutton(
                    text: " <--   التالي",
                    onpressed: _lastEatenCategoryId == null
                        ? null
                        : () {
                            print("📦 LastMealStep - args قبل الإضافة: $args");
                            print(
                              "📦 LastMealStep - excludedCategory المضاف: $_lastEatenCategoryId",
                            );

                            final newArgs = {
                              ...args!,
                              'excludedCategory': _lastEatenCategoryId,
                            };

                            print(
                              "📦 LastMealStep - args بعد الإضافة: $newArgs",
                            );

                            Navigator.of(context).pushNamed(
                              Loadingscreen.routName,
                              arguments: newArgs,
                            );
                          },
                  ),
                ),
                Expanded(
                  child: Customelevatedbutton(
                    text: " رجوع   -->",
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

