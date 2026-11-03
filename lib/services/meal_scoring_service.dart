import '../model/meal.dart';
import '../dummy.dart';

class MealScoringService {
  // دالة فحص التعارض (التي تظهر السناك بار)
  static String? checkConflict(String stomach, String excludedCategory) {
    if (stomach == "أرغب في شرب" && excludedCategory == "c19") {
      return "لقد اخترت 'الرغبة في الشرب' ولكنك استبعدت فئة 'المشروبات'.";
    }
    if (stomach == "أرغب أحلي" && excludedCategory == "c18") {
      return "لقد اخترت 'أرغب أحلي' ولكنك استبعدت فئة 'الحلويات'.";
    }
    return null;
  }

  // دالة التصنيف (نسختك المطورة مع بعض التنظيم)
  static List<Meal> getRankedMeals({
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

      // 1. الموقع
      if (location.isNotEmpty) {
        if (meal.location == location) scor += 4;
      }

      // 2. نوع الجوع (استبعاد قاسي)
      if (stomach.isNotEmpty) {
        if (stomach == "أرغب أحلي") {
          if (!(meal.hungerType == 'c18' || meal.hungerType == "أرغب أحلي")) continue;
        } else if (stomach == "أرغب في شرب") {
          if (!(meal.hungerType == "أرغب في شرب" || meal.hungerType == 'c19')) continue;
        } else if (stomach == "أرغب في الأكل") {
          if (meal.hungerType != "أرغب في الأكل") continue;
        }
      }

      // 3. المزاج
      if (mood.isNotEmpty && meal.mood == mood) {
        scor += 2;
      } else if (mood.isEmpty) {
        scor += 2;
      }

      // 4. الميزانية (المنطق المفصل الذي أرسلته)
      if (budget.isNotEmpty) {
        if (budget == "ليست مهم السعر") {
          bool isbudget = meal.budgetRange == "ليست مهم السعر" ||
              meal.budgetRange == "يمني 3500-7000" ||
              meal.budgetRange == "تحت 3500 يمني";
          if (!isbudget) continue;
        } else if (budget == "يمني 3500-7000") {
          if (!(meal.budgetRange == "يمني 3500-7000" || meal.budgetRange == "تحت 3500 يمني")) continue;
        } else if (budget == "تحت 3500 يمني") {
          if (meal.budgetRange != "تحت 3500 يمني") continue;
        }
        
        if (meal.budgetRange == budget) scor += 2;
      } else {
        scor += 2; // في حال لم تحدد ميزانية
      }

      // 5. الاستبعاد
      if (excludedCategory.isNotEmpty && meal.categoryId == excludedCategory) continue;

      if (scor > 0) {
        scoredMeals.add({
          'meal': meal,
          'score': scor,
          'matchPercentage': (scor / maxAmount * 100).toInt(),
        });
      }
    }

    scoredMeals.sort((a, b) => b['score'].compareTo(a['score']));
    return scoredMeals.map((item) => item['meal'] as Meal).toList();
  }
}