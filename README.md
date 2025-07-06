# pretty_chopper_logger

[![Pub](https://img.shields.io/pub/v/pretty_chopper_logger.svg)](https://pub.dev/packages/pretty_chopper_logger)

Pretty Chopper logger is a Chopper interceptor designed to enhance the logging of network calls in Dart applications. Inspired by the popular  [pretty_dio_logger](https://pub.dev/packages/pretty_dio_logger) package, it aims to provide developers with a clear and readable format for debugging network requests and responses.

## ✨ Features

- **Beautiful Logging**: Visually appealing, formatted output for requests and responses
- **Multiple Log Levels**: Control the amount of information logged (none, basic, headers, body)
- **Customizable Formatting**: Adjust border width, indentation, and output style
- **JSON Pretty Printing**: Automatically formats JSON responses for readability
- **Easy Integration**: Simple setup with just a few lines of code
- **Production Safe**: Configurable to avoid logging sensitive data

## 📦 Installation

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

## ⚙️ Customization

You can customize the logging behavior of Pretty Chopper Logger to better fit your needs. The `PrettyChopperLogger` constructor accepts several parameters:

```dart
PrettyChopperLogger({
  this.level = Level.body,      // Controls logging detail level
  this.maxWidth = 120,          // Maximum width for border lines
  this.indentSize = 2,          // Indent size for JSON formatting
})
```

### 📋 Log Levels

The `level` parameter controls the amount of information logged:

- **`Level.none`**: No logs are output
- **`Level.basic`**: Logs request and response lines only
- **`Level.headers`**: Logs request/response lines and their respective headers
- **`Level.body`**: Logs request/response lines, headers, and bodies (if present) - **default**

### Formatting Options

- **`maxWidth`**: Controls the width of the border lines used in the log output (default: 120 characters)
- **`indentSize`**: Sets the number of spaces used for JSON indentation (default: 2 spaces)


## 📱 Example Output

Here's an example of how the logged output looks:

![Response Example](https://raw.github.com/Arnooodles/pretty_chopper_logger/main/images/sample.png 'Response Example')

## 🤝 Feedback and Contributions

If you encounter any issues, have suggestions for improvements, or would like to contribute to the project, please feel free to open an issue or pull request on the [GitHub repository](https://github.com/Arnooodles/pretty_chopper_logger). Your feedback and contributions are highly appreciated!
