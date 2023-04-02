// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations, unnecessary_brace_in_string_interps
class _$SampleService extends SampleService {
  _$SampleService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = SampleService;

  @override
  Future<Response<dynamic>> getMockResponse() {
    final Uri $url = Uri.parse('/v2/5d7fc75c3300000476f0b557');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
