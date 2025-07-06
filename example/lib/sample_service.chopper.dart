// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sample_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$SampleService extends SampleService {
  _$SampleService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = SampleService;

  @override
  Future<Response<dynamic>> getMockResponse() {
    final Uri $url = Uri.parse('/posts/1');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
