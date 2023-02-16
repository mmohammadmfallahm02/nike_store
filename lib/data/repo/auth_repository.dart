import 'package:flutter/cupertino.dart';
import 'package:nike/common/http_clinet.dart';
import 'package:nike/data/auth.dart';
import 'package:nike/data/source/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(AuthRemoteDataSource(httpClient));

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> signUp(String username, String password);
  Future<void> refreshToken();
  Future<void> signOut();
}

class AuthRepository implements IAuthRepository {
  static final ValueNotifier<AuthInfo?> authChangeNotifier =
      ValueNotifier(null);
  static final ValueNotifier<LoginInfo?> loginInfoChangeNotifier =
      ValueNotifier(null);
  final IAuthDataSource dataSource;

  AuthRepository(
    this.dataSource,
  );
  @override
  Future<void> login(String username, String password) async {
    final AuthInfo authInfo = await dataSource.login(username, password);
    _persistAuthTokens(authInfo);
    _persistLoginInfo(LoginInfo(username, password));
  }

  @override
  Future<void> refreshToken() async {
    if (authChangeNotifier.value != null) {
      final AuthInfo authInfo =
          await dataSource.refreshToken(authChangeNotifier.value!.refreshToken);
      // debugPrint('refresh token is ${authInfo.refreshToken}');
      _persistAuthTokens(authInfo);
    }
  }

  @override
  Future<void> signUp(String username, String password) async {
    final AuthInfo authInfo = await dataSource.signUp(username, password);
    _persistAuthTokens(authInfo);
    _persistLoginInfo(LoginInfo(username, password));
  }

  @override
  Future<void> signOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.remove('accessToken');
    sharedPreferences.remove('refreshToken');
    authChangeNotifier.value = null;
  }

  Future<void> _persistAuthTokens(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('accessToken', authInfo.accessToken);
    sharedPreferences.setString('refreshToken', authInfo.refreshToken);
    loadAuthInfo();
  }

  Future<void> loadAuthInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String accessToken = sharedPreferences.getString('accessToken') ?? '';
    final String refreshToken =
        sharedPreferences.getString('refreshToken') ?? '';
    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authChangeNotifier.value = AuthInfo(accessToken, refreshToken);
    }
  }

  Future<void> _persistLoginInfo(LoginInfo loginInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('username', loginInfo.username);
    sharedPreferences.setString('password', loginInfo.password);
    loadLoginInfo();
  }

  Future<void> loadLoginInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String username = sharedPreferences.getString('username') ?? '';
    final String password = sharedPreferences.getString('password') ?? '';
    if (username.isNotEmpty && password.isNotEmpty) {
      loginInfoChangeNotifier.value = LoginInfo(username, password);
    }
  }
}
