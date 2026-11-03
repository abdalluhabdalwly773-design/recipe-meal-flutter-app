
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/cart_provider.dart';

class KuraimiPaymentScreen extends StatelessWidget {
  static const routeName = '/kuraimi-payment';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final total = cart.totalAmount;

    return Scaffold(
      appBar: AppBar(title: const Text("تأكيد الدفع - الكريمي")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("يرجى تحويل المبلغ إلى حسابنا:", style: TextStyle(fontSize: 18)),
            const SelectableText("1234567", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 10),
            Text("المبلغ المطلوب: ${total.toStringAsFixed(0)} ريال", style: const TextStyle(fontSize: 20)),
            const Spacer(),
            TextField(
              decoration: const InputDecoration(
                labelText: "أدخل رقم العملية / الحوالة",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  cart.clearCart(); // مسح السلة بعد النجاح
                  Navigator.of(context).popUntil((route) => route.isFirst); // العودة للرئيسية
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("تم استلام طلبك، سنتحقق من العملية فوراً")),
                  );
                },
                child: const Text("تأكيد العملية"),
              ),
            )
          ],
        ),
      ),
    );
  }
}