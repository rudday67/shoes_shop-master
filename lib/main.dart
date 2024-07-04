import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:shoes_shop/config_screen.dart';
import 'package:shoes_shop/shoe_provider.dart';
import 'package:shoes_shop/cubit/auth/auth_cubit.dart';
import 'package:shoes_shop/cubit/balance/balance_cubit.dart';
import 'package:shoes_shop/cubit/counter_cubit.dart';
import 'package:shoes_shop/main_navigator.dart';
import 'package:shoes_shop/screen/CounterScreen/counter_screen.dart';
import 'package:shoes_shop/screen/WelcomeScreen/welcome_screen.dart';
import 'package:shoes_shop/screen/home.dart';
import 'package:shoes_shop/screen/home_admin.dart';
import 'package:shoes_shop/screen/login_admin.dart';
import 'package:shoes_shop/screen/news_screen.dart';
import 'package:shoes_shop/screen/routes/BalanceScreen/balance_screen.dart';
import 'package:shoes_shop/screen/routes/LoginScreen/login_screen.dart';
import 'package:shoes_shop/screen/routes/SpendingScreen/spending_screen.dart';
import 'package:shoes_shop/screen/setting.dart';

void main() {
  runApp(const RootApp());
}

class RootApp extends StatelessWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShoeProvider()),
        BlocProvider<CounterCubit>(create: (context) => CounterCubit()),
        BlocProvider<BalanceCubit>(create: (context) => BalanceCubit()),
        BlocProvider<AuthCubit>(create: (context) => AuthCubit())
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        '/news-screen': (context) => const NewsScreen(),
        '/counter-screen': (context) => const CounterScreen(),
        '/welcome-screen': (context) => const WelcomeScreen(),
        '/balance-screen': (context) => const BalanceScreen(),
        '/spending-screen': (context) => const SpendingScreen(),
        '/login-screen': (context) => const LoginScreen(),
        '/main-navigator': (context) => const MainNavigator(),
        '/login-admin': (context) => const LoginAdmin(),
        '/home-admin': (context) => const HomeAdmin(),
        '/home': (context) => const Home(),
        '/setting-screen': (context) => const SettingScreen(),
        '/config': (context) => ConfigScreen(),
      },
    );
  }
}
