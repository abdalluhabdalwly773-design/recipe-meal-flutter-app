

import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FavoriteItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const FavoriteItem({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppDimens.iconSize,
            height: AppDimens.iconSize,
            decoration: const BoxDecoration(
              color: AppColors.greyLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimens.paddingSmall),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}