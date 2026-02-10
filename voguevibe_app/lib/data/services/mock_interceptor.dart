import 'package:dio/dio.dart';

/// Intercepts all Dio requests and returns mock responses
/// based on api_documentation.json specifications.
class MockInterceptor extends Interceptor {
  static const String _acceptedEmail = 'test@clothingapp.com';
  static const String _acceptedPassword = '12345678';
  static const String _staticToken = 'mock-jwt-token-123456';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final path = options.path;
    final method = options.method;

    // POST /auth/login
    if (method == 'POST' && path == '/auth/login') {
      return handler.resolve(_handleLogin(options));
    }

    // POST /auth/register
    if (method == 'POST' && path == '/auth/register') {
      return handler.resolve(_handleRegister(options));
    }

    // GET /auth/profile
    if (method == 'GET' && path == '/auth/profile') {
      return handler.resolve(_handleProfile(options));
    }

    // Default: reject unknown routes
    handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: options,
          statusCode: 404,
          data: {'message': 'Endpoint not found'},
        ),
      ),
    );
  }

  Response _handleLogin(RequestOptions options) {
    final data = options.data as Map<String, dynamic>?;
    final email = data?['email'] as String?;
    final password = data?['password'] as String?;

    if (email == _acceptedEmail && password == _acceptedPassword) {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'token': _staticToken,
          'user': {
            'id': 1,
            'name': 'Test User',
            'email': _acceptedEmail,
          },
        },
      );
    }

    return Response(
      requestOptions: options,
      statusCode: 401,
      data: {'message': 'Invalid credentials. Please check your email and password.'},
    );
  }

  Response _handleRegister(RequestOptions options) {
    final data = options.data as Map<String, dynamic>?;
    final name = data?['name'] as String? ?? 'New User';
    final email = data?['email'] as String? ?? '';

    return Response(
      requestOptions: options,
      statusCode: 201,
      data: {
        'token': _staticToken,
        'user': {
          'id': 1,
          'name': name,
          'email': email,
        },
      },
    );
  }

  Response _handleProfile(RequestOptions options) {
    final authHeader = options.headers['Authorization'] as String?;

    if (authHeader == 'Bearer $_staticToken') {
      return Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'id': 1,
          'name': 'Test User',
          'email': _acceptedEmail,
          'phone': '01000000000',
          'avatar': 'https://placehold.co/200',
          'address': 'Cairo, Egypt',
        },
      );
    }

    return Response(
      requestOptions: options,
      statusCode: 401,
      data: {'message': 'Unauthorized'},
    );
  }
}
