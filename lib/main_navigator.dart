import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shoes_shop/screen/drawer.dart';
import 'package:shoes_shop/screen/home.dart';
import 'package:shoes_shop/screen/profile.dart';
import 'package:shoes_shop/screen/setting.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;
  // ignore: prefer_final_fields
  List<Widget> _screen = [
    const Home(),
    const SettingScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Drawer(
          width: 200,
          backgroundColor: Colors.transparent,
          child: DrawerScren(),
        ),
        appBar: AppBar(),
        body: _screen[_selectedIndex],
        bottomNavigationBar: Container(
          height: 65,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          padding: const EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(1, 1),
                    spreadRadius: 5,
                    color: Colors.blue.withOpacity(0.5))
              ],
              color: Colors.blue),
          child: GNav(
              gap: 8,
              color: Colors.white,
              padding: const EdgeInsets.all(10),
              activeColor: Colors.blue,
              tabBackgroundColor: Colors.white.withOpacity(0.9),
              tabBorderRadius: 18,
              onTabChange: (i) {
                setState(() {
                  _selectedIndex = i;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(icon: Icons.settings, text: 'Setting'),
                GButton(
                  icon: Icons.person,
                  text: 'Profile',
                ),
              ]),
        ));
  }
}
