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
  /// Creates a PrettyChopperLogger with the specified configuration.
  ///
  /// [level] controls the amount of detail logged (defaults to [Level.body]).
  /// [maxWidth] sets the maximum width for border lines (defaults to 120).
  /// [indentSize] sets the indentation size for JSON formatting (defaults to 2).
  PrettyChopperLogger({this.level = Level.body, this.maxWidth = 120, this.indentSize = 2})
    : _logBody = level == Level.body,
      _logHeaders = level == Level.body || level == Level.headers,
      _logBasic = level != Level.none,
      _borderLine = '═' * maxWidth,
      _encoder = JsonEncoder.withIndent(' ' * indentSize);

  /// [Level.none]
  /// No logs
  /// [Level.basic]
  /// Logs request and response lines.
  /// [Level.headers]
  /// Logs request and response lines and their respective headers.
  /// [Level.body]
  /// Logs request and response lines and their respective headers and bodies (if present).
  final Level level;

  /// Maximum width for the border line
  final int maxWidth;

  /// Indent size for JSON formatting
  final int indentSize;

  final bool _logBody;
  final bool _logHeaders;
  final bool _logBasic;
  final String _borderLine;

  final JsonEncoder _encoder;
  static const JsonDecoder _decoder = JsonDecoder();

  /// Interceptors are used for intercepting request, responses and performing operations on them.
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(Chain<BodyType> chain) async {
    if (!_logBasic) return chain.proceed(chain.request);

    final request = chain.request;
    final base = await request.toBaseRequest();

    _logRequest(base);

    final response = await chain.proceed(request);

    _logResponse(response);

    return response;
  }

  void _logRequest(http.BaseRequest base) {
    final isRequest = base is http.Request;
    final hasBody = isRequest && base.body.isNotEmpty;
    final buffer = StringBuffer(base.url.toString());
    if (isRequest && hasBody && !_logHeaders) {
      buffer.write(' (${base.bodyBytes.length}-byte body)');
    }
    _printRequestOrResponse(title: 'Request ║ ${base.method}', text: buffer.toString());
    if (_logHeaders) {
      final headers = _jsonFormat(base.headers);
      _printHeaderOrBody(title: 'Headers', prettyJson: headers);
    }
    if (_logBody && isRequest) {
      final body = _jsonFormat(base.body);
      _printHeaderOrBody(title: 'Body', prettyJson: body);
    }
  }

  void _logResponse(Response<dynamic> response) {
    final baseResponse = response.base;
    final buffer = StringBuffer(response.statusCode.toString());

    // Build reason phrase
    if (baseResponse.reasonPhrase != null && baseResponse.reasonPhrase != response.statusCode.toString()) {
      buffer.write(' ${baseResponse.reasonPhrase}');
    }
    final reasonPhrase = buffer.toString();

    // Build URL with optional bytes info
    buffer
      ..clear()
      ..write(baseResponse.request?.url.toString());
    if (!_logBody && !_logHeaders && response.bodyBytes.isNotEmpty) {
      buffer.write(' (${response.bodyBytes.length}-byte body)');
    }
    final urlText = buffer.toString();

    _printRequestOrResponse(title: 'Response ║ ${baseResponse.request?.method} ║ Status: $reasonPhrase', text: urlText);
    if (_logHeaders) {
      final responseHeaders = _jsonFormat(baseResponse.headers);
      _printHeaderOrBody(title: 'Response Headers', prettyJson: responseHeaders);
    }
    if (_logBody) {
      final responseBody = _jsonFormat(response.bodyString);
      _printHeaderOrBody(title: 'Response Body', prettyJson: responseBody);
    }
  }

  void _printRequestOrResponse({required String title, required String text}) {
    debugPrint('╔╣ $title');
    debugPrint('║  $text');
    debugPrint('╚═$_borderLine');
  }

  void _printHeaderOrBody({required String title, required String prettyJson}) {
    if (prettyJson.trim().isEmpty || prettyJson == '{}') return;

    final buffer = StringBuffer()..writeln('╔╣ $title');

    final lines = prettyJson.split('\n');
    for (final line in lines) {
      if (line.isEmpty) continue;

      if (line.length == 1 && (line == '{' || line == '}')) {
        buffer.writeln('║  $line');
      } else {
        buffer.writeln('║   ${line.substring(1)}');
      }
    }

    buffer.write('╚═$_borderLine');
    debugPrint(buffer.toString());
  }

  String _jsonFormat(dynamic source) {
    if (source == null || source == '') return '';

    if (source is Map) {
      return _encoder.convert(source);
    }

    if (source is String) {
      if (source.isEmpty) return '';

      // Quick check for JSON-like content before attempting parse
      final trimmed = source.trim();
      if ((trimmed.startsWith('{') && trimmed.endsWith('}')) || (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
        try {
          return _encoder.convert(_decoder.convert(source));
        } catch (_) {
          // Fallback to plain string if JSON parsing fails
          return source;
        }
      }
      // Not JSON-like, return as-is
      return source;
    }

    // Handle other types (List, numbers, etc.)
    try {
      return _encoder.convert(source);
    } catch (_) {
      return source.toString();
    }
  }
}
