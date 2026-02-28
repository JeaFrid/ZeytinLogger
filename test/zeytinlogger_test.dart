import 'package:test/test.dart';
import 'package:zeytinlogger/zeytinlogger.dart';

void main() {
  late ZeytinLogger logger;

  setUp(() async {
    logger = ZeytinLogger();
    // Using an isolated directory path for tests
    await logger.init('./test_logs');
    await logger.clearAllLogs();
  });

  tearDown(() async {
    // Cleaning up the environment after each test
    await logger.clearAllLogs();
  });

  group('ZeytinLogger Tests', () {
    test('init() creates storage and connects successfully', () async {
      // Expected to return normally as it is called in setUp
      expect(() async => await logger.init('./test_logs'), returnsNormally);
    });

    test('Should be able to add and read a log (InfoLog)', () async {
      await logger.info(InfoLog(message: 'Test info message'));

      final logs = await logger.getInfoLogs();
      expect(logs, isNotEmpty);
      expect(logs.first.toMap()['message'], 'Test info message');
    });

    test('Logs should be ordered by timestamp in descending order', () async {
      await logger.success(SuccessLog(message: 'First'));
      await Future.delayed(const Duration(milliseconds: 100));
      await logger.success(SuccessLog(message: 'Second'));

      final logs = await logger.getSuccessLogs(descending: true);
      expect(logs.first.toMap()['message'], 'Second');
    });

    test('where() should filter logs correctly', () async {
      await logger.error(ErrorLog(errorMessage: 'Network error'));
      await logger.error(ErrorLog(errorMessage: 'Unauthorized'));
      final filtered = await logger.whereErrorLogs(
        (log) => log['errorMessage'] == 'Unauthorized',
      );

      expect(filtered.length, 1);
      expect(filtered.first.toMap()['errorMessage'], 'Unauthorized');
    });

    test('contains() should return the correct boolean value', () async {
      await logger.attention(AttentionLog(message: 'Warning'));

      final exists = await logger.containsAttentionLog(
        (log) => log['message'] == 'Warning',
      );
      final notExists = await logger.containsAttentionLog(
        (log) => log['message'] == 'None',
      );

      expect(exists, isTrue);
      expect(notExists, isFalse);
    });

    test('removeWhere() should delete logs matching the condition', () async {
      await logger.any(AnyLog(tag: "A", data: {'tag': 'A'}));
      await logger.any(AnyLog(tag: "B", data: {'tag': 'B'}));

      await logger.removeWhereAnyLog((log) => log['tag'] == 'A');

      final remainingLogs = await logger.getAnyLogs();
      expect(remainingLogs.length, 1);
      expect(remainingLogs.first.toMap()['tag'], 'B');
    });

    test('clearAllLogs() should reset all boxes', () async {
      await logger.info(InfoLog(message: 'Info'));
      await logger.error(ErrorLog(errorMessage: 'Error'));

      await logger.clearAllLogs();

      final infos = await logger.getInfoLogs();
      final errors = await logger.getErrorLogs();

      expect(infos, isEmpty);
      expect(errors, isEmpty);
    });
  });
}
