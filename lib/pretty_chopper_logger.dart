/// Pretty Chopper logger is a Chopper interceptor designed to enhance the logging of network calls in Dart applications.

library;

import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// A Chopper interceptor for logging HTTP requests and responses in a pretty format.
///
/// This interceptor logs request and response details such as method, URL, headers, and body (if enabled).
/// It provides a formatted output for easier debugging and understanding of network calls.
/// Log levels can be set by applying [level] for more fine grained control
/// over amount of information being logged.
///
/// **Warning:** Log messages written by this interceptor have the potential to
/// leak sensitive information, such as `Authorization` headers and user data
/// in response bodies. This interceptor should only be used in a controlled way
/// or in a non-production environment.

class PrettyChopperLogger implements Interceptor {
  PrettyChopperLogger({this.level = Level.body})
    : _logBody = level == Level.body,
      _logHeaders = level == Level.body || level == Level.headers;

  /// [Level.none]
  /// No logs
  /// [Level.basic]
  /// Logs request and response lines.
  /// [Level.headers]
  /// Logs request and response lines and their respective headers.
  /// [Level.body]
  /// Logs request and response lines and their respective headers and bodies (if present).
  final Level level;

  final bool _logBody;
  final bool _logHeaders;
  final int _maxWidth = 120;

  /// Interceptors are used for intercepting request, responses and preforming operations on them.
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
    Chain<BodyType> chain,
  ) async {
    final request = chain.request;
    final base = await request.toBaseRequest();
    final headers = _logHeaders ? _jsonFormat(base.headers) : '';
    final body = _logBody && base is http.Request ? _jsonFormat(base.body) : '';
    String startRequestMessage = base.url.toString();
    if (base is http.Request) {
      if (base.body.isNotEmpty) {
        if (!_logHeaders) {
          startRequestMessage += ' (${base.bodyBytes.length}-byte body)';
        }
      }
    }
    _printRequestResponse(
      title: 'Request ║ ${base.method} ',
      text: startRequestMessage,
    );
    if (_logHeaders) {
      _printHeaderBody(title: 'Headers', prettyJson: headers);
    }
    if (_logBody && base is http.Request) {
      _printHeaderBody(title: 'Body', prettyJson: body);
    }

    final response = await chain.proceed(request);

    final baseResponse = response.base;
    String bytes = '';
    String reasonPhrase = response.statusCode.toString();
    if (baseResponse.reasonPhrase != null) {
      reasonPhrase +=
          ' ${baseResponse.reasonPhrase != reasonPhrase ? baseResponse.reasonPhrase : ''}';
    }
    if (baseResponse.contentLength != null) {
      if (!_logBody && !_logHeaders) {
        bytes = ' (${response.bodyBytes.length}-byte body)';
      }
    }
    final responseHeaders = _logHeaders
        ? _jsonFormat(baseResponse.headers)
        : '';
    final responseBody = _logBody ? _jsonFormat(response.bodyString) : '';

    _printRequestResponse(
      title:
          'Response ║ ${baseResponse.request?.method} ║ Status: $reasonPhrase',
      text: '${baseResponse.request?.url}$bytes',
    );
    if (_logHeaders) {
      _printHeaderBody(title: 'Response Headers', prettyJson: responseHeaders);
    }
    if (_logBody) {
      _printHeaderBody(title: 'Response Body', prettyJson: responseBody);
    }

    return response;
  }

  void _printRequestResponse({String? title, String? text}) {
    debugPrint('╔╣ $title');
    debugPrint('║  $text');
    debugPrint('╚═${'═' * _maxWidth}');
  }

  void _printHeaderBody({required String title, required String prettyJson}) {
    if (prettyJson.trim().isNotEmpty && prettyJson != '{}') {
      String addBorder = '';
      prettyJson.split('\n').forEach((String element) {
        element.length == 1 && (element == '{' || element == '}')
            ? addBorder += '║  $element\n'
            : addBorder += '║   ${element.substring(1, element.length)}\n';
      });
      debugPrint('╔╣ $title');
      debugPrint(addBorder.trim());
      debugPrint('╚═${'═' * _maxWidth}');
    }
  }

  String _jsonFormat(dynamic source) {
    final JsonEncoder encoder = JsonEncoder.withIndent(' ' * 2);
    if (source is Map) {
      return encoder.convert(source);
    } else if (source is String && source.isNotEmpty) {
      //If the response body is not valid JSON, JsonDecoder().convert(source) will throw an exception.
      //You can catch and handle this gracefully to avoid breaking the logger.
      try {
        return encoder.convert(const JsonDecoder().convert(source));
      } catch (_) {
        // Fallback to plain string if not JSON
        return source;
      }
    } else {
      return '';
    }
  }
}
