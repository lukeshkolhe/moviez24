import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moviez24/utils/network/api_request.dart';
import 'package:moviez24/utils/network/application_errors.dart';
import 'package:moviez24/utils/network/interceptors/auth_interceptor.dart';
import 'package:moviez24/utils/network/network_request_logger.dart';

class ApiHandler {
  static final ApiHandler _apiHandler = ApiHandler._internal();

  Dio dio = Dio();

  ApiHandler._internal() {
    init();
  }

  getOptions(Map<String, dynamic> headers) => Options(headers: headers);

  factory ApiHandler() {
    return _apiHandler;
  }

  void init() {
    dio.options.connectTimeout = const Duration(milliseconds: 50000); //5s
    dio.options.receiveTimeout = const Duration(milliseconds: 50000);
    if (kDebugMode) {
      dio.interceptors.add(NetworkRequestLogger());
    }
    dio.interceptors.add(AuthInterceptor());
  }

  Future<Response> get(ApiRequest request) => dio.get(request.endpoint,
      options: getOptions(request.headers),
      queryParameters: request.queryParameters);

  Future<Response> post(ApiRequest request) => dio.post(request.endpoint,
      data: request.body,
      options: getOptions(request.headers),
      queryParameters: request.queryParameters);

  Future<Response> put(ApiRequest request) => dio.put(request.endpoint,
      data: request.body,
      options: getOptions(request.headers),
      queryParameters: request.queryParameters);

  Future<Response> delete<T, M>(ApiRequest request) =>
      dio.delete(request.endpoint,
          data: request.body,
          options: Options(headers: request.headers),
          queryParameters: request.queryParameters);

  // not used as dio through exception if status code not valid
  ApplicationError getApplicationError(Response response) {
    ErrorType errorType;
    String? errorMsg = "Something went wrong.";
    if (response.statusCode == 401) {
      errorMsg = 'Your session is expired. Please Log in again';
      errorType = Unauthorized();
    } else if (response.statusCode == 404) {
      errorType = ResourceNotFound();
      // ToDo: log this error to the crash reports
    } else {
      errorMsg = response.data['error']["message"];
      errorType = UnExpected();
    }

    if (response.data != null && response.data is Map) {
      errorMsg = response.data['error']["message"];
    }
    return ApplicationError(type: errorType, errorMsg: errorMsg);
  }

  // convert Dio error to application error
  ApplicationError getApplicationErrorFromDioError(DioException dioError) {
    ErrorType errorType;
    String errorMsg;
    dynamic extra;
    if (dioError.response?.data != null && dioError.response?.data is Map) {
      final responseData = dioError.response!.data;
      if (responseData['error'] is String) {
        errorMsg = responseData['error'];
      } else if (responseData['error'] is Map &&
          responseData['error']["message"] != null) {
        errorMsg = responseData['error']["message"];
      } else {
        errorMsg = _getErrorMessageFromErrorType(dioError);
      }
      extra = dioError.response?.data["errors"];
    } else {
      errorMsg = _getErrorMessageFromErrorType(dioError);
    }
    if (dioError.response?.statusCode == 401) {
      errorType = Unauthorized();
    } else if (dioError.response?.statusCode == 404) {
      errorType = ResourceNotFound();
    } else {
      errorType = UnExpected();
    }
    return ApplicationError(type: errorType, errorMsg: errorMsg, extra: extra);
  }

  String _getErrorMessageFromErrorType(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return "The connection timed out. Please check your internet connection and try again.";
      case DioExceptionType.sendTimeout:
        return "Sending data took too long. Please try again.";
      case DioExceptionType.receiveTimeout:
        return "Receiving data took too long. Please try again.";
      case DioExceptionType.badCertificate:
        return "There was a security issue with the server's certificate. Please ensure your connection is secure and try again.";
      case DioExceptionType.badResponse:
        return "We received an unexpected response from the server. Please try again later.";
      case DioExceptionType.cancel:
        return "The operation was canceled. Please try again if this was a mistake.";
      case DioExceptionType.connectionError:
        return "There was an error connecting to the server. Please check your internet connection and try again.";
      case DioExceptionType.unknown:
      default:
        return "An unknown error occurred. Please try again later or contact support if the issue persists.";
    }
  }

  bool checkError(Response response) {
    return response.statusCode! < 200 || response.statusCode! >= 400;
  }
}
