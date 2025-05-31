import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_management/api_service.dart';
import 'package:user_management/user_model.dart';

class UserRepository {
  final ApiService _apiService;

  UserRepository(this._apiService);

  static const _cachedUsersKey = 'cached_users';
  static const _cachedSearchKeyPrefix = 'cached_search_';

  Future<List<User>> fetchUsers({int limit = 10, int skip = 0}) async {
    try {
      final data = await _apiService.get('/users', query: {
        'limit': limit,
        'skip': skip,
      });
      final users =
          List<User>.from(data['users'].map((json) => User.fromJson(json)));

      // Cache only first page (skip == 0)
      if (skip == 0) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(_cachedUsersKey, jsonEncode(data['users']));
      }

      return users;
    } catch (e) {
      // On error fallback to cache if available
      final prefs = await SharedPreferences.getInstance();
      if (skip == 0) {
        final cachedData = prefs.getString(_cachedUsersKey);
        if (cachedData != null) {
          final List<dynamic> jsonList = jsonDecode(cachedData);
          return jsonList.map((json) => User.fromJson(json)).toList();
        }
      }
      rethrow; // or return empty list: return [];
    }
  }

  Future<List<User>> searchUsers(String query) async {
    try {
      final data = await _apiService.get('/users/search', query: {
        'q': query,
      });
      final users =
          List<User>.from(data['users'].map((json) => User.fromJson(json)));

      // Cache search results by query
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          _cachedSearchKeyPrefix + query, jsonEncode(data['users']));

      return users;
    } catch (e) {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cachedSearchKeyPrefix + query);
      if (cachedData != null) {
        final List<dynamic> jsonList = jsonDecode(cachedData);
        return jsonList.map((json) => User.fromJson(json)).toList();
      }
      rethrow; // or return [];
    }
  }
}
