import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/account/account_form_screen.dart';
import 'screens/account/account_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/category/category_form_screen.dart';
import 'screens/category/category_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/financial_health/financial_health_screen.dart';
import 'screens/landingpage/landing_page.dart';
import 'screens/notification/notification_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/smartplanning/goal_form_screen.dart';
import 'screens/smartplanning/smartplanning_screen.dart';
import 'screens/smartplanning/view_goals_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/statistics/statistics_screen.dart';
import 'screens/transaction/transaction_form_screen.dart';
import 'screens/transaction/transaction_screen.dart';

class WealthWiseApp extends StatelessWidget {
  const WealthWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WealthWise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/dashboard': (_) => const DashboardScreen(),
        '/transactions': (_) => const TransactionScreen(),
        '/transactions/add': (_) => const TransactionFormScreen(),
        '/transactions/edit': (_) => const TransactionFormScreen(isEdit: true),
        '/accounts': (_) => const AccountScreen(),
        '/accounts/add': (_) => const AccountFormScreen(),
        '/accounts/edit': (_) => const AccountFormScreen(isEdit: true),
        '/categories': (_) => const CategoryScreen(),
        '/categories/add': (_) => const CategoryFormScreen(),
        '/categories/edit': (_) => const CategoryFormScreen(isEdit: true),
        '/statistics': (_) => const StatisticsScreen(),
        '/smart-planning': (_) => const SmartPlanningScreen(),
        '/smart-planning/add-goal': (_) => const GoalFormScreen(),
        '/smart-planning/edit': (_) => const GoalFormScreen(isEdit: true),
        '/smart-planning/active-goals': (_) => const ViewGoalsScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/profile/edit': (_) => const EditProfileScreen(),
        '/financial-health': (_) => const FinancialHealthScreen(),
        '/notifications': (_) => const NotificationScreen(),
        '/landingpage': (_) => const LandingScreen(),
        '/support': (_) => const NotificationScreen(title: 'Support'),
      },
    );
  }
}
