import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const String _keyAuthToken = 'auth_token';

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _keyAuthToken, value: token);
  }

  static Future<String?> getAuthToken() async {
    return await _storage.read(key: _keyAuthToken);
  }

  static Future<void> deleteAuthToken() async {
    await _storage.delete(key: _keyAuthToken);
  }

  static Future<bool> hasAuthToken() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
