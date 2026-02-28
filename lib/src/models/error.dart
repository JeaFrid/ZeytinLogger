class ErrorLog {
  final String errorMessage;
  final String? page;
  final StackTrace? stackTrace;
  final String timestamp;

  ErrorLog({
    required this.errorMessage,
    this.page,
    this.stackTrace,
    String? timestamp,
  }) : timestamp = timestamp ?? DateTime.now().toString();

  Map<String, dynamic> toMap() {
    return {
      "errorMessage": errorMessage,
      "page": page,
      "stackTrace": stackTrace?.toString(),
      "timestamp": timestamp,
    };
  }

  factory ErrorLog.fromMap(Map<String, dynamic> map) {
    return ErrorLog(
      errorMessage: map["errorMessage"] as String? ?? "",
      page: map["page"] as String?,
      stackTrace: map["stackTrace"] != null
          ? StackTrace.fromString(map["stackTrace"] as String)
          : null,
      timestamp: map["timestamp"] as String?,
    );
  }
}
