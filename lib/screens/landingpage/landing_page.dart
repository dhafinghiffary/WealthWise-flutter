import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../widgets/brand_mark.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1554224155-6726b3ff858f?auto=format&fit=crop&q=80',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: AppColors.bg),
          ),
          Container(color: Colors.black.withValues(alpha: .58)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BrandMark(size: 32),
                  const Spacer(),
                  const Text(
                    'WealthWise',
                    style: TextStyle(fontSize: 64, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(
                    width: 560,
                    child: Text(
                      'Manage transactions, accounts, categories, goals, statistics, and financial health in one focused workspace.',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    children: [
                      FilledButton(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: const Text('Login'),
                      ),
                      OutlinedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/register'),
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
