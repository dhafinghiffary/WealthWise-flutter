import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../../widgets/brand_mark.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _go();
  }

  Future<void> _go() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final loggedIn = await AuthService.isLoggedIn();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, loggedIn ? '/dashboard' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.authBg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BrandMark(size: 42),
            SizedBox(height: 24),
            CircularProgressIndicator(color: AppColors.green),
          ],
        ),
      ),
    );
  }
}
