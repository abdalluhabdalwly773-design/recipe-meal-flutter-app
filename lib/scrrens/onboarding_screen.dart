import 'package:dsain/dummy.dart';
import 'package:dsain/model/meal.dart';
import 'package:dsain/scrrens/FavoritesScreen.dart';
import 'package:dsain/scrrens/NewResultScreen.dart';
import 'package:dsain/scrrens/quesScreen.dart';
import 'package:dsain/utils/constants.dart';
import 'package:flutter/material.dart';
// import 'dart:math';

class OnboardingScreen extends StatefulWidget {
  static const routname = " /OnboardingScreen";
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

// 1. تعديل الدالة لتصبح مرنة بالكامل وتعتمد على العرض المتاح بدلاً من الارتفاع الثابت الصارم
Widget _buildFoodIcon(BuildContext context, List<Category> categories) {
  final double screenWidth = MediaQuery.of(context).size.width;
  
  // تحديد عدد الأعمدة (الصفوف الأفقية) ديناميكياً حسب عرض الشاشة
  // إذا كانت الشاشة عريضة (تابلت) نزيد الارتفاع المتاح، وإذا كانت صغيرة (جوال) نجعله متناسباً
  final double gridHeight = screenWidth > 600 ? 260 : 180;

  return SizedBox(
    height: gridHeight,
    width: double.infinity,
    child: GridView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(), // يعطي نعومة أثناء التمرير
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: screenWidth > 600 ? 2 : 2, // في التابلت نجعلها صفين لتكبر الأيقونات، وفي الجوال 3 صفوف
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.9, // مربع كامل متناسق
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // حجم الأيقونة يتكيف 100% مع حجم المربع المتاح له على أي شاشة
                return Text(
                  category.icon, 
                  style: TextStyle(fontSize: constraints.maxWidth * 0.55),
                );
              },
            ),
          ),
        );
      },
    ),
  );
}  
class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(FavoritesScreen.routname);
              },
              child: Row(
                children: [
                  Text(
                    " الأكلات المفضلة",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Icon(Icons.favorite_border, color: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildFoodIcon(context,DUMMY_CATEGORIES),
            
                Padding(
                  padding: EdgeInsetsGeometry.all(15),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "هل تحتار في اختيار وجبتك",
                          style: AppTextStyles.heading1,
                        ),
                      ),
                      SizedBox(height: AppDimens.paddingSmall),
                      Text(
                        "دع الأمر لنا، سنقترح عليك الوجبة المثالية التي تناسب ذوقك وحالتك الآن",
                        style: AppTextStyles.bodyText,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppDimens.iconSize),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {
                          Navigator.of(context).pushNamed(Quesscreen.routname);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          alignment: AlignmentGeometry.center,
                          width: double.infinity,
                          child: Text(
                            "<-- ابدأ الاختيار",
                            style: AppTextStyles.buttonText,
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimens.borderRadius),
            
                      TextButton.icon(
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
                        icon: Icon(
                          Icons.auto_awesome,
                          size: 15,
                          color: AppColors.primary,
                        ),
                        label: Text(
                          "اختيار أكلة عشوائية",
                          style: AppTextStyles.button,
                        ),
                      ),
                    ],
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
