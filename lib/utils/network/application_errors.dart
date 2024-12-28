class ApplicationError implements Exception{
  final ErrorType? type;
  final String? errorMsg;
  final String? errorMsgKey;
  final dynamic extra;

  ApplicationError({this.type, this.errorMsg, this.errorMsgKey, this.extra});
}

class ErrorType{}

class NetworkError extends ErrorType{
  final int code;

  NetworkError(this.code);
}

class Unauthorized extends NetworkError{
  Unauthorized() : super(401);
}

class AppOutOfDate extends ApplicationError {
  @override
  String? get errorMsg =>
      'App Update is required. Please update your app to the latest version';
}

class ResourceNotFound extends NetworkError{
  ResourceNotFound() : super(404);
}

class UnExpected extends NetworkError{
  UnExpected() : super(-1);
}

class ResponseParsingError extends ApplicationError {
  @override
  String? get errorMsg => 'Failed Response Parsing';
}

class UnknownError extends ApplicationError {
  @override
  String? get errorMsg => 'Something Went Wrong!';
}