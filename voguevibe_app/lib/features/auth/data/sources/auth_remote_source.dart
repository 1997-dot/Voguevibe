import 'package:dio/dio.dart';
import '../../../../data/services/mock_interceptor.dart';
import '../../../../core/utils/result.dart';
import '../models/user_model.dart';

class AuthRemoteSource {
  final Dio _dio;

  AuthRemoteSource()
      : _dio = Dio(
          BaseOptions(
            baseUrl: 'https://mock.clothing.api',
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

  Future<Result<AuthUserModel>> signIn({
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
        return Success(AuthUserModel.fromAuthResponse(response.data));
      } else {
        return Failure('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      return Failure(_handleDioException(e));
    } catch (e) {
      return Failure('Unexpected error during login: $e');
    }
  }

  Future<Result<AuthUserModel>> signUp({
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
        return Success(AuthUserModel.fromAuthResponse(response.data));
      } else {
        return Failure('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      return Failure(_handleDioException(e));
    } catch (e) {
      return Failure('Unexpected error during registration: $e');
    }
  }

  Future<Result<AuthUserModel>> getProfile(String token) async {
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
        data['token'] = token;
        return Success(AuthUserModel.fromJson(data));
      } else {
        return Failure('Failed to fetch profile: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      return Failure(_handleDioException(e));
    } catch (e) {
      return Failure('Unexpected error fetching profile: $e');
    }
  }

  String _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message =
            e.response?.data['message'] ?? e.response?.statusMessage;
        if (statusCode == 401) {
          return 'Invalid credentials. Please check your email and password.';
        } else if (statusCode == 400) {
          return message ?? 'Invalid request. Please check your input.';
        } else if (statusCode == 409) {
          return 'Email already exists. Please use a different email.';
        }
        return message ?? 'Server error occurred.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';
      default:
        return 'An unexpected error occurred: ${e.message}';
    }
  }
}
