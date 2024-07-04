import 'package:flutter/material.dart';
import 'package:shoes_shop/screen/routes/LoginScreen/login_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              size: 60,
              color: Colors.blue,
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                // ignore: avoid_print
                print('Logout button pressed'); // Debugging log
                // Clear any local data here if necessary
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => false,
                );
                // ignore: avoid_print
                print('Navigated to LoginScreen'); // Debugging log
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
