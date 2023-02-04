import 'package:flutter/material.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/gen/assets.gen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final size = MediaQuery.of(context).size;
    const onBackground = Colors.white;
    return Theme(
      data: themeData.copyWith(
          colorScheme: themeData.colorScheme.copyWith(
            onSurface: onBackground,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
                  minimumSize:
                      MaterialStateProperty.all(const Size.fromHeight(56)),
                  backgroundColor: MaterialStateProperty.all(onBackground))),
          inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: onBackground.withOpacity(0.4)),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: onBackground, width: 1),
                borderRadius: BorderRadius.circular(16),
              ))),
      child: Scaffold(
        backgroundColor: themeData.colorScheme.secondary,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                  left: size.width / 10, right: size.width / 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.nikeLogo.image(
                      color: themeData.colorScheme.onSecondary, scale: 2.5),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    isLogin ? 'خوش آمدید' : 'ثبت نام',
                    style: const TextStyle(color: onBackground, fontSize: 32),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                      isLogin
                          ? 'اطلاعات حساب خود را وارد کنید'
                          : 'ایمیل و رمز عبور خود را وارد کنید',
                      style:
                          const TextStyle(color: onBackground, fontSize: 16)),
                  const SizedBox(
                    height: 48,
                  ),
                  const TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(label: Text('پست الکترونیک')),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const _PasswordTextField(onBackground: onBackground),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authRepository.login("test@gmail.com", "123456");
                    },
                    child: Text(
                      isLogin ? 'ورود' : 'ثبت نام',
                      style: TextStyle(color: themeData.colorScheme.secondary),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLogin ? 'حساب کاربری ندارید؟' : 'حساب کاربری دارید؟',
                        style: TextStyle(color: onBackground.withOpacity(0.7)),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          isLogin ? 'ثبت نام' : 'ورود',
                          style: TextStyle(
                              color: themeData.colorScheme.primary,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordTextField extends StatefulWidget {
  const _PasswordTextField({
    Key? key,
    required this.onBackground,
  }) : super(key: key);

  final Color onBackground;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: passwordVisible,
      decoration: InputDecoration(
          label: const Text('رمز عبور'),
          suffixIcon: IconButton(
            icon: Icon(passwordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined),
            color: widget.onBackground.withOpacity(0.4),
            onPressed: () {
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
          )),
    );
  }
}
