   
import 'package:dsain/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback? onPressed;
  final bool isSelected; // ← إضافة هذا المتغير

  const CustomButton({
    super.key,
    required this.icon,
    required this.title,
    this.onPressed,
    this.isSelected = false, // ← القيمة الافتراضية غير مختار
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.paddingMedium),
        child: InkWell(
          onTap: onPressed,
          child: Ink(
            decoration: BoxDecoration(
              // ✅ إذا كان مختاراً، نعطيه لون خلفية خفيف (مثلاً برتقالي فاتح)
              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(AppDimens.paddingMedium),
              // ✅ إذا كان مختاراً، نغير لون الحدود للون الأساسي للتطبيق
              border: Border.all(
                color: isSelected ? AppColors.primary : const Color(0xFFEEEEEE), 
                width: isSelected ? 2.0 : 1.5,
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.w600,
                    // ✅ تغيير لون النص أيضاً عند الاختيار
                    color: isSelected ? AppColors.primary : Colors.black,
                  ),
                ),
                const SizedBox(width: 7),
                Text(icon, style: const TextStyle(fontSize: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}