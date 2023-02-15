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
}

class AuthRepository implements IAuthRepository {
  static final ValueNotifier<AuthInfo?> authChangeNotifier =
      ValueNotifier(null);
  static final ValueNotifier<LoginInfo?> loginInfoChangeNotifier =
      ValueNotifier(null);
  final IAuthDataSource dataSource;


  AuthRepository(this.dataSource,);
  @override
  Future<void> login(String username, String password) async {
    final AuthInfo authInfo = await dataSource.login(username, password);
    _persistAuthTokens(authInfo);
    _persistLoginInfo(LoginInfo(username, password));
  }

  @override
  Future<void> refreshToken() async {
    final AuthInfo authInfo = await dataSource.refreshToken(
        'def50200f101c69b72522c7f980312e430867ca83e468be407bff8a1dcd40c3363968e95474aa1b8a4288ad7a23c9b562ac65740d2013283f10b3fc0dadf0733febd195cb2b559fa0c39225fd6d93f497c929aac237fa94737d063bb6bc7b72d78fe43426293259df35fa7895a957851081d5367b75db5dc2719e44ebcdfab2e8cdf889723a82f0ce1193269f776ab38375b9c655851990775030c51c079baf209c5058dee3f129b7410c4e64e6e4eac064f77c17c578bdbefdd4dc75bfeeb08a2bf99f77562f87ba4dad68084c45bb6e24040c73f40444acab9b4cf0d63695a5d56d9e4b6ea0f99c46d4f845be8858e40d3e4b56041262c44e3bfd796a096805b668e55b17e4eec33ff861718672121f614f2c25d7d6ec2e23734d963227c42f90129c5644d6f4988ea11d5476c9c55246c3e49e2add33e4cc9208dc6f67ed5c0b2e69ad96940d03ce2aa47a68d5d3d713573831dd4e9353c09a4c0dc6a7747b3b2');
    _persistAuthTokens(authInfo);
  }

  @override
  Future<void> signUp(String username, String password) async {
    final AuthInfo authInfo = await dataSource.signUp(username, password);
    _persistAuthTokens(authInfo);
    _persistLoginInfo(LoginInfo(username, password));
  }

  Future<void> _persistAuthTokens(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('accessToken', authInfo.accessToken);
    sharedPreferences.setString('refreshToken', authInfo.refreshToken);
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
