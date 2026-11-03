
import 'package:dsain/model/meal.dart';
import 'package:dsain/utils/constants.dart';
import 'package:flutter/material.dart';

import '../scrrens/MealDetailsScreen.dart';

class Suggestionslist extends StatelessWidget {
  final List<Meal> meal;
  final Function(String) toggleFavorite; 
  final Function(String) isFavorite;
  const Suggestionslist({super.key, required this.meal, required this.toggleFavorite, required this.isFavorite});
  
 void _selectMeal(BuildContext ctx,String id,String title){
   print("📤 إرسال: ${title} (${id})");
  Navigator.of(ctx).pushNamed(MealDetailsScreen.routname,
   arguments:  {
      'ids': id,       
      'titles': title, 
    }, 
  );
 }

Widget _buildMealCard(BuildContext context, String title, String imag, String description, String id) {
  final bool favorited = isFavorite(id);
  
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade100),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      textDirection: TextDirection.rtl, // لترتيب العناصر من اليمين لليسار بشكل طبيعي
      children: [
        // 1. الصورة (أقصى اليمين)
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imag,
            width: 75,
            height: 75,
            fit: BoxFit.cover,
          ),
        ),
        
        const SizedBox(width: 12),

        // 2. المحتوى النصي (في المنتصف) - استخدمنا Expanded ليعطيه المساحة المتبقية
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, // يبدأ النص من جهة اليمين (بسبب rtl)
            children: [
              Text(
                title,
                style: AppTextStyles.heading4.copyWith(
                  fontSize: 15, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black87
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                textDirection: TextDirection.rtl,
                description,
                style: AppTextStyles.bodyText.copyWith(
                  fontSize: 12, 
                  color: Colors.grey.shade600,
                  height: 1.3 // لتحسين تباعد الأسطر
                ),
                maxLines: 2,
                // overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // 3. الأزرار (أقصى اليسار)
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => toggleFavorite(id),
              icon: Icon(
                favorited ? Icons.favorite : Icons.favorite_border,
                color: favorited ? Colors.red : Colors.grey.shade400,
                size: 22,
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => _selectMeal(context, id, title),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "التفاصيل",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text("✨", style: TextStyle(fontSize: 20)), // أيقونة جمالية
          const SizedBox(width: 8),
          Text(
            "تم تحليل رغباتك بنجاح",
            style: AppTextStyles.bodyText.copyWith(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      RichText(
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        text: TextSpan(
          style: AppTextStyles.heading3.copyWith(
            color: Colors.black87,
            height: 1.4,
          ),
          children: [
            const TextSpan(text: "إليك "),
            TextSpan(
              text: "أفضل وجبات",
              style: TextStyle(
                color: AppColors.primary, // تلوين الجزء الأهم بلون التطبيق الأساسي
                fontWeight: FontWeight.w900,
              ),
            ),
            const TextSpan(text: " اخترناها بعناية لتناسب ذوقك الآن:"),
          ],
        ),
      ),
      // خط سفلي قصير وجميل تحت النص
      Container(
        margin: const EdgeInsets.only(top: 10),
        height: 3,
        width: 60,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ],
  ),
),
        Expanded(
          child: ListView.builder(
            itemCount: meal.length,
            itemBuilder: (conxt, index) {
              final meals = meal[index];
              return _buildMealCard( 
                context,
            
                meals.title,
                meals.imageUrl,
                meals.description,
                meals.id,
              );
            },
          ),
        ),
        SizedBox( height: AppDimens.borderRadius,),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Center(child: Text("جرب مرة أخرى")),
          ),
        ),
      ],
    );
  }
}
