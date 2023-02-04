import 'package:nike/common/http_clinet.dart';
import 'package:nike/data/source/auth_data_source.dart';

final authRepository = AuthRepository(AuthRemoteDataSource(httpClient));

abstract class IAuthRepository {
  Future<void> login(String username, String password);
  Future<void> signUp(String username, String password);
  Future<void> refreshToken(String token);
}

class AuthRepository implements IAuthRepository {
  final IAuthDataSource dataSource;

  AuthRepository(this.dataSource);
  @override
  Future<void> login(String username, String password) =>
      dataSource.login(username, password);

  @override
  Future<void> refreshToken(String token) {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }

  @override
  Future<void> signUp(String username, String password) {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
