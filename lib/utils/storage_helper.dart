import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
    static const _storage = FlutterSecureStorage();

    static Future<void> savePrivateKey(String key) async {
        await _storage.write(key: 'private_key', value: key);
    }

    static Future<String?> getPrivateKey() async {
        return await _storage.read(key: 'private_key');
    }

    static Future<void> deletePrivateKey() async {
        await _storage.delete(key: 'private_key');
    }
}