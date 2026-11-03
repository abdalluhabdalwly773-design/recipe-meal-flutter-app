
import 'package:dsain/Provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import 'kuraimi_payment_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

Widget _buildCartItem(dynamic item) { // استخدم dynamic مؤقتاً لتجنب تعارض الأنواع
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    child: ListTile(
      leading: CircleAvatar(
        // تأكد أن item.imageUrl يحتوي على مسار صحيح للصورة
        backgroundImage: AssetImage(item.imageUrl),
      ),
      title: Text(item.title, textAlign: TextAlign.right),
      subtitle: Text(
        "السعر: ${item.price} | الكمية: ${item.quantity}", 
        textAlign: TextAlign.right
      ),
      trailing: Text(
        "${(item.price * item.quantity).toStringAsFixed(0)} ريال",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}
   
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("سلة المشتريات"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. ملخص السعر في الأعلى
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: [
                  const Text("الإجمالي:", style: AppTextStyles.heading4),
                  const Spacer(),
                  Chip(
                    label: Text(
                      "${cart.totalAmount.toStringAsFixed(0)} ريال",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 10),

          // 2. قائمة الوجبات المضافة
          Expanded(
            child: cart.items.isEmpty 
              ? _buildEmptyCart() 
              : ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, i) {
                    final item = cart.items.values.toList()[i];
                    return _buildCartItem(item);
                  },
                ),
          ),

          // 3. زر الانتقال للدفع
          if (cart.items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // لون يوحي بالنجاح والدفع
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    // هنا سننتقل لخطوة "الدفع عبر الكريمي"
                    _showPaymentMethod(context);
                  },
                  child: const Text(
                    "المتابعة للدفع (الكريمي)",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }


  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          const Text("السلة فارغة حالياً.. اذهب واحجز وجبتك!", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

void _showPaymentMethod(BuildContext context) {
  // الانتقال إلى شاشة الدفع عبر الكريمي المعرفة في Routes
  Navigator.of(context).pushNamed(KuraimiPaymentScreen.routeName);
}
}