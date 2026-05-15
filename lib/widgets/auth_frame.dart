import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import 'brand_mark.dart';

class AuthFrame extends StatelessWidget {
  const AuthFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return Scaffold(
      backgroundColor: AppColors.authBg,
      body: Row(
        children: [
          if (wide)
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?auto=format&fit=crop&q=80',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: AppColors.green),
                  ),
                  Container(color: AppColors.green.withValues(alpha: .42)),
                  const Positioned(top: 48, left: 48, child: BrandMark()),
                  const Positioned(
                    left: 56,
                    right: 56,
                    bottom: 64,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Curating your\nfinancial\nlegacy.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 46,
                            height: 1.08,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Experience world-class management with a platform built for your financial future.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            flex: 5,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
