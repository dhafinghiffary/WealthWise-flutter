import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../services/auth_service.dart';
import 'brand_mark.dart';
import 'custom_button.dart';
import 'loading_overlay.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.title,
    required this.child,
    this.actions = const [],
    this.loading = false,
  });

  final String title;
  final Widget child;
  final List<Widget> actions;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final body = Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 22, 28, 8),
              child: Row(
                children: [
                  if (!wide)
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  ...actions,
                  IconButton(
                    tooltip: 'Notifications',
                    onPressed: () =>
                        Navigator.pushNamed(context, '/notifications'),
                    icon: const Icon(Icons.notifications_none),
                  ),
                  IconButton(
                    tooltip: 'Profile',
                    onPressed: () => Navigator.pushNamed(context, '/profile'),
                    icon: const Icon(
                      Icons.person_outline,
                      color: AppColors.orange,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 12, 28, 28),
                child: child,
              ),
            ),
          ],
        ),
        if (loading) const LoadingOverlay(),
      ],
    );

    return Scaffold(
      backgroundColor: AppColors.bg,
      drawer: wide
          ? null
          : const Drawer(
              backgroundColor: AppColors.panel,
              child: SafeArea(child: Sidebar()),
            ),
      body: Row(
        children: [
          if (wide) const SizedBox(width: 280, child: Sidebar()),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context)?.settings.name ?? '';
    return Container(
      color: AppColors.panel,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(6, 6, 6, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BrandMark(size: 30),
                SizedBox(height: 4),
                Text(
                  'FINANCIAL ATELIER',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          PrimaryButton(
            label: 'Add Transaction',
            icon: Icons.add,
            onPressed: () => Navigator.pushNamed(context, '/transactions/add'),
          ),
          const SizedBox(height: 18),
          NavTile(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            route: '/dashboard',
            activeRoute: route,
          ),
          const NavGroup(title: 'Financials'),
          NavTile(
            icon: Icons.receipt_long_outlined,
            label: 'Transactions',
            route: '/transactions',
            activeRoute: route,
          ),
          NavTile(
            icon: Icons.flash_on_outlined,
            label: 'Smart Planning',
            route: '/smart-planning',
            activeRoute: route,
          ),
          const NavGroup(title: 'Manage'),
          NavTile(
            icon: Icons.account_balance_outlined,
            label: 'Accounts',
            route: '/accounts',
            activeRoute: route,
          ),
          NavTile(
            icon: Icons.sell_outlined,
            label: 'Categories',
            route: '/categories',
            activeRoute: route,
          ),
          const NavGroup(title: 'Analytics'),
          NavTile(
            icon: Icons.bar_chart_outlined,
            label: 'Stats',
            route: '/statistics',
            activeRoute: route,
          ),
          NavTile(
            icon: Icons.favorite_border,
            label: 'Financial Health',
            route: '/financial-health',
            activeRoute: route,
          ),
          const Divider(height: 34),
          NavTile(
            icon: Icons.support_agent_outlined,
            label: 'Support',
            route: '/support',
            activeRoute: route,
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text('Logout'),
            onTap: () async {
              await AuthService.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (_) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class NavGroup extends StatelessWidget {
  const NavGroup({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 18, 0, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white54,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class NavTile extends StatelessWidget {
  const NavTile({
    super.key,
    required this.icon,
    required this.label,
    required this.route,
    required this.activeRoute,
  });

  final IconData icon;
  final String label;
  final String route;
  final String activeRoute;

  @override
  Widget build(BuildContext context) {
    final active = activeRoute == route || activeRoute.startsWith('$route/');
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      selected: active,
      selectedTileColor: Colors.white,
      leading: Icon(icon, color: active ? AppColors.green : Colors.white70),
      title: Text(
        label,
        style: TextStyle(
          color: active ? AppColors.green : Colors.white70,
          fontWeight: active ? FontWeight.w800 : FontWeight.w500,
        ),
      ),
      onTap: () => Navigator.pushReplacementNamed(context, route),
    );
  }
}
