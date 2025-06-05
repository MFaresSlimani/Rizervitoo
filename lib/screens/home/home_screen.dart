import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:Rizervitoo/controllers/user_controller.dart';
import 'package:Rizervitoo/screens/home/fav_screen.dart';
import 'package:Rizervitoo/screens/home/reservaton_screen.dart';
import 'package:Rizervitoo/widgets/my_drawer.dart';
import 'package:Rizervitoo/widgets/notifications_overlay.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/services/user_service.dart';
import 'agencies_screen.dart';
import 'properties_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final screens = [
    PropertiesScreen(),
    const AgenciesScreen(),
    FavScreen(),
    const ReservationsScreen(),
  ];

  OverlayEntry? _notificationsOverlay;
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell),
            onPressed: () {
              if (_notificationsOverlay == null) {
                _showNotificationsOverlay();
              } else {
                _hideNotificationsOverlay();
              }
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: screens[currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blue[900],
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -1),
            ),
          ],
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 0.0, vertical: 8.0), // Reduced horizontal padding
            child: GNav(
              backgroundColor: Colors.blue[900]!,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor:
                  Theme.of(context).primaryColor.withOpacity(0.2),
              gap: 8,
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 12), // Reduced horizontal padding
              selectedIndex: currentIndex,
              onTabChange: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              tabs: [
                GButton(
                  icon: FluentIcons.search_16_regular,
                  text: 'properties'.tr,
                ),
                GButton(
                      icon: FluentIcons.building_24_regular,
                  text: 'agencies'.tr,
                ),
                GButton(
                  icon: Icons.favorite_border,
                  text: 'favorites'.tr,
                ),
                GButton(
                    icon: LucideIcons.briefcase,
                  text: 'reservations'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showNotificationsOverlay() {
    if (_notificationsOverlay != null) return;

    _notificationsOverlay = OverlayEntry(
      builder: (context) => NotificationsOverlay(
        onClose: _hideNotificationsOverlay,
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_notificationsOverlay!);
  }

  void _hideNotificationsOverlay() {
    _notificationsOverlay?.remove();
    _notificationsOverlay = null;
  }
}
