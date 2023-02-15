import 'package:dio/dio.dart';
import 'package:nike/common/response_validator.dart';
import 'package:nike/constants/constants.dart';
import 'package:nike/data/auth.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login(String username, String password);
  Future<AuthInfo> signUp(String username, String password);
  Future<AuthInfo> refreshToken(String token);
}

class AuthRemoteDataSource
    with HttpResponseValidator
    implements IAuthDataSource {
  final Dio httpClient;

  AuthRemoteDataSource(this.httpClient);

  @override
  Future<AuthInfo> login(String username, String password) async {
    final response = await httpClient.post('auth/token', data: {
      'grant_type': 'password',
      'client_id': 2,
      'client_secret': Constants.clientSecret,
      'username': username,
      'password': password
    });
    validateResponse(response);
    return AuthInfo.fromJson(response.data);
  }

  @override
  Future<AuthInfo> refreshToken(String token) async {
    final respnose = await httpClient.post('auth/token', data: {
      'grant_type': 'refresh_token',
      'refresh_token': token,
      'client_id': 2,
      'client_secret': Constants.clientSecret
    });
    validateResponse(respnose);
    return AuthInfo(
        respnose.data['access_token'], respnose.data['refresh_token']);
  }

  @override
  Future<AuthInfo> signUp(String username, String password) async {
    final response = await httpClient
        .post('user/register', data: {'email': username, 'password': password});
    validateResponse(response);
    return login(username, password);
  }

  
}
