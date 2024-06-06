import 'package:shared_preferences/shared_preferences.dart';
class LocalStorage {
  static Future<void> saveUser (String username, String password)async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', username);
  }
  static Future<Map<String,String?>> getUser() async{
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    return {'username':username, 'password': password};
  }
}