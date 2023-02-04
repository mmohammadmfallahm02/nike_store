class AuthInfo {
  final String accessToken;
  final String refreshToken;
  AuthInfo(this.accessToken, this.refreshToken);
  AuthInfo.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'],
        refreshToken = json['refresh_token'];
}
