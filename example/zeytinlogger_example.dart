import 'package:zeytinlogger/zeytinlogger.dart';

void main() async {
  final logger = ZeytinLogger();

  // 1. Initialization
  await logger.init('./logs_directory');

  // 2. Adding Different Types of Logs
  await logger.info(InfoLog(message: 'Application started successfully.'));
  await logger.success(SuccessLog(message: 'User logged in.'));
  await logger.error(ErrorLog(errorMessage: 'Connection timed out.'));
  await logger.attention(AttentionLog(message: 'Storage space is below 10%.'));
  await logger.any(
    AnyLog(tag: "login", data: {'action': 'click', 'button': 'login'}),
  );

  // 3. Fetching Logs (Descending by default)
  final allErrors = await logger.getErrorLogs();
  for (var error in allErrors) {
    print('Error: ${error.toMap()}');
  }

  // 4. Filtering Logs (Where)
  final timeoutErrors = await logger.whereErrorLogs(
    (log) => log['code'] == 408,
  );
  print('Timeout Errors Count: ${timeoutErrors.length}');

  // 5. Checking for a Specific Log (Contains)
  final hasStorageWarning = await logger.containsAttentionLog(
    (log) => log['message']?.contains('Storage') ?? false,
  );
  print('Is there a storage warning? $hasStorageWarning');

  // 6. Conditional Log Removal (RemoveWhere)
  await logger.removeWhereAnyLog((log) => log['action'] == 'click');

  // 7. Clearing Categories and All Logs
  await logger.clearInfoLogs(); // Clears only Info logs
  await logger.clearAllLogs(); // Clears all log boxes
}
