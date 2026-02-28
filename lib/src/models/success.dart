class SuccessLog {
  final String message;
  final String? page;
  final String timestamp;

  SuccessLog({required this.message, this.page, String? timestamp})
    : timestamp = timestamp ?? DateTime.now().toString();

  Map<String, dynamic> toMap() => {
    "message": message,
    "page": page,
    "timestamp": timestamp,
  };

  factory SuccessLog.fromMap(Map<String, dynamic> map) {
    return SuccessLog(
      message: map["message"] as String? ?? "",
      page: map["page"] as String?,
      timestamp: map["timestamp"] as String?,
    );
  }
}
