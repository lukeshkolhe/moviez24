import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:dio/dio.dart';

class NetworkRequestLogger extends Interceptor {
  /// Print request [Options]
  final bool request = true;

  /// Print request header [Options.headers]
  final bool requestHeader = true;

  /// Print request data [Options.data]
  final bool requestBody = true;

  /// Print [Response.data]
  final bool responseBody = true;

  /// Print [Response.headers]
  final bool responseHeader = true;

  /// Print error message
  final bool error = true;

  /// InitialTab count to logPrint json response
  static const int kInitialTab = 1;

  /// 1 tab length
  static const String tabStep = '   ';

  /// Print compact json response
  final bool compact = true;

  /// Width size per logPrint
  final int maxWidth = 90;

  /// Size in which the Uint8List will be splitted
  static const int chunkSize = 20;

  NetworkRequestLogger();

  /// using log to minimize prefix on each line
  void logPrint(String s) {
    log(s);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (request) {
      _printRequestHeader(options);
    }
    if (requestHeader) {
      _printMapAsTable(options.queryParameters, header: 'Query Parameters');
      _printRequestHeaders(options);
      _printMapAsTable(options.extra, header: 'Extras');
    }
    if (requestBody && options.method != 'GET') {
      _printRequestBody(options);
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (error) {
      _printError(err);
    }
    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _printResponseHeader(response);
    if (responseHeader) {
      final responseHeaders = <String, String>{};
      response.headers
          .forEach((k, list) => responseHeaders[k] = list.toString());
      _printMapAsTable(responseHeaders, header: 'Headers');
    }

    if (responseBody) {
      logPrint('╔ Body');
      logPrint('║');
      _printResponse(response);
      logPrint('║');
      _printLine('╚');
    }
    super.onResponse(response, handler);
  }

  void _printResponse(Response response) {
    if (response.data != null) {
      if (response.data is Map) {
        _printPrettyMap(response.data as Map);
      } else if (response.data is Uint8List) {
        logPrint('║${_indent()}[');
        _printUint8List(response.data as Uint8List);
        logPrint('║${_indent()}]');
      } else if (response.data is List) {
        logPrint('║${_indent()}[');
        _printList(response.data as List);
        logPrint('║${_indent()}]');
      } else {
        _printBlock(response.data.toString());
      }
    }
  }

  void _printResponseHeader(Response response) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method;
    _printBoxed(
        header:
            'Response ║ $method ║ Status: ${response.statusCode} ${response.statusMessage}',
        text: uri.toString());
  }

  void _printRequestHeader(RequestOptions options) {
    final uri = options.uri;
    final method = options.method;
    _printBoxed(header: 'Request ║ $method ', text: uri.toString());
  }

  void _printRequestBody(RequestOptions options) {
    final dynamic data = options.data;
    if (data != null) {
      if (data is Map) _printMapAsTable(options.data as Map?, header: 'Body');
      else if (data is FormData) {
        final formDataMap = <String, dynamic>{}
          ..addEntries(data.fields)
          ..addEntries(data.files);
        _printMapAsTable(formDataMap, header: 'Form data | ${data.boundary}');
      } else {
        _printBlock(data.toString());
      }
    }
  }

  void _printRequestHeaders(RequestOptions options) {
    final requestHeaders = <String, dynamic>{};
    requestHeaders.addAll(options.headers);
    requestHeaders['contentType'] = options.contentType?.toString();
    requestHeaders['responseType'] = options.responseType.toString();
    requestHeaders['followRedirects'] = options.followRedirects;
    requestHeaders['connectTimeout'] =
        '${options.connectTimeout?.inSeconds.toString()} sec';
    requestHeaders['receiveTimeout'] =
        '${options.receiveTimeout?.inSeconds} sec';
    _printMapAsTable(requestHeaders, header: 'Headers');
  }

  void _printError(DioError err) {
    if (err.type == DioErrorType.badResponse) {
      final uri = err.response?.requestOptions.uri;
      _printBoxed(
          header:
              'DioError ║ Status: ${err.response?.statusCode} ${err.response?.statusMessage}',
          text: uri.toString());
      if (err.response != null && err.response?.data != null) {
        logPrint('╔ ${err.type.toString()}');
        _printResponse(err.response!);
      }
      _printLine('╚');
      logPrint('');
    } else {
      _printBoxed(header: 'DioError ║ ${err.type}', text: err.message);
    }
  }

  void _printLine([String pre = '', String suf = '╝']) =>
      logPrint('$pre${'═' * maxWidth}$suf');

  void _printKV(String? key, Object? v) {
    final pre = '╟ $key: ';
    final msg = v.toString();

    if (pre.length + msg.length > maxWidth) {
      logPrint(pre);
      _printBlock(msg);
    } else {
      logPrint('$pre$msg');
    }
  }

  void _printBlock(String msg) {
    final lines = (msg.length / maxWidth).ceil();
    for (var i = 0; i < lines; ++i) {
      logPrint(('║ ') +
          msg.substring(i * maxWidth,
              math.min<int>(i * maxWidth + maxWidth, msg.length)));
    }
  }

  void _printBoxed({String? header, String? text}) {
    logPrint('');
    logPrint('╔╣ $header');
    logPrint('║  $text');
    _printLine('╚');
  }

  String _indent([int tabCount = kInitialTab]) => tabStep * tabCount;

  void _printPrettyMap(
    Map data, {
    int initialTab = kInitialTab,
    bool isListItem = false,
    bool isLast = false,
  }) {
    var tabs = initialTab;
    final isRoot = tabs == kInitialTab;
    final initialIndent = _indent(tabs);
    tabs++;

    if (isRoot || isListItem) logPrint('║$initialIndent{');

    data.keys.toList().asMap().forEach((index, dynamic key) {
      final isLast = index == data.length - 1;
      final pre = '$key: ';
      dynamic value = data[key];
      int prefixLength = tabs * tabStep.length + pre.length;
      if (value is String) {
        value = '"${value.toString().replaceAll(RegExp(r'([\r\n])+'), ' ')}"';
      }
      if (value is Map) {
        if (compact && _canFlattenMap(value, prefixLength)) {
          logPrint('║${_indent(tabs)} $pre$value${!isLast ? ',' : ''}');
        } else {
          logPrint('║${_indent(tabs)} $pre{');
          _printPrettyMap(value, initialTab: tabs, isLast: isLast);
        }
      } else if (value is List) {
        if (compact && _canFlattenList(value, prefixLength)) {
          logPrint(
              '║${_indent(tabs)} $pre${value.toString()}${isLast ? '' : ','}');
        } else {
          logPrint('║${_indent(tabs)} $pre[');
          _printList(value, tabs: tabs);
          logPrint('║${_indent(tabs)} ]${isLast ? '' : ','}');
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        final preSpace = ' ' * pre.length;
        final indent = _indent(tabs);
        final linWidth = maxWidth - indent.length - pre.length;
        if (msg.length > linWidth) {
          /// lines will definitely >=2
          final lines = (msg.length / linWidth).ceil();
          for (var i = 0; i < lines; ++i) {
            if (i == 0)
              logPrint(
                  '║${_indent(tabs)} $pre${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}');
            else
              logPrint(
                  '║${_indent(tabs)} $preSpace${msg.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, msg.length))}${(!isLast && i == lines - 1) ? ',' : ''}');
          }
        } else {
          logPrint('║${_indent(tabs)} $pre$msg${!isLast ? ',' : ''}');
        }
      }
    });

    logPrint('║$initialIndent}${!isLast ? ',' : ''}');
  }

  void _printList(List list, {int tabs = kInitialTab}) {
    tabs++;
    list.asMap().forEach((i, dynamic e) {
      final isLast = i == list.length - 1;
      if (e is Map) {
        if (compact && _canFlattenMap(e, tabs * tabStep.length)) {
          logPrint('║${_indent(tabs)}$e${!isLast ? ',' : ''}');
        } else {
          _printPrettyMap(
            e,
            initialTab: tabs,
            isListItem: true,
            isLast: isLast,
          );
        }
      } else {
        final indent = _indent(tabs + 1);
        final linWidth = maxWidth - indent.length;
        if (e.length > linWidth) {
          /// lines will definitely >=2
          final lines = (e.length / linWidth).ceil();
          for (var i = 0; i < lines; ++i) {
            if (i == 0)
              logPrint(
                  '║${_indent(tabs)} ${e.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, e.length))}');
            else
              logPrint(
                  '║${_indent(tabs)} ${e.substring(i * linWidth, math.min<int>(i * linWidth + linWidth, e.length))}${(!isLast && i == lines - 1) ? ',' : ''}');
          }
        } else {
          logPrint('║${_indent(tabs)} $e${!isLast ? ',' : ''}');
        }
      }
    });
  }

  void _printUint8List(Uint8List list, {int tabs = kInitialTab}) {
    var chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(
        list.sublist(
            i, i + chunkSize > list.length ? list.length : i + chunkSize),
      );
    }
    for (var element in chunks) {
      logPrint('║${_indent(tabs)} ${element.join(", ")}');
    }
  }

  void _printMapAsTable(Map? map, {String? header}) {
    if (map == null || map.isEmpty) return;
    logPrint('╔ $header ');
    map.forEach(
        (dynamic key, dynamic value) => _printKV(key.toString(), value));
    _printLine('╚');
  }

  bool _canFlattenMap(Map map, int prefixLength) {
    return map.values
            .where((dynamic val) => val is Map || val is List)
            .isEmpty &&
        map.toString().length + prefixLength < maxWidth;
  }

  bool _canFlattenList(List list, int prefixLength) {
    return list.toString().length + prefixLength < maxWidth;
  }
}
