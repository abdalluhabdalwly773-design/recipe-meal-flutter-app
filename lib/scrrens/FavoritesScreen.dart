
import 'package:flutter/material.dart';
import 'package:dsain/utils/constants.dart';
import 'package:dsain/model/meal.dart';

class FavoritesScreen extends StatefulWidget {
  static const routname="/FavoritesScreen";
  final List<Meal> favoriteMeals; 
  final Function(String) toggleFavorite;
  const FavoritesScreen({super.key, required this.favoriteMeals, required this.toggleFavorite});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("وجباتي المفضلة", style: AppTextStyles.heading4),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: widget.favoriteMeals.isEmpty
          ? _buildEmptyState() // إذا كانت القائمة فارغة
          : ListView.builder(
              itemCount: widget.favoriteMeals.length,
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              itemBuilder: (context, index) {
                final meal = widget.favoriteMeals[index];
                // نستخدم نفس كود الـ Card السابق مع إضافة زر الحذف
                return _buildFavoriteCard(meal);
              },
            ),
    );
  }

  // حالة الصفحة عندما لا توجد وجبات مفضلة
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          const Text(
            "قائمتك المفضلة فارغة حالياً",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ابدأ باستكشاف الوجبات", style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  // بناء كرت الوجبة المفضلة (معدل ليدعم الحذف)
  Widget _buildFavoriteCard(Meal meal) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl, // لتبدأ الصورة من اليمين
        children: [
          // 1. صورة الوجبة
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(meal.imageUrl, width: 70, height: 70, fit: BoxFit.cover),
          ),
          const SizedBox(width: 15),
          // 2. معلومات الوجبة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(meal.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  meal.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          // 3. زر الحذف (أيقونة القلب الممتلئ)
    
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              setState(() {
                // نستدعي الدالة من الـ widget ونعطيها الـ id
                widget.toggleFavorite(meal.id);
              });
              
              // لمسة جمالية: إظهار رسالة صغيرة عند الحذف
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("تم الحذف من المفضلة", textAlign: TextAlign.right),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}