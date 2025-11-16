// lib/screens/dashboard/main_navigator.dart
import 'package:flutter/material.dart';
import 'package:gitraj/screens/chat/inbox_screen.dart';
import 'package:provider/provider.dart';

import '/services/auth_service.dart';
import '../login_screen.dart';

import '../chat/group_chat_screen.dart';
import '../events/events_screen.dart';
import '../members/members_directory_screen.dart';
import '../profile/profile_screen.dart';

import 'dashboard_screen.dart';
import 'admin_dashboard_screen.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    final authService = Provider.of<AuthService>(context, listen: false);
    final bool isAdmin = authService.currentUser?.isAdmin ?? false;

    // HOME SCREEN DEPENDS ON USER TYPE
    _screens = [
      isAdmin ? const AdminDashboardScreen() : const DashboardScreen(),
      const EventsScreen(),
      const MembersDirectoryScreen(),
      const InboxScreen(),
      const ProfileScreen(),
    ];

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      _animationController.forward(from: 0);
      setState(() => _currentIndex = index);
    }
  }

  // 🔥 LOGOUT FUNCTION — MAIN FIX
  void _logout() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    await auth.logout();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),

      // BOTTOM NAV + LOGOUT
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFB347).withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFFF8E1).withOpacity(0.95),
                  Colors.white.withOpacity(0.95),
                ],
              ),
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFFFE8CC).withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: const Color(0xFFFF8C42),
              unselectedItemColor: const Color(0xFFBCAAA4),

              items: [
                _buildNavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.event_rounded,
                  label: 'Events',
                  index: 1,
                ),
                _buildNavItem(
                  icon: Icons.people_rounded,
                  label: 'Members',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.chat_bubble_rounded,
                  label: 'Chat',
                  index: 3,
                ),

                // 🔥 LOGOUT TAB
                BottomNavigationBarItem(
                  icon: GestureDetector(
                    onTap: _logout,
                    child: const Icon(
                      Icons.logout_rounded,
                      color: Colors.redAccent,
                      size: 28,
                    ),
                  ),
                  label: 'Logout',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isSelected ? 8 : 6),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFFFC966), Color(0xFFFFB347)],
                )
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: isSelected ? 26 : 24,
          color: isSelected ? const Color(0xFF5D4037) : null,
        ),
      ),
      label: label,
    );
  }
}
