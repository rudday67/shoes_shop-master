import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoes_shop/cubit/auth/auth_cubit.dart';
import 'package:shoes_shop/screen/routes/LoginScreen/login_screen.dart';
import 'package:shoes_shop/utils/constants.dart';
import 'package:shoes_shop/utils/secure_storage_util.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;
  const AuthWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return FutureBuilder<String?>(
      future: _getAccessTokenFromSecureStorage(),
      builder: (context, snapshot) {
        final storedAccessToken = snapshot.data;

        if (snapshot.connectionState == ConnectionState.done) {
          if (storedAccessToken != null &&
              storedAccessToken == authCubit.state.accessToken) {
            return child; // Display the child screen if tokens match
          } else {
            return const LoginScreen(); // Redirect if no token or mismatch
          }
        } else {
          // Show a loading indicator while fetching the token
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<String?> _getAccessTokenFromSecureStorage() async {
    try {
      final accessToken =
          await SecureStorageUtil.storage.read(key: tokenStorName);
      return accessToken;
    } catch (e) {
      // Handle potential errors (e.g., storage unavailable, decryption issues)
      debugPrint('Error while retrieving access token: $e');
      return null;
    }
  }
}
