# 🫒 ZeytinLogger

_Developed with love by JeaFriday!💚🫒_

<p align="center">
  <a href="https://buymeacoffee.com/jeafriday">
    <img src="https://img.buymeacoffee.com/button-api/?text=Support me&emoji=☕&slug=jeafriday&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff" alt="Support me" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/JeaFrid">
    <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub" />
  </a>
  <a href="https://pub.dev/publishers/jeafriday.com/packages">
    <img src="https://img.shields.io/badge/Pub.dev-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Pub.dev" />
  </a>
  <a href="https://www.linkedin.com/in/jeafriday/">
    <img src="https://img.shields.io/badge/LinkedIn-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn" />
  </a>
  <a href="https://t.me/jeafrid">
    <img src="https://img.shields.io/badge/Telegram-26A8EA?style=for-the-badge&logo=telegram&logoColor=white" alt="Telegram" />
  </a>
</p>

**ZeytinLogger** is a fast and flexible logging package that allows you to catch error messages, analytics, test results, and information in your projects, and store and manage them locally (local storage) with the [ZeytinX](https://pub.dev/packages/zeytinx) infrastructure.

---

## ✨ Features

- **📦 Local Storage:** Safely stores your logs on the device without needing an internet connection.
- **🗂️ Categorical Logging:** Keeps your data organized with 5 different log models (`Info`, `Success`, `Error`, `Attention`, `Any`).
- **⏱️ Automatic Timestamp:** Automatically processes the current time (`timestamp`) instantly into every added log record.
- **🔍 Advanced Filtering:** Allows you to perform advanced queries such as `where`, `contains`, `removeWhere` on logs.
- **🧹 Easy Management:** Clear either a single category or all logs in a single line.

---

## 🚀 Installation

Including ZeytinLogger in your project is very easy. You can add the package by typing the following command into your terminal:

**For Dart Projects:**

```bash
dart pub add zeytinlogger
```

**For Flutter Projects:**

```bash
flutter pub add zeytinlogger
```

Or add it manually to your `pubspec.yaml` file:

```yaml
dependencies:
  zeytinlogger: ^1.0.0
```

Then import the package into your file:

```dart
import 'package:zeytinlogger/zeytinlogger.dart';
```

---

## 🛠️ Getting Started

Before using ZeytinLogger, you need to initialize it by specifying the directory where the logs will be saved.

```dart
void main() async {
  final logger = ZeytinLogger();

  // Initialize the package by specifying the folder path where the logs will be stored.
  await logger.init('./logs_directory');
}
```

> **Note:** In Flutter projects, you can obtain a secure folder path on mobile devices by using the `getApplicationDocumentsDirectory()` path with the `path_provider` package.

---

## 📖 Usage and Features

ZeytinLogger manages your data in 5 different boxes. Each has its own models and methods.

### 1. Adding Logs (Adding Logs)

Select the log model that suits your needs and save it. Each record is automatically printed to the console in a colorful way and saved to local storage.

```dart
final logger = ZeytinLogger();

// 💡 Information Log (Info)
await logger.info(InfoLog(
  message: 'Application started successfully.',
  page: 'SplashView',
  data: {'version': '1.0.0'}
));

// ✅ Success Log (Success)
await logger.success(SuccessLog(
  message: 'User logged into the system.',
  page: 'LoginView',
));

// ❌ Error Log (Error)
await logger.error(ErrorLog(
  errorMessage: 'Server connection timed out.',
  page: 'NetworkService',
  stackTrace: StackTrace.current,
));

// ⚠️ Attention Log (Attention)
await logger.attention(AttentionLog(
  message: 'Device storage space is below 10%.',
  data: {'freeSpace': '1.2GB'}
));

// 🔄 General Log (Any) - For custom trackings
await logger.any(AnyLog(
  tag: "user_action",
  data: {'action': 'click', 'button': 'login'}
));
```

### 2. Reading Logs (Fetching Logs)

You can easily fetch the logs you saved based on their timestamp (from newest to oldest by default `descending: true`).

```dart
// Fetches all error logs.
final allErrors = await logger.getErrorLogs();

for (var error in allErrors) {
  print('Error: ${error.errorMessage} - Time: ${error.timestamp}');
}
```

### 3. Filtering Logs (Where)

You can use `where` functions to list logs that satisfy a specific condition.

```dart
// Fetch only the errors that occurred on the NetworkService page.
final networkErrors = await logger.whereErrorLogs(
  (log) => log['page'] == 'NetworkService',
);

print('${networkErrors.length} network errors found.');
```

### 4. Record Checking (Contains)

You can quickly check whether a specific record you are looking for exists as a boolean (`true/false`).

```dart
// Is there a warning about Storage (Storage)?
final hasStorageWarning = await logger.containsAttentionLog(
  (log) => log['message']?.contains('Storage') ?? false,
);

if(hasStorageWarning) {
  print('Show storage warning to the user!');
}
```

### 5. Conditional Deletion (RemoveWhere)

You can bulk delete logs that meet specific conditions.

```dart
// Delete all Any logs whose action is 'click'.
await logger.removeWhereAnyLog((log) => log['action'] == 'click');
```

### 6. Clearing (Clearing Logs)

You can clear logs categorically or all at once.

```dart
// Clear only Info (Information) logs.
await logger.clearInfoLogs();

// Completely clear all logs in all categories from the database.
await logger.clearAllLogs();
```

---

## 🏗️ Models

ZeytinLogger uses custom classes to keep data organized. All models take the `timestamp` (time stamp) parameter optionally; if not provided, it is created automatically.

| Model          | Required Parameters  | Optional Parameters    | Purpose of Use                                 |
| :------------- | :------------------- | :--------------------- | :--------------------------------------------- |
| `InfoLog`      | `message`            | `page`, `data`         | General information and status notifications   |
| `SuccessLog`   | `message`            | `page`                 | Successful operations (Login, Register etc.)   |
| `ErrorLog`     | `errorMessage`       | `page`, `stackTrace`   | Errors (Try-catch blocks etc.)                 |
| `AttentionLog` | `message`            | `page`, `data`         | Non-critical but attention-requiring situations|
| `AnyLog`       | `tag`, `data`        | -                      | Custom analytic data, click metrics etc.       |

---

## 🤝 Contributing

This project is open-source and open to your contributions! Please do not hesitate to open an Issue (problem) or submit a Pull Request (pull request).