

import 'dart:async';
import 'package:dsain/dummy.dart';
import 'package:dsain/model/meal.dart';
import 'package:dsain/scrrens/NewResultScreen.dart';
import 'package:flutter/material.dart';


class Loadingscreen extends StatefulWidget {
  static const routName ="/Loadingscreen";
  const Loadingscreen({super.key});
   
  @override
  State<Loadingscreen> createState() => _SuggestionsLoadingScreenState();
}

class _SuggestionsLoadingScreenState extends State<Loadingscreen> {
Map<String, dynamic>? args;
  bool _hasNavigated = false; // ✅ لمنع التنقل المتكرر
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // ✅ هنا يمكن الوصول إلى ModalRoute بأمان
    if (!_hasNavigated) {
      args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      
      print("📦 Loadingscreen - المعاملات المستلمة: $args");
      print("📦 Loadingscreen - location: ${args?['location']}");
      print("📦 Loadingscreen - mood: ${args?['mood']}");
      print("📦 Loadingscreen - excludedCategory: ${args?['excludedCategory']}");
      
      _hasNavigated = true;
      
      // ✅ بدء الـ Timer
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacementNamed(
            context, 
            Newresultscreen.routname,
            arguments: args,
          );
        }
      });
    }
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

   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            // الصفوف القابلة للتمرير
            _buildFoodIcon(context,DUMMY_CATEGORIES),
             SizedBox(height: 40,),
            //  const Spacer(),
               
               const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "جاري تحضير قائمة الطعام التي ستجعلك تنسى الحمية الغذائية...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ) ),
    );
  }
}