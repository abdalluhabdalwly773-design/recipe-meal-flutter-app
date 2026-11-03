import 'package:dsain/Provider/cart_provider.dart';
import 'package:dsain/dummy.dart';
import 'package:dsain/model/meal.dart';
import 'package:dsain/scrrens/cart_screen.dart';
import 'package:dsain/utils/constants.dart';
import 'package:dsain/widget/SuggestionsList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/meal_scoring_service.dart';

class Newresultscreen extends StatefulWidget {
  static const routname='/Newresultscreen';
   final Function(String) toggleFavorite; 
  final Function(String) isFavorite;
  const Newresultscreen({super.key, required this.toggleFavorite, required this.isFavorite});

  @override
  State<Newresultscreen> createState() => _NewresultscreenState();
}

class _NewresultscreenState extends State<Newresultscreen> {
  List<Meal> _getScoredMealss({
    required String location,
    required String mood,
    required String stomach,
    required String budget,
    required String excludedCategory,
  }) {
    List<Map<String, dynamic>> scoredMeals = [];
    const int maxAmount = 3 + 2 + 2 + 1;
    
    for (var meal in DUMMY_MEALS) {
      int scor = 0;
      
      // بدلاً من الاستبعاد النهائي، اجعلها تعطي نقاطاً أعلى للمطابق
if (location.isNotEmpty) {
  if (meal.location == location) {
    scor += 4; // نقاط عالية للموقع المطابق
  } else {
    scor += 0; // لا تأخذ نقاط للموقع المختلف لكن لا تستبعدها
  }
}
      // stomach
      if (stomach.isNotEmpty) {
        if (stomach == "أرغب أحلي") {
          bool isSweet =
              meal.hungerType == 'c18' || meal.hungerType == "أرغب أحلي";
          if (!isSweet) {
            print("${meal.title} ليست من الحلويات استبعدها");
            continue;
          }
        } else if (stomach == "أرغب في شرب") {
          
            bool isStomach = meal.hungerType == "أرغب في شرب" ||
             meal.hungerType == '19' ;
            if (!isStomach) {
              print("${meal.title} ليست من المشروبات استبعدها");
              continue;
            }
          
        } else if (stomach == "أرغب في الأكل") {
            bool isFood = meal.hungerType == "أرغب في الأكل";
           if(!isFood) {
            print(" ${meal.title} ليست من المؤكولات استبعدها");
          
          } 
        }
      } 
    
     // المزاج
      bool isMoodMatch = false;
      if (mood.isNotEmpty && meal.mood == mood) {
        isMoodMatch = true; // الحالة 1: المستخدم أدخل مزاجًا والوجبة تناسبه
        scor +=2;
      } else if (mood.isEmpty) {
        isMoodMatch =
            true; // الحالة 2: المستخدم لم يدخل مزاجًا (كل المزاج مقبولة)
        scor +=2;
      } else {
        // الحالة 3: المستخدم أدخل مزاجًا والوجبة لا تناسبه
        isMoodMatch = false;
      }
       //
      if (stomach.isNotEmpty && meal.hungerType == stomach) {
        scor += 2;
      } else if (stomach.isEmpty) {
        scor += 2;
      }  
      //
         if(budget.isNotEmpty){
          if(budget=="ليست مهم السعر"){
            bool isbudget= meal.budgetRange == "ليست مهم السعر" ||
            meal.budgetRange == "يمني 3500-7000" ||
            meal.budgetRange == "تحت 3500 يمني";
            if(!isbudget){
              print('${meal.budgetRange} لا تناسب الميزانيه');
              continue;
            }
          } else if(budget=="يمني 3500-7000"){
            bool _isBudgetBetweens= meal.budgetRange== "يمني 3500-7000"||
            meal.budgetRange== "تحت 3500 يمني";
            if(!_isBudgetBetweens){
              print('${meal.budgetRange}  لا تناسب الميزانيه');
              continue;
            }
          } else if(budget== "تحت 3500 يمني"){
            bool isbudgetandur = meal.budgetRange== "تحت 3500 يمني";
            if(!isbudgetandur){
              print('${meal.budgetRange}  لا تناسب الميزانيه');
              continue;
            }
          }
         } //  
         if(budget.isNotEmpty&& meal.budgetRange==budget){
          scor +=2;
         } else if(budget.isEmpty){
         scor +=2;
         }// 
         // إذا كانت الفئة مستبعدة، استبعد الوجبة فوراً
       if(excludedCategory.isNotEmpty&& meal.categoryId==excludedCategory){
         print("🚫 ${meal.title}: من الفئة المستبعدة ($excludedCategory) - مستبعد");
        continue;
       } 
    
    
      bool isNotExcluded = _checkExclusion(meal.categoryId,excludedCategory);
       if(!isNotExcluded){
        scor -=2;
       }  //
       
        // مكافأة التطابق التام
     if (mood.isNotEmpty && meal.mood == mood && 
        stomach.isNotEmpty && meal.hungerType == stomach) {
        scor += 1;
     }
      // نضيف الوجبة فقط إذا حصلت على درجة إيجابية (أكثر من 0)
      if (scor > 0) {
        scoredMeals.add({
          'meal': meal,
          'score': scor,
          'matchPercentage': (scor / maxAmount * 100).toInt(),
        });
      } //
        // طباعة للتتبع
    print("📊 وجبة: ${meal.title}");
    print("   - الموقع: ${meal.location} == $location ? ${meal.location == location} (+3)");
    print("   - المزاج: ${meal.mood} == $mood ? ${meal.mood == mood} (+2)");
    print("   - الجوع: ${meal.hungerType} == $stomach ? ${meal.hungerType == stomach} (+2)");
    print("   - الميزانية: ${meal.budgetRange} (budget=$budget) ? $budget (+1)");
    print("   - الاستبعاد: ${meal.categoryId} != $excludedCategory ? $isNotExcluded (-2 إذا لا)");
    print("   - 🎯 الدرجة: $scor / $maxAmount (${(scor / maxAmount * 100).toInt()}%)");
    print("---");
  }  // نهاية الدواره
    // ترتيب الوجبات تنازلياً حسب الدرجة (الأعلى أولاً)
    scoredMeals.sort((a, b) => b['score'].compareTo(a['score']));
    
    // طباعة النتائج النهائية
    print("✅ النتائج بعد التصنيف:");
    for (var i = 0; i < scoredMeals.length; i++) {
      var item = scoredMeals[i];
      print("   ${i+1}. ${item['meal'].title} - الدرجة: ${item['score']} (${item['matchPercentage']}%)");
    }
    return scoredMeals.map((item) => item['meal'] as Meal).toList();
  }// 
      bool _checkExclusion(String mealCategoryId,String excludedCatId ) {
      if(excludedCatId.isEmpty){
        return true;   // لا استبعاد
       } if(excludedCatId == 'c18' || excludedCatId == 'c19'){
        return true; // الحلويات والمشروبات لا تستبعد إذا تم اختيارها
       }
       return mealCategoryId != excludedCatId; 
     } //
     // ========== 4. دالة عرض رسالة "لا توجد نتائج" محسنة ==========
  Widget _buildNoResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(10),
          child: Icon(
            Icons.restaurant_menu,
            size: 100,
            color: Colors.grey.shade300,
          ),
        ),
        SizedBox(height: AppDimens.paddingLarge),
        Text("مزاجك فريد اليوم!", style: AppTextStyles.heading2),
        SizedBox(height: AppDimens.paddingMedium),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: AppDimens.paddingMedium,
          ),
          child: Text(
            "للأسف لا توجد اقتراحات تطابق خياراتك حالياً، ولكن يمكننا المحاولة مجدداً مع تغيير بعض التفضيلات.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyText,
          ),
        ),
        SizedBox(height: AppDimens.paddingMedium),

        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: AppDimens.high100),
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.borderRadius),
              ),
            ),
            child: Center(
              child: Text("جرب الثاني", style: AppTextStyles.buttonText),
            ),
          ),
        ),
        SizedBox(height: AppDimens.borderRadius),
        TextButton.icon(
          onPressed: () {
            // عرض وجبات عشوائية من أفضل 5 وجبات (حسب التصنيف)
            _showRandomSuggestions();
          },
          icon: Icon(Icons.auto_awesome, size: 15, color: AppColors.primary),
          label: Text("اختيار أكلة عشوائية", style: AppTextStyles.button),
        ),
      ],
    );
  }//
   
 // ========== 5. دالة عرض اقتراحات عشوائية ==========
void _showRandomSuggestions() {
  // استخراج المعايير من args مرة أخرى
  final String location = args?['location'] ?? "";
  final String mood = args?['mood'] ?? "";
  final String stomach = args?['stomachStatus'] ?? "";
  final String budget = args?['budget'] ?? "الكل";
  final String excludedCatId = args?['excludedCategory'] ?? "";
  
  List<Meal> bestMatches = [];
  
  // 1. إذا كان المستخدم يريد حلويات
  if (stomach == "أرغب أحلي") {
    // ابحث عن حلويات في نفس الموقع
    bestMatches = DUMMY_MEALS.where((meal) {
      // استثناء الفئة المستبعدة
      if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
        return false;
      }
      return meal.categoryId == 'c18' && // حلويات
             meal.location == location ;// نفس الموقع
            //  _checkBudgetMatch(meal.budgetRange, budget);
    }).toList();
    
    // إذا لم توجد، ابحث عن حلويات في أي موقع
    if (bestMatches.isEmpty) {
      bestMatches = DUMMY_MEALS.where((meal) {
        if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
          return false;
        }
        return meal.categoryId == 'c18' ;
              //  _checkBudgetMatch(meal.budgetRange, budget);
      }).toList();
    }
    
    // إذا لم توجد، ابحث عن مشروبات
    if (bestMatches.isEmpty) {
      bestMatches = DUMMY_MEALS.where((meal) {
        if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
          return false;
        }
        return meal.categoryId == 'c19' ;
              //  _checkBudgetMatch(meal.budgetRange, budget);
      }).toList();
    }
  }
  
  // 2. إذا كان المستخدم يريد أكلات
  else if (stomach == "أرغب في الأكل") {
    bestMatches = DUMMY_MEALS.where((meal) {
      if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
        return false;
      }
      return meal.hungerType == "أرغب في الأكل" &&
             meal.location == location ;
            //  _checkBudgetMatch(meal.budgetRange, budget);
    }).toList();
    
    if (bestMatches.isEmpty) {
      bestMatches = DUMMY_MEALS.where((meal) {
        if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
          return false;
        }
        return meal.hungerType == "أرغب في الأكل" ;
              //  _checkBudgetMatch(meal.budgetRange, budget);
      }).toList();
    }
  }
  
  // 3. إذا كان المستخدم يريد مشروبات
  else if (stomach == "أرغب في شرب") {
    bestMatches = DUMMY_MEALS.where((meal) {
      if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
        return false;
      }
      return meal.categoryId == 'c19' &&
             meal.location == location ;
            //  _checkBudgetMatch(meal.budgetRange, budget);
    }).toList();
    
    if (bestMatches.isEmpty) {
      bestMatches = DUMMY_MEALS.where((meal) {
        if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
          return false;
        }
        return meal.categoryId == 'c19' ;
              //  _checkBudgetMatch(meal.budgetRange, budget);
      }).toList();
    }
  }
  
  // 4. إذا لم يحدد نوع الجوع، اعرض وجبات عشوائية
  // else {
  //   bestMatches = DUMMY_MEALS.where((meal) {
  //     if (excludedCatId.isNotEmpty && meal.categoryId == excludedCatId) {
  //       return false;
  //     }
  //     // return _checkBudgetMatch(meal.budgetRange, budget);
      
  //   }).toList();
  // }
  
  // 5. عرض النتائج
  if (bestMatches.isNotEmpty) {
    // ترتيب عشوائي واختيار 3 اقتراحات
    bestMatches.shuffle();
    int count = bestMatches.length > 3 ? 3 : bestMatches.length;
    List<Meal> suggestions = bestMatches.take(count).toList();
    
    // عرض الاقتراحات في AlertDialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.auto_awesome, color: AppColors.primary),
            SizedBox(width: 8),
            Text("اقتراحات عشوائية 🎲"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: suggestions.map((meal) {
            return ListTile(
              leading: Icon(Icons.restaurant, color: AppColors.primary),
              title: Text(meal.title),
              subtitle: Text("السعر: ${meal.budgetRange}"),
              trailing: Chip(
                label: Text(_getCategoryName(meal.categoryId)),
                backgroundColor: Colors.grey.shade200,
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("إغلاق"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // يمكن إضافة وظيفة لاختيار وجبة محددة
              _selectMeal(suggestions.first);
            },
            child: Text("اختر واحدة"),
          ),
        ],
      ),
    );
  } else {
    // إذا لم توجد أي اقتراحات
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("لا توجد اقتراحات متاحة حالياً، جرب تغيير التفضيلات"),
        backgroundColor: Colors.orange,
      ),
    );
  }
} 
// دالة إضافية لاختيار وجبة
void _selectMeal(Meal meal) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text("تم الاختيار 🎉"),
      content: Text("لقد اخترت: ${meal.title}\nالسعر: ${meal.budgetRange}"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text("حسناً"),
        ),
      ],
    ),
  );
} 
  // ========== دالة مساعدة لتحويل categoryId إلى اسم ==========
  String _getCategoryName(String categoryId) {
    Map<String, String> categories = {
      'c1': 'برجر',
      'c2': 'بيتزا',
      'c3': 'دجاج',
      'c4': 'مصري',
      'c5': 'ستيك',
      'c6': 'شاورما',
      'c7': 'مشاوي',
      'c8': 'حواوشي',
      'c9': 'مكرونة',
      'c10': 'مقبلات',
      'c11': 'سوشي',
      'c12': 'مأكولات بحرية',
      'c13': 'يمني',
      'c14': 'حنيذ',
      'c15': 'زربيان',
      'c16': 'سمك',
      'c17': 'فتة',
      'c18': 'حلويات',
      'c19': 'مشروبات',
    };
    return categories[categoryId] ?? 'وجبة';
  }//

  Map<String, dynamic>? args;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    print("📦 ResultsScreen - args: $args");
  }

@override
Widget build(BuildContext context) {
  // 1. استلام الخريطة كما تظهر في الكونسول لديك
  final argsMap = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
  
  List<Meal> finalMealsList;

  // 2. التحقق من العلامة التي أرسلناها في الزر العشوائي
  if (argsMap.containsKey('isRandom') && argsMap['isRandom'] == true) {
    // نأخذ القائمة من randomData ونقوم بتحويلها لنوع List<Meal>
    finalMealsList = (argsMap['randomData'] as List).cast<Meal>();
    print("🎲 تم التعرف على المسار العشوائي: عرض الوجبات الجاهزة");
  } 
  else {
    // 3. المسار الطبيعي (الأسئلة): تشغيل خوارزمية النقاط
    print("📊 مسار الأسئلة: تشغيل خوارزمية النقاط");
    final String location = argsMap['location'] ?? "";
    final String mood = argsMap['mood'] ?? "";
    final String stomach = argsMap['stomachStatus'] ?? "";
    final String budget = argsMap['budget'] ?? "الكل";
    final String excludedCatId = argsMap['excludedCategory'] ?? "";
    print("\n========== بدء التصنيف ==========");
    print("المعايير المستخدمة:");
    print("  - الموقع: $location");
    print("  - المزاج: $mood");
    print("  - نوع الجوع: $stomach");
    print("  - الميزانية: $budget");
    print("  - الفئة المستبعدة: $excludedCatId");
    print("================================\n");
    

   final String? conflictMessage = MealScoringService.checkConflict(stomach, excludedCatId);
  if (conflictMessage != null) {
    Future.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(conflictMessage, textAlign: TextAlign.right),
          backgroundColor: Colors.orange,
          action: SnackBarAction(label: "تعديل", textColor: Colors.white, onPressed: () => Navigator.pop(context)),
        ),
      );
    });
  }
    
   finalMealsList = MealScoringService.getRankedMeals(
    location: location,
    mood: mood,
    stomach: stomach,
    budget: budget,
    excludedCategory: excludedCatId,
  );
  }

  return Scaffold(
    // تغيير العنوان بناءً على الحالة
    // appBar: AppBar(
    //   title: Text(argsMap['isRandom'] == true ? "اقتراحات عشوائية" : "نتائج بحثك"),
    // ),
    appBar: AppBar(
  title: const Text("الوجبات المقترحة"),
  centerTitle: true,
  actions: [
    Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.of(context).pushNamed(CartScreen.routeName);
          },
        ),
        // الدائرة الحمراء التي تعرض عدد العناصر في السلة
        Positioned(
          top: 8,
          right: 8,
          child: Consumer<CartProvider>(
            builder: (ctx, cart, _) => cart.itemCount == 0 
                ? Container() 
                : CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      cart.itemCount.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
          ),
        ),
      ],
    ),
    const SizedBox(width: 10),
  ],
),
    body: finalMealsList.isEmpty
        ? _buildNoResult()
        : Suggestionslist(
            meal: finalMealsList,
            isFavorite: widget.isFavorite,
            toggleFavorite: widget.toggleFavorite,
          ),
  );
}
}
