# pretty_chopper_logger

[![Pub](https://img.shields.io/pub/v/pretty_chopper_logger.svg)](https://pub.dev/packages/pretty_chopper_logger)

Pretty Chopper logger is a Chopper interceptor designed to enhance the logging of network calls in Dart applications. Inspired by the popular  [pretty_dio_logger](https://pub.dev/packages/pretty_dio_logger) package, it aims to provide developers with a clear and readable format for debugging network requests and responses.

## Features

- **Readable Logging**: Log network calls in a visually appealing format, making it easier to understand request and response details.
- **Customizable**: Tailor the logging output to suit your preferences and requirements.
- **Integration**: Seamlessly integrate Pretty Chopper Logger into your Chopper client with just a few lines of code.
- **Compatibility**: Compatible with the latest versions of Chopper and Dart, ensuring smooth integration with your existing projects.

## Usage

To start using Pretty Chopper Logger in your project, simply follow these steps:

1. **Install the Package**: Add `pretty_chopper_logger` to your `pubspec.yaml` file:

```yaml
dependencies:
  pretty_chopper_logger: ^latest_version
```

2. **Import the Package**: Import the package into your Dart file:

```dart
import 'package:pretty_chopper_logger/pretty_chopper_logger.dart';
```

3. **Add Interceptor**: Create a Chopper client and add `PrettyChopperLogger` to its interceptors:

```dart
final ChopperClient chopper = ChopperClient(
  baseUrl: Uri.parse("http://www.mocky.io/"),
  interceptors: [PrettyChopperLogger()],
  services: [
    // Add your Chopper services here
  ],
);
```

4. **Start Logging**: With the interceptor added, network calls made through Chopper will now be logged in a visually appealing format.

## Customization

You can customize the logging behavior of Pretty Chopper Logger to better fit your needs. Here are some common customization options:

- **Log Levels**: Specify which log levels to include or exclude in the output.
- **Request and Response Formatting**: Define how request and response details are formatted in the logs.
- **Colors and Styles**: Adjust the colors and styles used for different parts of the log output.

Refer to the package documentation or source code for more information on customization options.

## Example

Here's an example of how the logged output looks:

![Response Example](https://raw.github.com/Arnooodles/pretty_chopper_logger/main/images/sample.png 'Response Example')

## Feedback and Contributions

If you encounter any issues, have suggestions for improvements, or would like to contribute to the project, please feel free to open an issue or pull request on the [GitHub repository](https://github.com/Arnooodles/pretty_chopper_logger). Your feedback and contributions are highly appreciated!
