import 'package:ecommerce/core/utils/cache.dart';
import 'package:ecommerce/data/data_sources/local/user_local_data_source.dart';
import 'package:ecommerce/domain/entities/response/user_profile.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserLocalDataSource)
class UserLocalDataSourceImpl implements UserLocalDataSource {
  @override
  UserProfile getProfile() {
    return UserProfile(
      name: _read(CacheKeys.userName),
      email: _read(CacheKeys.userEmail),
      phone: _read(CacheKeys.userPhone),
    );
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _write(CacheKeys.userName, profile.name);
    await _write(CacheKeys.userEmail, profile.email);
    await _write(CacheKeys.userPhone, profile.phone);
  }

  @override
  Future<void> saveToken(String token) =>
      SharedPreferencesUtils.saveData(key: CacheKeys.token, value: token);

  @override
  Future<void> clear() async {
    for (final key in [
      CacheKeys.token,
      CacheKeys.userName,
      CacheKeys.userEmail,
      CacheKeys.userPhone,
    ]) {
      await SharedPreferencesUtils.removeData(key: key);
    }
  }

  String? _read(String key) {
    final value = SharedPreferencesUtils.readData(key: key);
    return value is String ? value : null;
  }

  Future<void> _write(String key, String? value) async {
    if (value == null) return;
    await SharedPreferencesUtils.saveData(key: key, value: value);
  }
}
