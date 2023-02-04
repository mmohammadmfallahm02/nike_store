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
  Future<AuthInfo> refreshToken(String token) {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }

  @override
  Future<AuthInfo> signUp(String username, String password) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
