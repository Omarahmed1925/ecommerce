import 'package:ecommerce/domain/entities/response/user_profile.dart';

abstract class UserLocalDataSource {
  UserProfile getProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<void> saveToken(String token);
  Future<void> clear();
}
