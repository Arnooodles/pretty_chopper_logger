import 'package:chopper/chopper.dart';

// This is necessary for the generator to work.
part "sample_service.chopper.dart";

@ChopperApi(baseUrl: "/v2")
abstract class SampleService extends ChopperService {
  // A helper method that helps instantiating the service. You can omit this method and use the generated class directly instead.
  static SampleService create([ChopperClient? client]) => _$SampleService(client);

  @GET(path: '/5d7fc75c3300000476f0b557')
  Future<Response> getMockResponse();
}
