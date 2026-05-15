import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size * .95,
          height: size * .95,
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(size * .22),
          ),
          alignment: Alignment.center,
          child: Text(
            'W',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: size * .55,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'WealthWise',
          style: TextStyle(
            color: AppColors.green,
            fontSize: size * .68,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
