
import 'package:dsain/dummy.dart';
import 'package:dsain/model/meal.dart';
import 'package:dsain/scrrens/NewResultScreen.dart';
import 'package:dsain/utils/constants.dart';
import 'package:flutter/material.dart';

class  CustomStepAppBar extends StatelessWidget implements PreferredSizeWidget  {
  final String text;
 final Function(NavigatorState)? onItemSelected;
   final bool showExitDialogs;
  const CustomStepAppBar({super.key, required this.text, this.onItemSelected,  this.showExitDialogs =false});

void showExitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.exit_to_app_rounded, color: AppColors.primary, size: 50),
          const SizedBox(height: 20),
          const Text("لحظة من فضلك! هل تود المغادرة؟", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          const Text("إذا خرجت الآن ستفقد كافة البيانات التي أدخلتها. هل أنت متأكد؟",
            style: TextStyle(color: Colors.grey, fontSize: 14), textAlign: TextAlign.center),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () {
                      Navigator.pop(context); // إغلاق الرسالة
                      if (onItemSelected != null) {
                        onItemSelected!(Navigator.of(context));
                      } else {
                        Navigator.pop(context); // الرجوع للشاشة السابقة
                      }
                    },
                    child: const Text("نعم، أريد الخروج"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("لا، أكمل"),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 300,
        leading: Container(
          margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Color(0xFFCCCCCC), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
             onPressed: () {
                    List<Meal> randomList = List.from(DUMMY_MEALS);
                    randomList.shuffle();
                    List<Meal> selectedMeals = randomList.take(3).toList();

                    Navigator.of(context).pushNamed(
                      Newresultscreen.routname,
                      // نرسل الخريطة بالشكل الذي تتوقعه الشاشة تماماً
                      arguments: {
                        'isRandom': true, // علامة لكي تعرف الشاشة أن هذا عشوائي
                        'randomData': selectedMeals, // نضع الوجبات داخل الخريطة
                      },
                    );
                  },
            child: Text(
              "اختيار أكلة عشوائي",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
              if (showExitDialogs) {
                // إذا كان showExitDialog = true، أظهر الرسالة
                showExitDialog(context);
              } else {
                // إذا كان showExitDialog = false، ارجع مباشرة
                if (onItemSelected != null) {
                  onItemSelected!(Navigator.of(context));
                } else {
                  Navigator.pop(context);
                }
              }
            },
            ),
          ),
        ],
        title: Text(
          text,
          style: AppTextStyles.bodyText.copyWith(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        centerTitle: true,
      );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}