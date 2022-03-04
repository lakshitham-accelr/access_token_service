import 'dart:convert';

import 'package:access_token_service/helper/auth_storage.dart';
import 'package:access_token_service/model/token.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

GetIt getIt = GetIt.instance;

const clientID = '4e1ui4n7p8tu0me186j04guk62';
const clientPoolURL = 'https://idp.hfcapp.techilasoftware.com';
const redirectURI = 'http://localhost:9000';
const scope = 'email%20openid%20phone';
const grantType = 'authorization_code';

class AuthService {
  AuthService();

  Future<Token> requestTokenByAuthCode(String code) async {
    String url = "$clientPoolURL/oauth2/token";

    Map<String, dynamic> body = {'grant_type': grantType, 'client_id': clientID, 'code': code, 'redirect_uri': redirectURI};

    final response = await http.post(
      Uri.parse(url),
      body: body,
      headers: {"Accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"},
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 200) {
      final tokenData = Token.fromJson(json.decode(response.body));

      /// Save token data to cache
      getIt.get<AuthStorage>().saveTokenToCache(tokenData);

      return tokenData;
    } else {
      throw Exception("Received bad status code from Cognito for auth code:" + response.statusCode.toString() + "; body: " + response.body);
    }
  }

  Future<Token> requestTokenByRefreshToken(String refreshToken) async {
    String url = "$clientPoolURL/oauth2/token";

    Map<String, dynamic> body = {'grant_type': 'refresh_token', 'client_id': clientID, 'refresh_token': refreshToken, 'redirect_uri': redirectURI};

    final response = await http.post(
      Uri.parse(url),
      body: body,
      headers: {"Accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"},
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 200) {
      final tokenData = Token.fromJson(json.decode(response.body));

      /// Save new token data to cache
      getIt.get<AuthStorage>().saveTokenToCache(tokenData);

      return tokenData;
    } else {
      throw Exception("Received bad status code from Cognito for auth code:" + response.statusCode.toString() + "; body: " + response.body);
    }
  }
}
