import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_management/api_service.dart';
import 'package:user_management/post_model.dart';
import 'package:user_management/todo_model.dart';

class DetailRepository {
  final ApiService _apiService;

  DetailRepository(this._apiService);

  Future<List<Post>> fetchUserPosts(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'posts_user_$userId';

    try {
      final data = await _apiService.get('/posts/user/$userId');
      final posts =
          List<Post>.from(data['posts'].map((json) => Post.fromJson(json)));

      // Cache posts JSON string
      prefs.setString(cacheKey, jsonEncode(data['posts']));
      return posts;
    } catch (e) {
      // Fallback to cached data if available
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        final List<dynamic> jsonList = jsonDecode(cachedData);
        return jsonList.map((json) => Post.fromJson(json)).toList();
      }
      rethrow; // or return [];
    }
  }

  Future<List<Todo>> fetchUserTodos(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'todos_user_$userId';

    try {
      final data = await _apiService.get('/todos/user/$userId');
      final todos =
          List<Todo>.from(data['todos'].map((json) => Todo.fromJson(json)));

      // Cache todos JSON string
      prefs.setString(cacheKey, jsonEncode(data['todos']));
      return todos;
    } catch (e) {
      // Fallback to cached data if available
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        final List<dynamic> jsonList = jsonDecode(cachedData);
        return jsonList.map((json) => Todo.fromJson(json)).toList();
      }
      rethrow; // or return [];
    }
  }
}
