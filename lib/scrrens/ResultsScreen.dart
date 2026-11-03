// import 'package:dsain/dummy.dart';
// import 'package:dsain/utils/constants.dart';
// import 'package:dsain/widget/SuggestionsList.dart';
// import 'package:flutter/material.dart';

// class ResultsScreen extends StatefulWidget {
//   static const routname = "/ResultsScreen";
//   const ResultsScreen({super.key});

//   @override
//   State<ResultsScreen> createState() => _ResultsScreenState();
// }

// class _ResultsScreenState extends State<ResultsScreen> {
//   Widget _buildNoResult() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           margin: EdgeInsets.all(10),
//           child: Icon(
//             Icons.restaurant_menu,
//             size: 100,
//             color: Colors.grey.shade300,
//           ),
//         ),
//         SizedBox(height: AppDimens.paddingLarge),
//         Text("مزاجك فريد اليوم!", style: AppTextStyles.heading2),
//         SizedBox(height: AppDimens.paddingMedium),
//         Padding(
//           padding: EdgeInsetsGeometry.symmetric(
//             horizontal: AppDimens.paddingMedium,
//           ),
//           child: Text(
//             "للأسف لا توجد اقتراحات تطابق خياراتك حالياً، ولكن يمكننا المحاولة مجدداً مع تغيير بعض التفضيلات.",
//             textAlign: TextAlign.center,
//             style: AppTextStyles.bodyText,
//           ),
//         ),
//         SizedBox(height: AppDimens.paddingMedium),

//         Padding(
//           padding: EdgeInsetsGeometry.symmetric(horizontal: AppDimens.high100),
//           child: ElevatedButton(
//             onPressed: () => Navigator.pop(context),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(AppDimens.borderRadius),
//               ),
//             ),
//             child: Center(
//               child: Text("جرب الثاني", style: AppTextStyles.buttonText),
//             ),
//           ),
//         ),
//         SizedBox(height: AppDimens.borderRadius),
//         TextButton.icon(
//           onPressed: () {},
//           icon: Icon(Icons.auto_awesome, size: 15, color: AppColors.primary),
//           label: Text("اختيار أكلة عشوائية", style: AppTextStyles.button),
//         ),
//       ],
//     );
//   }

//   // استخراج القيمة الرقمية من نص الميزانية
//   int _extractBudgetValue(String budgetText) {
//     RegExp regExp = RegExp(r'(\d+)');
//     List<String> numbers = regExp
//         .allMatches(budgetText)
//         .map((m) => m.group(0)!)
//         .toList();

//     if (numbers.isEmpty) {
//       if (budgetText.contains("فوق")) return 100000;
//       if (budgetText.contains("تحت")) return 0;
//       return 0;
//     }

//     int maxValue = numbers.map(int.parse).reduce((a, b) => a > b ? a : b);
//     return maxValue;
//   }

//   // التحقق من أن الوجبة تحت مبلغ معين
//   bool _isUnderBudget(String mealBudget, int maxAmount) {
//     int mealValue = _extractBudgetValue(mealBudget);

//     if (mealBudget.contains("تحت") || mealBudget.contains("-")) {
//       return mealValue <= maxAmount;
//     }

//     if (mealBudget.contains("فوق")) {
//       return false;
//     }

//     return mealValue <= maxAmount;
//   }

//   // التحقق من أن الوجبة بين مبلغين
//   bool _isBudgetBetween(String mealBudget, int minAmount, int maxAmount) {
//     int mealValue = _extractBudgetValue(mealBudget);

//     if (mealBudget.contains("تحت")) {
//       return mealValue <= maxAmount;
//     }

//     if (mealBudget.contains("فوق")) {
//       return mealValue >= minAmount;
//     }

//     if (mealBudget.contains("-")) {
//       List<int> range = mealBudget
//           .split('-')
//           .map((s) => int.tryParse(s.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
//           .toList();
//       if (range.length >= 2) {
//         return (range[0] <= maxAmount && range[1] >= minAmount);
//       }
//     }

//     return mealValue >= minAmount && mealValue <= maxAmount;
//   }

//   // التحقق من أن الوجبة فوق مبلغ معين
//   bool _isAboveBudget(String mealBudget, int minAmount) {
//     int mealValue = _extractBudgetValue(mealBudget);

//     if (mealBudget.contains("فوق")) {
//       return mealValue >= minAmount;
//     }

//     if (mealBudget.contains("-")) {
//       List<int> range = mealBudget
//           .split('-')
//           .map((s) => int.tryParse(s.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
//           .toList();
//       if (range.length >= 2) {
//         return range[1] >= minAmount;
//       }
//     }

//     return mealValue >= minAmount;
//   }

//   Map<String, dynamic>? args;
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//     print("📦 ResultsScreen - args: $args");
//   }

//   @override
//   Widget build(BuildContext context) {
//     // 1. استقبال الخمسة فلاتر (الموقع، المزاج، الجوع، السعر، الاستبعاد)
//     // print("📦 ResultsScreen - المعاملات المستلمة: $args");
//     // print("📦 ResultsScreen - location: ${args?['location']}");
//     // print("📦 ResultsScreen - mood: ${args?['mood']}");
//     // print("📦 ResultsScreen - excludedCategory: ${args?['excludedCategory']}");

//     final String location = args?['location'] ?? "";
//     final String mood = args?['mood'] ?? "";
//     final String stomach = args?['stomachStatus'] ?? "";
//     final String budget = args?['budget'] ?? "الكل";
//     final String excludedCatId = args?['excludedCategory'] ?? "";

//     // 2. تطبيق الفلترة الذكية
//     final filteredMeals = DUMMY_MEALS.where((meal) {
//       bool isLocMatch;
//       if (location.isEmpty) {
//         isLocMatch = true; // إذا لم يحدد المستخدم موقعاً، اعرض كل المواقع
//       } else {
//         isLocMatch = meal.location == location;
//       }
//       bool isMoodMatch ;
//       if(mood.isEmpty){
//         isMoodMatch =true;
//       } else{
//         isMoodMatch = meal.mood == mood; 
//       }
      
//       bool isStomachMatch = meal.hungerType == stomach;
//       //  شرط الميزانية الذكي
//       bool isBudgetMatch;
//       if (budget == "الكل" ||
//           budget == "ليست مهم السعر" ||
//           budget == "مش فارقة") {
//         // إذا كان المستخدم لا يهتم بالسعر، اعرض كل الوجبات
//         isBudgetMatch = true;
//       } else if (budget == "تحت 3500 يمني") {
//         // تحت 3500 يمني: تشمل كل الوجبات التي تقل عن 3500
//         isBudgetMatch = _isUnderBudget(meal.budgetRange, 3500);
//       } else if (budget == "يمني 3500-7000") {
//         // بين 3500 و 7000
//         isBudgetMatch = _isBudgetBetween(meal.budgetRange, 3500, 7000);
//       } else if (budget == "فوق 7000 يمني") {
//         // فوق 7000
//         isBudgetMatch = _isAboveBudget(meal.budgetRange, 7000);
//       } else {
//         // مطابقة تامة
//         isBudgetMatch = meal.budgetRange == budget;
//       }

//       // شرط الاستبعاد: لا تعرض الأكلة إذا كانت من الصنف الذي أكله المستخدم مؤخراً
//       bool isNotExcluded;
//       if (excludedCatId.isEmpty) {
//         isNotExcluded = true; // كل الوجبات مقبولة (لا استبعاد)
//       } else if (excludedCatId == 'c18' || excludedCatId == 'c19') {
//         // لا تستبعد الحلويات والمشروبات إذا تم اختيارها
//         isNotExcluded = true;
//       } else {
//         isNotExcluded =
//             meal.categoryId != excludedCatId; // اذا اختار ايمن هذي الفئة استبعد
//       }

//       bool isMatch =
//           isLocMatch &&
//           isMoodMatch &&
//           isStomachMatch &&
//           isBudgetMatch &&
//           isNotExcluded;

//       print("وجبة: ${meal.title}");
//       print("  - location: ${meal.location} == $location ? $isLocMatch");
//       print("  - mood: ${meal.mood} == $mood ? $isMoodMatch");
//       print("  - hungerType: ${meal.hungerType} == $stomach ? $isStomachMatch");
//       print(
//         "  - budgetRange: ${meal.budgetRange} (budget=$budget) ? $isBudgetMatch",
//       );
//       print(
//         "  - categoryId: ${meal.categoryId} != $excludedCatId ? $isNotExcluded",
//       );
//       print("  - النتيجة: $isMatch");
//       print("---");
//       return isMatch;
//     }).toList();
//     print("النتائج المفلترة: ${filteredMeals.length}");
//     return Scaffold(
//       body: filteredMeals.isEmpty
//           ? _buildNoResult() // ✅ عندما تكون فارغة
//           : Suggestionslist(meal: filteredMeals), // ✅ عندما توجد نتائج
//     );
//   }
// }


// import 'package:dsain/dummy.dart';
// import 'package:dsain/model/meal.dart';
// import 'package:dsain/utils/constants.dart';
// import 'package:dsain/widget/SuggestionsList.dart';
// import 'package:flutter/material.dart';

// class ResultsScreen extends StatefulWidget {
//   static const routname = "/ResultsScreen";
//   const ResultsScreen({super.key});

//   @override
//   State<ResultsScreen> createState() => _ResultsScreenState();
// }

// class _ResultsScreenState extends State<ResultsScreen> {
//   // ========== 1. دالة نظام التصنيف (SCORING SYSTEM) ==========
//   /// تقوم بتقييم كل وجبة وإعطائها درجة حسب مدى تطابقها مع تفضيلات المستخدم
//   List<Meal> _getScoredMeals({
//     required String location,
//     required String mood,
//     required String stomach,
//     required String budget,
//     required String excludedCatId,
//   }) {
//     // قائمة مؤقتة لتخزين الوجبات مع درجاتها
//     List<Map<String, dynamic>> scoredMeals = [];
    
//     // أقصى درجة ممكنة (لحساب نسبة التطابق لاحقاً)
//     const int maxScore = 3 + 2 + 2 + 1; // = 8 نقاط
    
//     for (var meal in DUMMY_MEALS) {
//       int score = 0;

//     // 2. شرط نوع الجوع الإجباري ⭐ الأهم
//     if (stomach.isNotEmpty) {
//       if (stomach == "أرغب أحلي") {
//         // إذا أراد حلويات، يجب أن تكون الوجبة من فئة الحلويات أو مشروبات محلاة
//         bool isSweet = meal.categoryId == 'c18' || // حلويات
//                        meal.categoryId == 'c19' || // مشروبات (قد تكون محلاة)
//                        meal.hungerType == "أرغب أحلي";
        
//         if (!isSweet) {  // إذا لم يكن حلوا
//           print("❌ ${meal.title}: ليس من فئة الحلويات - مستبعد");
//           continue;
//         }
//       } else if (stomach == "أرغب في شرب") {
//         if (meal.hungerType != "أرغب في شرب") {
//           print("❌ ${meal.title}: ليس مشروب - مستبعد");
//           continue;
//         }
//       } else if (stomach == "أرغب في الأكل") {
//         if (meal.hungerType != "أرغب في الأكل") {
//           print("❌ ${meal.title}: ليس أكلة - مستبعد");
//           continue;
//         }
//       }
//     }
    
//         // 1. شرط الموقع الإجباري (إذا كان المستخدم حدد موقع)
//     if (location.isNotEmpty && meal.location != location) {
//       print("❌ ${meal.title}: الموقع لا يطابق - مستبعد");
//       continue; // استبعد هذه الوجبة
//     }
//     // الموقع (3 نقاط) - تم التحقق منه بالفعل
//     score += 3;
      
//       // المزاج (2 نقطة)
//     bool isMoodMatch = false;
//     if (mood.isNotEmpty && meal.mood == mood) {
//       isMoodMatch = true;
//       score += 2;
//     } else if (mood.isEmpty) {
//       score += 2; // إذا لم يحدد مزاج، نعطي نقاط افتراضية
//     }
      
//       // نوع الجوع (2 نقطة) - تم التحقق منه بالفعل في الشروط الإجبارية
//     if (stomach.isNotEmpty && meal.hungerType == stomach) {
//       score += 2;
//     } else if (stomach.isEmpty) {
//       score += 2;
//     }
//        // إذا كانت الفئة مستبعدة، استبعد الوجبة فوراً
//     if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
//       print("🚫 ${meal.title}: من الفئة المستبعدة ($excludedCatId) - مستبعد");
//       continue; // تخطي هذه الوجبة تماماً
//     }
//       // ========== المعيار 4: الميزانية (أهمية: 1 نقطة) ==========
//       bool isBudgetMatch = _checkBudgetMatch(meal.budgetRange, budget);
//       if (isBudgetMatch) score += 1;
      
//       // ========== المعيار 5: الاستبعاد (عقوبة -2) ==========
//       bool isNotExcluded = _checkExclusion(meal.categoryId, excludedCatId);
//       if (!isNotExcluded) {
//         score -= 2; // إذا كانت الوجبة من الفئة المستبعدة، نخصم نقطتين
//       }
      
//      // مكافأة التطابق التام
//     if (mood.isNotEmpty && meal.mood == mood && 
//         stomach.isNotEmpty && meal.hungerType == stomach) {
//       score += 1;
//     }
//       // نضيف الوجبة فقط إذا حصلت على درجة إيجابية (أكثر من 0)
//       if (score > 0) {
//         scoredMeals.add({
//           'meal': meal,
//           'score': score,
//           'matchPercentage': (score / maxScore * 100).toInt(),
//         });
//       }
      
//       // طباعة للتتبع
//     print("📊 وجبة: ${meal.title}");
//     print("   - الموقع: ${meal.location} == $location ? ${meal.location == location} (+3)");
//     print("   - المزاج: ${meal.mood} == $mood ? ${meal.mood == mood} (+2)");
//     print("   - الجوع: ${meal.hungerType} == $stomach ? ${meal.hungerType == stomach} (+2)");
//     print("   - الميزانية: ${meal.budgetRange} (budget=$budget) ? $isBudgetMatch (+1)");
//     print("   - الاستبعاد: ${meal.categoryId} != $excludedCatId ? $isNotExcluded (-2 إذا لا)");
//     print("   - 🎯 الدرجة: $score / $maxScore (${(score / maxScore * 100).toInt()}%)");
//     print("---");
//     }
    
//     // ترتيب الوجبات تنازلياً حسب الدرجة (الأعلى أولاً)
//     scoredMeals.sort((a, b) => b['score'].compareTo(a['score']));
    
//     // طباعة النتائج النهائية
//     print("✅ النتائج بعد التصنيف:");
//     for (var i = 0; i < scoredMeals.length; i++) {
//       var item = scoredMeals[i];
//       print("   ${i+1}. ${item['meal'].title} - الدرجة: ${item['score']} (${item['matchPercentage']}%)");
//     }
    
//     // استخراج قائمة الوجبات فقط (بدون الدرجات) وإرجاعها
//     return scoredMeals.map((e) => e['meal'] as Meal).toList();
//   }

//     // ========== 3. دالة مساعدة للتحقق من الاستبعاد ==========
//   bool _checkExclusion(String mealCategoryId, String excludedCatId) {
//     if (excludedCatId.isEmpty) {
//       return true; // لا استبعاد
//     }
//     // الحلويات والمشروبات لا تستبعد إذا تم اختيارها
//     if (excludedCatId == 'c18' || excludedCatId == 'c19') {
//       return true;
//     }
//     return mealCategoryId != excludedCatId;
//   }

//   // ========== 2. دالة مساعدة للتحقق من الميزانية ==========
//   bool _checkBudgetMatch(String mealBudget, String userBudget) {
//     // إذا كان المستخدم لا يهتم بالسعر
//     if (userBudget == "الكل" ||
//         userBudget == "ليست مهم السعر" ||
//         userBudget == "مش فارقة") {
//       return true;
//     }
//     // حسب نوع الميزانية المختارة
//     if (userBudget == "تحت 3500 يمني") {
//       return _isUnderBudget(mealBudget, 3500);
//     } else if (userBudget == "يمني 3500-7000") {
//       return _isBudgetBetween(mealBudget, 3500, 7000);
//     } else if (userBudget == "فوق 7000 يمني") {
//       return _isAboveBudget(mealBudget, 7000);
//     } else {
//       return mealBudget == userBudget;
//     }
//   }
  
//   bool _isUnderBudget(String mealBudget, int maxAmount) {
//     int mealValue = _extractBudgetValue(mealBudget);
//     if (mealBudget.contains("تحت") || mealBudget.contains("-")) {
//       return mealValue <= maxAmount;
//     }
//     if (mealBudget.contains("فوق")) {
//       return false;
//     }
//     return mealValue <= maxAmount;
//   }

//   bool _isBudgetBetween(String mealBudget, int minAmount, int maxAmount) {
//     int mealValue = _extractBudgetValue(mealBudget);
//     if (mealBudget.contains("تحت")) {
//       return mealValue <= maxAmount;
//     }
//     if (mealBudget.contains("فوق")) {
//       return mealValue >= minAmount;
//     }
//     if (mealBudget.contains("-")) {
//       List<int> range = mealBudget
//           .split('-')
//           .map((s) => int.tryParse(s.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
//           .toList();
//       if (range.length >= 2) {
//         return (range[0] <= maxAmount && range[1] >= minAmount);
//       }
//     }
//     return mealValue >= minAmount && mealValue <= maxAmount;
//   }
//   int _extractBudgetValue(String budgetText) {
//     RegExp regExp = RegExp(r'(\d+)');
//     List<String> numbers = regExp
//         .allMatches(budgetText)
//         .map((m) => m.group(0)!)
//         .toList();

//     if (numbers.isEmpty) {
//       if (budgetText.contains("فوق")) return 100000;
//       if (budgetText.contains("تحت")) return 0;
//       return 0;
//     }

//     int maxValue = numbers.map(int.parse).reduce((a, b) => a > b ? a : b);
//     return maxValue;
//   }

//   bool _isAboveBudget(String mealBudget, int minAmount) {
//     int mealValue = _extractBudgetValue(mealBudget);
//     if (mealBudget.contains("فوق")) {
//       return mealValue >= minAmount;
//     }
//     if (mealBudget.contains("-")) {
//       List<int> range = mealBudget
//           .split('-')
//           .map((s) => int.tryParse(s.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
//           .toList();
//       if (range.length >= 2) {
//         return range[1] >= minAmount;
//       }
//     }
//     return mealValue >= minAmount;
//   }

//   // ========== 4. دالة عرض رسالة "لا توجد نتائج" محسنة ==========
//   Widget _buildNoResult() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           margin: EdgeInsets.all(10),
//           child: Icon(
//             Icons.restaurant_menu,
//             size: 100,
//             color: Colors.grey.shade300,
//           ),
//         ),
//         SizedBox(height: AppDimens.paddingLarge),
//         Text("مزاجك فريد اليوم!", style: AppTextStyles.heading2),
//         SizedBox(height: AppDimens.paddingMedium),
//         Padding(
//           padding: EdgeInsetsGeometry.symmetric(
//             horizontal: AppDimens.paddingMedium,
//           ),
//           child: Text(
//             "للأسف لا توجد اقتراحات تطابق خياراتك حالياً، ولكن يمكننا المحاولة مجدداً مع تغيير بعض التفضيلات.",
//             textAlign: TextAlign.center,
//             style: AppTextStyles.bodyText,
//           ),
//         ),
//         SizedBox(height: AppDimens.paddingMedium),

//         Padding(
//           padding: EdgeInsetsGeometry.symmetric(horizontal: AppDimens.high100),
//           child: ElevatedButton(
//             onPressed: () => Navigator.pop(context),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.primary,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(AppDimens.borderRadius),
//               ),
//             ),
//             child: Center(
//               child: Text("جرب الثاني", style: AppTextStyles.buttonText),
//             ),
//           ),
//         ),
//         SizedBox(height: AppDimens.borderRadius),
//         TextButton.icon(
//           onPressed: () {
//             // عرض وجبات عشوائية من أفضل 5 وجبات (حسب التصنيف)
//             _showRandomSuggestions();
//           },
//           icon: Icon(Icons.auto_awesome, size: 15, color: AppColors.primary),
//           label: Text("اختيار أكلة عشوائية", style: AppTextStyles.button),
//         ),
//       ],
//     );
//   }
  
//  // ========== 5. دالة عرض اقتراحات عشوائية ==========
// void _showRandomSuggestions() {
//   // استخراج المعايير من args مرة أخرى
//   final String location = args?['location'] ?? "";
//   final String mood = args?['mood'] ?? "";
//   final String stomach = args?['stomachStatus'] ?? "";
//   final String budget = args?['budget'] ?? "الكل";
//   final String excludedCatId = args?['excludedCategory'] ?? "";
  
//   List<Meal> bestMatches = [];
  
//   // 1. إذا كان المستخدم يريد حلويات
//   if (stomach == "أرغب أحلي") {
//     // ابحث عن حلويات في نفس الموقع
//     bestMatches = DUMMY_MEALS.where((meal) {
//       // استثناء الفئة المستبعدة
//       if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
//         return false;
//       }
//       return meal.categoryId == 'c18' && // حلويات
//              meal.location == location && // نفس الموقع
//              _checkBudgetMatch(meal.budgetRange, budget);
//     }).toList();
    
//     // إذا لم توجد، ابحث عن حلويات في أي موقع
//     if (bestMatches.isEmpty) {
//       bestMatches = DUMMY_MEALS.where((meal) {
//         if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
//           return false;
//         }
//         return meal.categoryId == 'c18' &&
//                _checkBudgetMatch(meal.budgetRange, budget);
//       }).toList();
//     }
    
//     // إذا لم توجد، ابحث عن مشروبات
//     if (bestMatches.isEmpty) {
//       bestMatches = DUMMY_MEALS.where((meal) {
//         if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
//           return false;
//         }
//         return meal.categoryId == 'c19' &&
//                _checkBudgetMatch(meal.budgetRange, budget);
//       }).toList();
//     }
//   }
  
//   // 2. إذا كان المستخدم يريد أكلات
//   else if (stomach == "أرغب في الأكل") {
//     bestMatches = DUMMY_MEALS.where((meal) {
//       if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
//         return false;
//       }
//       return meal.hungerType == "أرغب في الأكل" &&
//              meal.location == location &&
//              _checkBudgetMatch(meal.budgetRange, budget);
//     }).toList();
    
//     if (bestMatches.isEmpty) {
//       bestMatches = DUMMY_MEALS.where((meal) {
//         if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
//           return false;
//         }
//         return meal.hungerType == "أرغب في الأكل" &&
//                _checkBudgetMatch(meal.budgetRange, budget);
//       }).toList();
//     }
//   }
  
//   // 3. إذا كان المستخدم يريد مشروبات
//   else if (stomach == "أرغب في شرب") {
//     bestMatches = DUMMY_MEALS.where((meal) {
//       if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
//         return false;
//       }
//       return meal.categoryId == 'c19' &&
//              meal.location == location &&
//              _checkBudgetMatch(meal.budgetRange, budget);
//     }).toList();
    
//     if (bestMatches.isEmpty) {
//       bestMatches = DUMMY_MEALS.where((meal) {
//         if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
//           return false;
//         }
//         return meal.categoryId == 'c19' &&
//                _checkBudgetMatch(meal.budgetRange, budget);
//       }).toList();
//     }
//   }
  
//   // 4. إذا لم يحدد نوع الجوع، اعرض وجبات عشوائية
//   else {
//     bestMatches = DUMMY_MEALS.where((meal) {
//       if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
//         return false;
//       }
//       return _checkBudgetMatch(meal.budgetRange, budget);
//     }).toList();
//   }
  
//   // 5. عرض النتائج
//   if (bestMatches.isNotEmpty) {
//     // ترتيب عشوائي واختيار 3 اقتراحات
//     bestMatches.shuffle();
//     int count = bestMatches.length > 3 ? 3 : bestMatches.length;
//     List<Meal> suggestions = bestMatches.take(count).toList();
    
//     // عرض الاقتراحات في AlertDialog
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.auto_awesome, color: AppColors.primary),
//             SizedBox(width: 8),
//             Text("اقتراحات عشوائية 🎲"),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: suggestions.map((meal) {
//             return ListTile(
//               leading: Icon(Icons.restaurant, color: AppColors.primary),
//               title: Text(meal.title),
//               subtitle: Text("السعر: ${meal.budgetRange}"),
//               trailing: Chip(
//                 label: Text(_getCategoryName(meal.categoryId)),
//                 backgroundColor: Colors.grey.shade200,
//               ),
//             );
//           }).toList(),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: Text("إغلاق"),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(ctx);
//               // يمكن إضافة وظيفة لاختيار وجبة محددة
//               _selectMeal(suggestions.first);
//             },
//             child: Text("اختر واحدة"),
//           ),
//         ],
//       ),
//     );
//   } else {
//     // إذا لم توجد أي اقتراحات
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("لا توجد اقتراحات متاحة حالياً، جرب تغيير التفضيلات"),
//         backgroundColor: Colors.orange,
//       ),
//     );
//   }
// }

// // دالة إضافية لاختيار وجبة
// void _selectMeal(Meal meal) {
//   showDialog(
//     context: context,
//     builder: (ctx) => AlertDialog(
//       title: Text("تم الاختيار 🎉"),
//       content: Text("لقد اخترت: ${meal.title}\nالسعر: ${meal.budgetRange}"),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(ctx),
//           child: Text("حسناً"),
//         ),
//       ],
//     ),
//   );
// }
//    // ========== دالة مساعدة لتحويل categoryId إلى اسم ==========
//   String _getCategoryName(String categoryId) {
//     Map<String, String> categories = {
//       'c1': 'برجر',
//       'c2': 'بيتزا',
//       'c3': 'دجاج',
//       'c4': 'مصري',
//       'c5': 'ستيك',
//       'c6': 'شاورما',
//       'c7': 'مشاوي',
//       'c8': 'حواوشي',
//       'c9': 'مكرونة',
//       'c10': 'مقبلات',
//       'c11': 'سوشي',
//       'c12': 'مأكولات بحرية',
//       'c13': 'يمني',
//       'c14': 'حنيذ',
//       'c15': 'زربيان',
//       'c16': 'سمك',
//       'c17': 'فتة',
//       'c18': 'حلويات',
//       'c19': 'مشروبات',
//     };
//     return categories[categoryId] ?? 'وجبة';
//   }

//   Map<String, dynamic>? args;
  
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
//     print("📦 ResultsScreen - args: $args");
//   } 
  
//   @override
//   Widget build(BuildContext context) {
//     final String location = args?['location'] ?? "";
//     final String mood = args?['mood'] ?? "";
//     final String stomach = args?['stomachStatus'] ?? "";
//     final String budget = args?['budget'] ?? "الكل";
//     final String excludedCatId = args?['excludedCategory'] ?? "";

//     print("\n========== بدء التصنيف ==========");
//     print("المعايير المستخدمة:");
//     print("  - الموقع: $location");
//     print("  - المزاج: $mood");
//     print("  - نوع الجوع: $stomach");
//     print("  - الميزانية: $budget");
//     print("  - الفئة المستبعدة: $excludedCatId");
//     print("================================\n");

//     // استخدام نظام التصنيف بدلاً من الفلترة التقليدية
//     final scoredMeals = _getScoredMeals(
//       location: location,
//       mood: mood,
//       stomach: stomach,
//       budget: budget,
//       excludedCatId: excludedCatId,
//     );
//     print("\n✅ النتيجة النهائية: ${scoredMeals.length} وجبة موصى بها\n");

//     return Scaffold(
//       body: scoredMeals.isEmpty
//           ? _buildNoResult()
//           : Suggestionslist(meal: scoredMeals),
//     );
//   }
// }