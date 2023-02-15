class AuthInfo {
  final String accessToken;
  final String refreshToken;
  AuthInfo(this.accessToken, this.refreshToken);
  AuthInfo.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'],
        refreshToken = json['refresh_token'];
}

class LoginInfo {
  final String username;
  final String password;

  LoginInfo(this.username, this.password);
}
