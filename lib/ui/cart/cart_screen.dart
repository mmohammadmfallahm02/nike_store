import 'package:flutter/material.dart';
import 'package:nike/data/auth.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/ui/auth/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سبد خرید'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<AuthInfo?>(
        builder: (context, value, child) {
          bool isAuthenticated = value != null && value.accessToken.isNotEmpty;
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isAuthenticated
                  ? 'خوش آمدید'
                  : 'لطفا وارد حساب کاربری خود شوید'),
              !isAuthenticated
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => const AuthScreen()));
                      },
                      child: const Text('ورود'))
                  : ElevatedButton(
                      onPressed: () {
                        authRepository.signOut();
                      },
                      child: const Text('خروج')),
              ElevatedButton(
                  onPressed: () async {
                    final SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();

                    sharedPreferences.remove('username');
                    sharedPreferences.remove('password');
                  },
                  child: const Text('refreshToken')),
            ],
          ));
        },
        valueListenable: AuthRepository.authChangeNotifier,
      ),
    );
  }
}
