// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$SampleService extends SampleService {
  _$SampleService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = SampleService;

  @override
  Future<Response<dynamic>> getMockResponse() {
    final $url = Uri.parse('/v2/5d7fc75c3300000476f0b557');
    final $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
