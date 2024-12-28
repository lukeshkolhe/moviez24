import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor{

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final url = err.requestOptions.path;
    if (err.response?.statusCode == 401 && url.endsWith('/sessions') == false) {
      // ToDo: Log out the user
    }
    super.onError(err, handler);
  }
}