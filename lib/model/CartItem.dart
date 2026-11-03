class CartItem {
  final String id;        // معرف فريد للعملية
  final String mealId;    // معرف الوجبة الأصلي
  final String title;     // اسم الوجبة
  final int quantity;     // الكمية
  final double price;     // السعر
  final String imageUrl;  // صورة الوجبة للعرض في السلة

  CartItem({
    required this.id,
    required this.mealId,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });
}