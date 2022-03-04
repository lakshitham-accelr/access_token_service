import 'dart:async';
import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:access_token_service/model/token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String _tokenIdentifier;
  final Token emptyToken = Token();

  AuthStorage({String tokenIdentifier = 'Token'}) : _tokenIdentifier = tokenIdentifier;

  /// Save token to secure storage
  Future<void> saveTokenToCache(Token token) async {
    var data = Token.toJsonMap(token);
    var json = jsonEncode(data);
    await _secureStorage.write(key: _tokenIdentifier, value: json);
  }

  /// Read token from secure storage
  Future<T> loadTokenFromCache<T extends Token>() async {
    var json = await _secureStorage.read(key: _tokenIdentifier);
    if (json == null) return emptyToken as FutureOr<T>;
    try {
      var data = jsonDecode(json);
      return _getTokenFromMap<T>(data) as FutureOr<T>;
    } catch (exception) {
      print(exception);
      return emptyToken as FutureOr<T>;
    }
  }

  Future clear() async {
    await _secureStorage.delete(key: _tokenIdentifier);
  }

  Token _getTokenFromMap<T extends Token>(Map<String, dynamic> data) => Token.fromJson(data);
}
