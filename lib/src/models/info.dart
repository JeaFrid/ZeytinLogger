class InfoLog {
  final String message;
  final String? page;
  final Map<String, dynamic>? data;
  final String timestamp;

  InfoLog({required this.message, this.page, this.data, String? timestamp})
    : timestamp = timestamp ?? DateTime.now().toString();

  Map<String, dynamic> toMap() => {
    "message": message,
    "page": page,
    "data": data,
    "timestamp": timestamp,
  };

  factory InfoLog.fromMap(Map<String, dynamic> map) {
    return InfoLog(
      message: map["message"] as String? ?? "",
      page: map["page"] as String?,
      data: map["data"] as Map<String, dynamic>?,
      timestamp: map["timestamp"] as String?,
    );
  }
}
