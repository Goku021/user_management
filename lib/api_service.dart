import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? query}) async {
    final response = await _dio.get(path, queryParameters: query);
    return response.data;
  }
}
