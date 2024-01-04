library pretty_chopper_logger;

import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// A [RequestInterceptor] and [ResponseInterceptor] implementation which logs
/// HTTP request and response data.
///
/// Log levels can be set by applying [level] for more fine grained control
/// over amount of information being logged.
///
/// **Warning:** Log messages written by this interceptor have the potential to
/// leak sensitive information, such as `Authorization` headers and user data
/// in response bodies. This interceptor should only be used in a controlled way
/// or in a non-production environment.
class PrettyChopperLogger implements RequestInterceptor, ResponseInterceptor {
  PrettyChopperLogger({
    this.level = Level.body,
  })  : _logBody = level == Level.body,
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

  @override
  FutureOr<Request> onRequest(Request request) async {
    if (level == Level.none) return request;

    final http.BaseRequest base = await request.toBaseRequest();

    String startRequestMessage = base.url.toString();
    String bodyMessage = '';
    if (base is http.Request) {
      if (base.body.isNotEmpty) {
        bodyMessage = base.body;

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
      _printHeaderBody(
        prettyJson: _jsonFormat(base.headers),
        title: 'Headers',
      );
    }

    if (_logBody && base is http.Request && bodyMessage.isNotEmpty) {
      _printHeaderBody(
        prettyJson: _jsonFormat(bodyMessage),
        title: 'Body',
      );
    }

    return request;
  }

  @override
  FutureOr<Response<dynamic>> onResponse(Response<dynamic> response) async {
    if (level == Level.none) return response;

    final http.BaseResponse base = response.base;
    String bytes = '';
    String reasonPhrase = response.statusCode.toString();
    String bodyMessage = '';
    if (base is http.Response) {
      if (base.reasonPhrase != null) {
        reasonPhrase +=
            ' ${base.reasonPhrase != reasonPhrase ? base.reasonPhrase : ''}';
      }

      if (base.body.isNotEmpty) {
        bodyMessage = base.body;

        if (!_logBody && !_logHeaders) {
          bytes = ' (${response.bodyBytes.length}-byte body)';
        }
      }
    }

    _printRequestResponse(
      title: 'Response ║ ${base.request?.method} ║ Status: $reasonPhrase',
      text: '${base.request?.url}$bytes',
    );

    if (_logHeaders) {
      _printHeaderBody(
        prettyJson: _jsonFormat(response.headers),
        title: 'Headers',
      );
    }

    if (_logBody) {
      _printHeaderBody(
        prettyJson: _jsonFormat(bodyMessage),
        title: 'Body',
      );
    }

    return response;
  }

  String _jsonFormat(dynamic source) {
    final JsonEncoder encoder = JsonEncoder.withIndent(' ' * 2);
    if (source is Map) {
      return encoder.convert(source);
    } else if (source is String && source.isNotEmpty) {
      return encoder.convert(const JsonDecoder().convert(source));
    } else {
      return '';
    }
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
}
