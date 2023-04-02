import 'dart:developer';

import 'package:chopper/chopper.dart';
import 'package:pretty_chopper_logger/pretty_chopper_logger.dart';

import 'sample_service.dart';

void main() async {
  final chopper = ChopperClient(
    baseUrl: Uri.parse("http://www.mocky.io/"),
    interceptors: [PrettyChopperLogger()],
    services: [
      // Create and pass an instance of the generated service to the client
      SampleService.create()
    ],
  );

  final sampleService = chopper.getService<SampleService>();
  final response = await sampleService.getMockResponse();

  if (response.isSuccessful) {
    // Successful request
    final body = response.body;
    log(body);
  } else {
    // Error code received from server
    final code = response.statusCode;
    final error = response.error;
    log('Status:$code,Error:$error');
  }
}
