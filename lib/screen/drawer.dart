import 'package:flutter/material.dart';
import 'package:shoes_shop/main_navigator.dart';
// import 'package:shoes_shop/screen/CounterScreen/counter_screen.dart';
// import 'package:shoes_shop/screen/WelcomeScreen/welcome_screen.dart';
// import 'package:shoes_shop/screen/crud.dart';
// import 'package:shoes_shop/screen/mahasiswa/customer_screen.dart';
// import 'package:shoes_shop/screen/mahasiswa/form_screen.dart';
// import 'package:shoes_shop/screen/news_screen.dart';
// import 'package:shoes_shop/dto/datas.dart';
// import 'package:shoes_shop/screen/routes/BalanceScreen/balance_screen.dart';
// import 'package:shoes_shop/screen/routes/SpendingScreen/spending_screen.dart';
// import 'package:shoes_shop/screen/services/data_service.dart';
// import 'package:shoes_shop/screen/endpoints/endpoints.dart';
// import 'package:shoes_shop/screen/mahasiswa/data_screen.dart';

class DrawerScren extends StatelessWidget {
  const DrawerScren({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: const Alignment(0.0, 0.1),
          colors: [const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8), Colors.white], //
        ),
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: CircleAvatar(
              radius: 65,
              backgroundImage: AssetImage('assets/shoes_shop.png'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('HOME'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainNavigator(),
                  ));
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.api),
          //   title: const Text('API'),
          //   onTap: () {
          //      Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => NewsScreen()
          //         ));
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.edit),
          //   title: const Text('CRUD'),
          //   onTap: () {
          //     Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => Crud(),
          //         ));
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.data_usage),
          //   title: const Text('DATA'),
          //   onTap: () {
          //     Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => DatasScreen(),
          //         ));
          //   },
          //   ),
          // ListTile(
          //   leading: Icon(Icons.person),
          //   title: const Text('DATA UTS'),
          //   onTap: () {
          //     Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => CustomerServiceScreen(),
          //         ));
          //   },
          //   ),
          // ListTile(
          //   leading: Icon(Icons.countertops),
          //   title: const Text('COUNTER'),
          //   onTap: () {
          //     Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => CounterScreen(),
          //         ));
          //   },
          //   ),
          // ListTile(
          //   leading: Icon(Icons.handshake),
          //   title: const Text('WELCOME'),
          //   onTap: () {
          //     Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => WelcomeScreen(),
          //         ));
          //   },
          //   ),
          // ListTile(
          //   leading: Icon(Icons.money_off),
          //   title: const Text('SPENDING'),
          //   onTap: () {
          //     Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => SpendingScreen(),
          //         ));
          //   },
          //   ),
          // ListTile(
          //   leading: Icon(Icons.account_balance_wallet),
          //   title: const Text('BALANCE'),
          //   onTap: () {
          //     Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => BalanceScreen(),
          //         ));
          //   },
          // ),
          
          
        ],
      ),
    );
  }
}
