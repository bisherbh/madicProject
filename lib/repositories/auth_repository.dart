import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository({required this.authService});

  Future<void> login(String username, String password) async {
    final response = await authService.login(username, password);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', response['token']);
    prefs.setString('username', response['username']);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('username');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
