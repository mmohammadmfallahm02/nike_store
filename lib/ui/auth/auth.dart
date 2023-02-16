import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike/data/auth.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/gen/assets.gen.dart';
import 'package:nike/ui/auth/bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController usernameController = TextEditingController(
      text: AuthRepository.loginInfoChangeNotifier.value?.username ?? '');
  final TextEditingController passwordController = TextEditingController(
      text: AuthRepository.loginInfoChangeNotifier.value?.password ?? '');

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
          snackBarTheme: SnackBarThemeData(
              backgroundColor: Theme.of(context).colorScheme.primary,
              contentTextStyle: const TextStyle(fontFamily: 'IranYekan')),
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
          child: BlocProvider<AuthBloc>(
            create: (context) {
              final bloc = AuthBloc(authRepository);
              bloc.stream.forEach((state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('خطای نامشخص')));
                } else if (state is AuthSuccess) {
                  Navigator.of(context).pop();
                }
              });
              bloc.add(AuthStarted());
              return bloc;
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              buildWhen: (previous, current) {
                return current is AuthLoading ||
                    current is AuthInitial ||
                    current is AuthError;
              },
              builder: (context, state) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: size.width / 10, right: size.width / 10),
                    child: ValueListenableBuilder<LoginInfo?>(
                      valueListenable: AuthRepository.loginInfoChangeNotifier,
                      builder: (context, value, child) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Assets.images.nikeLogo.image(
                              color: themeData.colorScheme.onSecondary,
                              scale: 2.5),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            state.isLoginMode ? 'خوش آمدید' : 'ثبت نام',
                            style: const TextStyle(
                                color: onBackground, fontSize: 32),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                              state.isLoginMode
                                  ? 'اطلاعات حساب خود را وارد کنید'
                                  : 'ایمیل و رمز عبور خود را وارد کنید',
                              style: const TextStyle(
                                  color: onBackground, fontSize: 16)),
                          const SizedBox(
                            height: 48,
                          ),
                          TextField(
                            controller: usernameController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                label: Text('پست الکترونیک')),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          _PasswordTextField(
                            onBackground: onBackground,
                            controller: passwordController,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<AuthBloc>(context).add(
                                  AuthButtonIsClicked(usernameController.text,
                                      passwordController.text));
                            },
                            child: state is AuthLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    state.isLoginMode ? 'ورود' : 'ثبت نام',
                                    style: TextStyle(
                                        color: themeData.colorScheme.secondary),
                                  ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.isLoginMode
                                    ? 'حساب کاربری ندارید؟'
                                    : 'حساب کاربری دارید؟',
                                style: TextStyle(
                                    color: onBackground.withOpacity(0.7)),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  BlocProvider.of<AuthBloc>(context)
                                      .add(AuthModeChangeIsClicked());
                                },
                                child: Text(
                                  state.isLoginMode ? 'ثبت نام' : 'ورود',
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
                );
              },
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
    required this.controller,
  }) : super(key: key);

  final Color onBackground;
  final TextEditingController controller;

  @override
  State<_PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<_PasswordTextField> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
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
