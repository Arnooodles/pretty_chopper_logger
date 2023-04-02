# pretty_chopper_logger

[![Pub](https://img.shields.io/pub/v/pretty_chopper_logger.svg)](https://pub.dev/packages/pretty_chopper_logger)

Pretty Chopper logger is a [Chopper](https://pub.dev/packages/chopper) interceptor that logs network calls in a pretty, easy to read format.


## Usage

Simply add PrettyChopperLogger to your Chopper interceptors.

```Dart
final ChopperClient chopper = ChopperClient(
    baseUrl: Uri.parse("http://www.mocky.io/"),
    interceptors: [PrettyChopperLogger()],
    services: [
      // Create and pass an instance of the generated service to the client
      SampleService.create()
    ],
  );
```

## How it looks like

### VS Code

![Response Example](https://raw.github.com/Arnooodles/pretty_chopper_logger/main/images/sample.png 'Response Example')


