import 'package:dio/dio.dart';
import 'package:moviez24/utils/network/api_handler.dart';
import 'package:moviez24/utils/network/result.dart';

import 'application_errors.dart';

enum RequestMethod { get, post, delete, put }

class ApiRequest<T, M> {
  final ApiHandler _apiHandler = ApiHandler();

  final RequestMethod requestMethod;
  final String endpoint;
  final Map<String, dynamic> headers;
  final dynamic body;
  final Map<String, dynamic>? queryParameters;
  final T Function(Map<String, dynamic> json)? dataParser;
  final T Function(List list)? listParser;
  final M Function(Map<String, dynamic> json)? metaParser;

  ApiRequest({
    required this.endpoint,
    required this.requestMethod,
    required this.headers,
    this.body,
    this.queryParameters,
    this.dataParser,
    this.listParser,
    this.metaParser,
  });

  Future<Result<T, M>> perform() {
    _formatData(queryParameters);
    _formatData(body);
    return _errorHandledRequest();
  }

  Future<Result<T, M>> _makeRequest() async {
    Response response = await _getResponse();
    if (_apiHandler.checkError(response)) {
      return Result.failed(_apiHandler.getApplicationError(response));
    } else {
      return Result.success(
          json: response.data,
          dataParser: dataParser,
          listParser: listParser,
          metaParser: metaParser);
    }
  }

  Future<Response> _getResponse() {
    switch (requestMethod) {
      case RequestMethod.get:
        return _apiHandler.get(this);
      case RequestMethod.post:
        return _apiHandler.post(this);
      case RequestMethod.put:
        return _apiHandler.put(this);
      case RequestMethod.delete:
        return _apiHandler.delete(this);
    }
  }

  Future<Result<T, M>> _errorHandledRequest() async {
    try {
      return await _makeRequest();
    } catch (e, stack) {
      if (e is TypeError) {
        //Todo report the crash
        print(e);
        print(stack);
        return Result.failed(ResponseParsingError());
      } else {
        if (e is DioException) {
          return Result.failed(_apiHandler.getApplicationErrorFromDioError(e));
        }
        return Result.failed(UnknownError());
      }
    }
  }

  _formatData(dynamic data) {
    if (data is Map) {
      List<String> keys = [];
      data.forEach((key, value) {
        if (value == null) {
          keys.add(key);
        } else {
          _formatData(value);
        }
      });
      for (var key in keys) {
        data.remove(key);
      }
    } else if (data is List) {
      for (var element in data) {
        _formatData(element);
      }
    }
  }
}
