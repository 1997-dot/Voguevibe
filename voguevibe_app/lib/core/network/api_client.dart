import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';
import '../utils/result.dart';
import 'api_exception.dart';

class ApiClient {
  final Dio _dio;
  final SecureStorage _secureStorage;

  ApiClient({required SecureStorage secureStorage})
      : _secureStorage = secureStorage,
        _dio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            headers: {
              ApiConstants.contentTypeHeader: ApiConstants.contentTypeJson,
            },
          ),
        ) {
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_errorInterceptor());
  }

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.getToken();
        if (token != null) {
          options.headers[ApiConstants.authorizationHeader] = 'Bearer $token';
        }
        handler.next(options);
      },
    );
  }

  Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        handler.next(error);
      },
    );
  }

  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return Success(fromJson(response.data));
    } on DioException catch (e) {
      return Failure(_handleDioException(e).message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<T>> post<T>(
    String path, {
    dynamic data,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return Success(fromJson(response.data));
    } on DioException catch (e) {
      return Failure(_handleDioException(e).message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<T>> put<T>(
    String path, {
    dynamic data,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.put(path, data: data);
      return Success(fromJson(response.data));
    } on DioException catch (e) {
      return Failure(_handleDioException(e).message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<Result<T>> delete<T>(
    String path, {
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.delete(path);
      return Success(fromJson(response.data));
    } on DioException catch (e) {
      return Failure(_handleDioException(e).message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  ApiException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        return _handleStatusCode(e.response?.statusCode);
      default:
        return ServerException(e.message ?? 'Unknown error');
    }
  }

  ApiException _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return const BadRequestException();
      case 401:
        return const UnauthorizedException();
      case 404:
        return const NotFoundException();
      case 500:
      case 502:
      case 503:
        return ServerException('Server error', statusCode);
      default:
        return ServerException('Error', statusCode);
    }
  }
}
