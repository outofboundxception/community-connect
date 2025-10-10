// lib/widgets/custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<IAuthService>(context); // Use the interface
    final user = authService.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user?.fullName ?? "Guest User"),
            accountEmail: Text(user?.email ?? ""),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.profilePictureUrl != null && user!.profilePictureUrl.isNotEmpty
                  ? NetworkImage(user.profilePictureUrl)
                  : null,
              child: user?.profilePictureUrl == null || user!.profilePictureUrl.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          // Add other navigation items as needed
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              authService.logout();
              Navigator.pop(context); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}