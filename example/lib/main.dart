import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:pretty_chopper_logger/pretty_chopper_logger.dart';

import 'sample_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Pretty Chopper Logger Example', home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _result = 'Click to run example';

  Future<void> _runExample() async {
    setState(() {
      _result = 'Running...';
    });

    try {
      final chopper = ChopperClient(
        baseUrl: Uri.parse("https://dummyjson.com/"),
        interceptors: [PrettyChopperLogger()],
        services: [SampleService.create()],
      );

      final sampleService = chopper.getService<SampleService>();
      final response = await sampleService.getMockResponse();

      if (response.isSuccessful) {
        final body = response.body;

        setState(() {
          _result = 'Success! Response: $body';
        });
      } else {
        final code = response.statusCode;
        final error = response.error;

        setState(() {
          _result = 'Error: Status $code, Error: $error';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Exception: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pretty Chopper Logger Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _runExample, child: const Text('Run Example')),
            const SizedBox(height: 20),
            Padding(padding: const EdgeInsets.all(16.0), child: Text(_result)),
          ],
        ),
      ),
    );
  }
}
