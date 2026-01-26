sealed class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  const NetworkException([super.message = 'No internet connection']);
}

class ServerException extends ApiException {
  final int? statusCode;

  const ServerException([super.message = 'Server error', this.statusCode]);
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

class NotFoundException extends ApiException {
  const NotFoundException([super.message = 'Resource not found']);
}

class BadRequestException extends ApiException {
  const BadRequestException([super.message = 'Bad request']);
}

class TimeoutException extends ApiException {
  const TimeoutException([super.message = 'Request timeout']);
}
