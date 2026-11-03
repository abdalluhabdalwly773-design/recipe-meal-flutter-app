import 'package:dsain/model/meal.dart';
import 'package:dsain/scrrens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:dsain/utils/constants.dart';

import '../Provider/cart_provider.dart';
import 'package:provider/provider.dart';

class MealDetailsScreen extends StatefulWidget {
  static const routname = "/MealDetailsScreen";
  final List<Meal> availableMeals;
  final Function(String) toggleFavorite;
  final Function(String) isFavorite;
  const MealDetailsScreen({
    super.key,
    required this.availableMeals,
    required this.toggleFavorite,
    required this.isFavorite,
  });

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  // متغير لتحديد القسم المختار (0: التفاصيل, 1: المكونات, 2: الخطوات)
  int selectedIndex = 0;
  bool _isInit = false;
  late Meal filtersmeal;
  @override
  void didChangeDependencies() {
    // نقوم بالعملية مرة واحدة فقط عند تشغيل الشاشة
    if (!_isInit) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final String mealId = args['ids'];

      // نستخرج الوجبة ونخزنها في المتغير filtersmeal
      filtersmeal = widget.availableMeals.firstWhere(
        (meal) => meal.id == mealId,
      );

      _isInit = true; // نغير الحالة لكي لا يتكرر الكود
    }
    super.didChangeDependencies();
  }

  void _showBookingDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        height: 300,
        child: Column(
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text("تأكيد الحجز", style: AppTextStyles.heading3),
            const SizedBox(height: 15),
            Text(
              "هل تريد إضافة '${filtersmeal.title}' إلى سلة المشتريات؟",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText,
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("إلغاء"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    // داخل زر "تأكيد الحجز" في شاشة تفاصيل الوجبة
                    onPressed: () {
                      // استدعاء البروفايدر وإضافة البيانات
                      Provider.of<CartProvider>(context, listen: false).addItem(
                        filtersmeal.id,
                        filtersmeal.price.toDouble(),
                        filtersmeal.title,
                        filtersmeal.imageUrl,
                      );

                      // إغلاق المودال شيت أو الديالوج
                      Navigator.pop(context);

                      // إظهار رسالة نجاح
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "تمت الإضافة للسلة بنجاح",
                            textAlign: TextAlign.right,
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text(
                      "إضافة للسلة",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _handleAddToCart() {
    // هنا سنضع كود Provider لاحقاً
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("تم إضافة ${filtersmeal.title} للسلة بنجاح"),
        action: SnackBarAction(label: "عرض السلة", onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [const Spacer()],
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      // تغيير الأيقونة بناءً على الحالة
                      icon: Icon(
                        widget.isFavorite(filtersmeal.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: widget.isFavorite(filtersmeal.id)
                            ? Colors.red
                            : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.toggleFavorite(
                            filtersmeal.id,
                          ); // استدعاء دالة التبديل
                        });
                      },
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. الجزء العلوي: الصورة والاسم
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Hero(
                    tag: filtersmeal.id, // المُعرف الوحيد للانتقال السلس
                    child: Center(
                      child: Padding(
                        // مسافة بسيطة حول الصورة لضمان عدم التصاقها بالحواف
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: ClipRRect(
                          // السر هنا: تحديد نسبة انحناء الزوايا الأربعة للصورة
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // انحناء ناعم وواضح
                          child: AspectRatio(
                            aspectRatio:
                                1.3, // يحافظ على أبعاد مستطيلة متناسقة للصورة
                            child: Image.asset(
                              filtersmeal.imageUrl,
                              // BoxFit.cover: يضمن أن تملأ الصورة المساحة المستطيلة تماماً لتبدو الحواف المنحنية واضحة
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(filtersmeal.title, style: AppTextStyles.heading2),
                  const SizedBox(height: 20),

                  // 2. أزرار التحكم الثلاثة (Tabs)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          _buildTabButton(0, "التفاصيل"),
                          _buildTabButton(1, "المكونات"),
                          _buildTabButton(2, "الخطوات"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. عرض المحتوى بناءً على الزر المختار
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: _buildAnimatedContent(filtersmeal),
                  ),
                ],
              ),
            ),
          ),

          // داخل ملف MealDetailsScreen.dart في نهاية الـ Column الأساسي
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                // زر الحجز الرئيسي
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        _showBookingDialog(context); // دالة سننشئها بالأسفل
                      },
                      child: const Text(
                        "حجز الوجبة الآن",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // زر صغير لعرض السلة
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.primary,
                    ),
                    onPressed: () {
                     Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت بناء أزرار التبويبات
  Widget _buildTabButton(int index, String title) {
    bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.primary : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // ويدجت المحتوى المتغير
  Widget _buildAnimatedContent(filtersmeal) {
    if (selectedIndex == 0) {
      // محتوى التفاصيل
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(" وصف الاكلة", style: AppTextStyles.heading4),
          const SizedBox(height: 10),
          Text(
            filtersmeal.description,
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyText,
          ),
          const SizedBox(height: 20),
          _buildNutritionGrid(filtersmeal),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, bottom: 10),
                  child: Text("السعر التقريبي", style: AppTextStyles.bodyText),
                ),

                Text(
                  " ${filtersmeal.price} ريال يمني",
                  style: AppTextStyles.heading3,
                ),
              ],
            ),
          ),
        ],
      );
    } else if (selectedIndex == 1) {
      // محتوى المكونات
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filtersmeal.ingredients.length,
        itemBuilder: (context, i) => Card(
          elevation: 0,
          color: const Color(0xFFF9F9F9),
          child: ListTile(
            trailing: const Icon(
              Icons.check_circle,
              color: AppColors.primary,
              size: 20,
            ),
            title: Text(filtersmeal.ingredients[i], textAlign: TextAlign.right),
          ),
        ),
      );
    } else {
      // محتوى الخطوات (تعليمات التحضير)
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filtersmeal.instructions.length,
        itemBuilder: (context, i) => Card(
          elevation: 0,
          color: const Color(0xFFF9F9F9),
          child: ListTile(
            trailing: const Icon(
              Icons.check_circle,
              color: AppColors.primary,
              size: 20,
            ),
            title: Text(
              filtersmeal.instructions[i],
              textAlign: TextAlign.right,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildNutritionGrid(filtersmeal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNutritionInfo("سعرة", filtersmeal.calories.toString()),
        _buildNutritionInfo("بروتين", filtersmeal.protein.toString()),
        _buildNutritionInfo("دهون", filtersmeal.fat.toString()),
      ],
    );
  }

  Widget _buildNutritionInfo(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
