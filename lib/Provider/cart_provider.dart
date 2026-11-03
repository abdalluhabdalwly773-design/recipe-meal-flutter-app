import 'package:flutter/material.dart';

import '../model/CartItem.dart';
 // تأكد من المسار الصحيح

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  // حساب الإجمالي الكلي بالريال اليمني
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // إضافة وجبة للسلة
  void addItem(String mealId, double price, String title, String imageUrl) {
    if (_items.containsKey(mealId)) {
      // إذا كانت موجودة، نزيد الكمية فقط
      _items.update(
        mealId,
        (existingItem) => CartItem(
          id: existingItem.id,
          mealId: existingItem.mealId,
          title: existingItem.title,
          price: existingItem.price,
          imageUrl: existingItem.imageUrl,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      // إذا كانت وجبة جديدة
      _items.putIfAbsent(
        mealId,
        () => CartItem(
          id: DateTime.now().toString(),
          mealId: mealId,
          title: title,
          price: price,
          imageUrl: imageUrl,
          quantity: 1,
        ),
      );
    }
    notifyListeners(); // لتحديث الواجهات فوراً
  }

  // مسح السلة بعد نجاح الدفع
  void clearCart() {
    _items = {};
    notifyListeners();
  }
}