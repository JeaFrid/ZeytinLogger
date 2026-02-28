import 'package:zeytinlogger/zeytinlogger.dart';
import 'package:zeytinx/zeytinx.dart';

/// A logger class that manages different types of logs using the ZeytinX local storage package.
class ZeytinLogger {
  // Instance of ZeytinX used to handle the actual data storage and retrieval.
  final ZeytinX _x = ZeytinX("ZeytinLoggerState", "ZeytinLoggerState");

  /// Initializes the logger with a given base path where the log files will be stored.
  Future<void> init(String basePath) async {
    await _x.initialize(basePath);
  }

  /// Helper method to print an error message to the console if a ZeytinX operation fails.
  Future<void> _logErrorIfNotSuccess(
    ZeytinXResponse res,
    String logType,
  ) async {
    if (!res.isSuccess) {
      ZeytinXPrint.errorPrint("ZeytinLogger $logType Log Error: ${res.error}");
    }
  }

  /// Injects the current timestamp into the log data map before saving it.
  Map<String, dynamic> _injectTimestamp(Map<String, dynamic> data) {
    data["timestamp"] = DateTime.now().toString();
    return data;
  }

  /// Core private method to add a new log entry to a specific storage box.
  Future<void> _addLog(
    String box,
    Map<String, dynamic> data,
    String logType,
  ) async {
    final res = await _x.add(box: box, value: _injectTimestamp(data));
    await _logErrorIfNotSuccess(res, logType);
  }

  /// Retrieves all logs from a specified box, converts them to a List of Maps,
  /// and sorts them by their injected timestamp.
  Future<List<Map<String, dynamic>>> _getLogs(
    String box, {
    bool descending = true,
  }) async {
    final res = await _x.getBox(box: box);

    // Return an empty list if the operation failed or no data exists.
    if (!res.isSuccess || res.data == null) return [];

    // Map the raw data into a strictly typed List of Maps.
    List<Map<String, dynamic>> logs = (res.data as Map<String, dynamic>).values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    // Sort the logs based on their timestamp.
    logs.sort((a, b) {
      final timeA =
          DateTime.tryParse(a["timestamp"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final timeB =
          DateTime.tryParse(b["timestamp"] ?? "") ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return descending ? timeB.compareTo(timeA) : timeA.compareTo(timeB);
    });

    return logs;
  }

  /// Returns a filtered list of logs from a specific box based on a test condition.
  Future<List<Map<String, dynamic>>> _whereLog(
    String box,
    bool Function(Map<String, dynamic>) test, {
    bool descending = true,
  }) async {
    final logs = await _getLogs(box, descending: descending);
    return logs.where(test).toList();
  }

  /// Checks if any log in a specific box satisfies a given test condition.
  Future<bool> _containsLog(
    String box,
    bool Function(Map<String, dynamic>) test,
  ) async {
    final logs = await _getLogs(box);
    return logs.any(test);
  }

  /// Iterates over a specific box and removes any log entries that match the test condition.
  Future<void> _removeWhereLog(
    String box,
    bool Function(Map<String, dynamic>) test,
  ) async {
    final res = await _x.getBox(box: box);
    if (!res.isSuccess || res.data == null) return;

    final dataMap = res.data as Map<String, dynamic>;
    for (var entry in dataMap.entries) {
      final logData = Map<String, dynamic>.from(entry.value as Map);
      if (test(logData)) {
        await _x.remove(box: box, tag: entry.key);
      }
    }
  }

  /// Deletes an entire box and all of its contents.
  Future<void> _clearBox(String box) async {
    await _x.removeBox(box: box);
  }

  /// Records a general 'Any' type log.
  Future<void> any(AnyLog log) async {
    ZeytinXPrint.successPrint(log.toMap().toString());
    await _addLog("any", log.toMap(), "Any");
  }

  /// Retrieves all 'Any' logs.
  Future<List<AnyLog>> getAnyLogs({bool descending = true}) async {
    final logs = await _getLogs("any", descending: descending);
    return logs.map((e) => AnyLog.fromMap(e)).toList();
  }

  /// Retrieves filtered 'Any' logs based on a condition.
  Future<List<AnyLog>> whereAnyLogs(
    bool Function(Map<String, dynamic>) test, {
    bool descending = true,
  }) async {
    final logs = await _whereLog("any", test, descending: descending);
    return logs.map((e) => AnyLog.fromMap(e)).toList();
  }

  /// Checks if a specific 'Any' log exists based on a condition.
  Future<bool> containsAnyLog(bool Function(Map<String, dynamic>) test) async =>
      await _containsLog("any", test);

  /// Removes 'Any' logs that match the given condition.
  Future<void> removeWhereAnyLog(
    bool Function(Map<String, dynamic>) test,
  ) async => await _removeWhereLog("any", test);

  /// Clears all 'Any' logs.
  Future<void> clearAnyLogs() async => await _clearBox("any");

  /// Records an 'Error' type log.
  Future<void> error(ErrorLog log) async {
    ZeytinXPrint.errorPrint(log.toMap().toString());
    await _addLog("error", log.toMap(), "Error");
  }

  /// Retrieves all 'Error' logs.
  Future<List<ErrorLog>> getErrorLogs({bool descending = true}) async {
    final logs = await _getLogs("error", descending: descending);
    return logs.map((e) => ErrorLog.fromMap(e)).toList();
  }

  /// Retrieves filtered 'Error' logs based on a condition.
  Future<List<ErrorLog>> whereErrorLogs(
    bool Function(Map<String, dynamic>) test, {
    bool descending = true,
  }) async {
    final logs = await _whereLog("error", test, descending: descending);
    return logs.map((e) => ErrorLog.fromMap(e)).toList();
  }

  /// Checks if a specific 'Error' log exists based on a condition.
  Future<bool> containsErrorLog(
    bool Function(Map<String, dynamic>) test,
  ) async => await _containsLog("error", test);

  /// Removes 'Error' logs that match the given condition.
  Future<void> removeWhereErrorLog(
    bool Function(Map<String, dynamic>) test,
  ) async => await _removeWhereLog("error", test);

  /// Clears all 'Error' logs.
  Future<void> clearErrorLogs() async => await _clearBox("error");

  /// Records a 'Success' type log.
  Future<void> success(SuccessLog log) async {
    ZeytinXPrint.successPrint(log.toMap().toString());
    await _addLog("success", log.toMap(), "Success");
  }

  /// Retrieves all 'Success' logs.
  Future<List<SuccessLog>> getSuccessLogs({bool descending = true}) async {
    final logs = await _getLogs("success", descending: descending);
    return logs.map((e) => SuccessLog.fromMap(e)).toList();
  }

  /// Retrieves filtered 'Success' logs based on a condition.
  Future<List<SuccessLog>> whereSuccessLogs(
    bool Function(Map<String, dynamic>) test, {
    bool descending = true,
  }) async {
    final logs = await _whereLog("success", test, descending: descending);
    return logs.map((e) => SuccessLog.fromMap(e)).toList();
  }

  /// Checks if a specific 'Success' log exists based on a condition.
  Future<bool> containsSuccessLog(
    bool Function(Map<String, dynamic>) test,
  ) async => await _containsLog("success", test);

  /// Removes 'Success' logs that match the given condition.
  Future<void> removeWhereSuccessLog(
    bool Function(Map<String, dynamic>) test,
  ) async => await _removeWhereLog("success", test);

  /// Clears all 'Success' logs.
  Future<void> clearSuccessLogs() async => await _clearBox("success");

  /// Records an 'Attention/Warning' type log.
  Future<void> attention(AttentionLog log) async {
    ZeytinXPrint.warningPrint(log.toMap().toString());
    await _addLog("attention", log.toMap(), "Attention");
  }

  /// Retrieves all 'Attention' logs.
  Future<List<AttentionLog>> getAttentionLogs({bool descending = true}) async {
    final logs = await _getLogs("attention", descending: descending);
    return logs.map((e) => AttentionLog.fromMap(e)).toList();
  }

  /// Retrieves filtered 'Attention' logs based on a condition.
  Future<List<AttentionLog>> whereAttentionLogs(
    bool Function(Map<String, dynamic>) test, {
    bool descending = true,
  }) async {
    final logs = await _whereLog("attention", test, descending: descending);
    return logs.map((e) => AttentionLog.fromMap(e)).toList();
  }

  /// Checks if a specific 'Attention' log exists based on a condition.
  Future<bool> containsAttentionLog(
    bool Function(Map<String, dynamic>) test,
  ) async => await _containsLog("attention", test);

  /// Removes 'Attention' logs that match the given condition.
  Future<void> removeWhereAttentionLog(
    bool Function(Map<String, dynamic>) test,
  ) async => await _removeWhereLog("attention", test);

  /// Clears all 'Attention' logs.
  Future<void> clearAttentionLogs() async => await _clearBox("attention");

  /// Records an 'Info' type log.
  Future<void> info(InfoLog log) async {
    ZeytinXPrint.successPrint(log.toMap().toString());
    await _addLog("info", log.toMap(), "Info");
  }

  /// Retrieves all 'Info' logs.
  Future<List<InfoLog>> getInfoLogs({bool descending = true}) async {
    final logs = await _getLogs("info", descending: descending);
    return logs.map((e) => InfoLog.fromMap(e)).toList();
  }

  /// Retrieves filtered 'Info' logs based on a condition.
  Future<List<InfoLog>> whereInfoLogs(
    bool Function(Map<String, dynamic>) test, {
    bool descending = true,
  }) async {
    final logs = await _whereLog("info", test, descending: descending);
    return logs.map((e) => InfoLog.fromMap(e)).toList();
  }

  /// Checks if a specific 'Info' log exists based on a condition.
  Future<bool> containsInfoLog(
    bool Function(Map<String, dynamic>) test,
  ) async => await _containsLog("info", test);

  /// Removes 'Info' logs that match the given condition.
  Future<void> removeWhereInfoLog(
    bool Function(Map<String, dynamic>) test,
  ) async => await _removeWhereLog("info", test);

  /// Clears all 'Info' logs.
  Future<void> clearInfoLogs() async => await _clearBox("info");

  /// Removes a specific log entry from a given box using its unique tag/key.
  Future<void> removeLog(String box, String tag) async {
    await _x.remove(box: box, tag: tag);
  }

  /// Completely clears all log boxes (any, error, success, attention, info).
  Future<void> clearAllLogs() async {
    await _x.removeBox(box: "any");
    await _x.removeBox(box: "error");
    await _x.removeBox(box: "success");
    await _x.removeBox(box: "attention");
    await _x.removeBox(box: "info");
  }
}
