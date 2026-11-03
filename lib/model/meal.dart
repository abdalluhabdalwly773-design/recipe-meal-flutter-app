
// 1. موديل الفئة (Category Model) بناءً على أيقونات الخطوة الخامسة
class Category {
  final String id;
  final String title;
  final String imageUrl; // أو IconData حسب تصميمك
  final String icon;
  const Category( {
    required this.id, 
    required this.title, 
    required this.imageUrl,
    required this.icon,
  });
}

// 2. موديل الوجبة (Meal Model) شامل لكل بيانات "تفاصيل الأكلة" و "المكونات"
class Meal {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> instructions;
  final int price;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  
  // حقول الربط مع الأسئلة (الخطوات 1-5)
  final String location;     // الخطوة 1: البيت، الشغل، مع أصحابي
  final String mood;         // الخطوة 2: مبسوط، زعلان، غضبان، محتاج طاقة، مريض، بردان
  final String hungerType;   // الخطوة 3: عاوز أشرب، عاوز آكل، عاوز أحلي
  final String budgetRange;  // الخطوة 4: تحت 100، 100-200، مش فارقة
  final String categoryId;   // الخطوة 5: برجر، بيتزا، كشري، شاورما... إلخ

  const Meal({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.price,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.location,
    required this.mood,
    required this.hungerType,
    required this.budgetRange,
    required this.categoryId,
  });
}