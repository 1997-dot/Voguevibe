import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'mock_interceptor.dart';

class AuthService {
  final Dio _dio;
  static const String baseUrl = 'https://mock.clothing.api';

  AuthService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _dio.interceptors.add(MockInterceptor());
  }

  /// Sign in with email and password
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromAuthResponse(response.data);
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error during login: $e');
    }
  }

  /// Sign up with name, email, password, and phone
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          if (phone != null) 'phone': phone,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromAuthResponse(response.data);
      } else {
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error during registration: $e');
    }
  }

  /// Get user profile with token
  Future<UserModel> getProfile(String token) async {
    try {
      final response = await _dio.get(
        '/auth/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        data['token'] = token; // Add token to response
        return UserModel.fromJson(data);
      } else {
        throw Exception('Failed to fetch profile: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error fetching profile: $e');
    }
  }

  /// Handle Dio exceptions
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? e.response?.statusMessage;
        if (statusCode == 401) {
          return Exception('Invalid credentials. Please check your email and password.');
        } else if (statusCode == 400) {
          return Exception(message ?? 'Invalid request. Please check your input.');
        } else if (statusCode == 409) {
          return Exception('Email already exists. Please use a different email.');
        }
        return Exception(message ?? 'Server error occurred.');
      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');
      case DioExceptionType.connectionError:
        return Exception('No internet connection. Please check your network.');
      default:
        return Exception('An unexpected error occurred: ${e.message}');
    }
  }
}
