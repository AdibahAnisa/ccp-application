import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarHelper {
  static const String avatarKey = "profile_avatar";

  static Future<String?> getAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(avatarKey);
  }

  static Future<void> saveAvatar(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(avatarKey, path);
  }

  static Future<File?> getAvatarFile() async {
    final path = await getAvatar();
    if (path == null) return null;
    return File(path);
  }
}
