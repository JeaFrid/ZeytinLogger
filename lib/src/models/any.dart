class AnyLog {
  final String tag;
  final Map<String, dynamic> data;
  final String timestamp;

  AnyLog({required this.tag, required this.data, String? timestamp})
    : timestamp = timestamp ?? DateTime.now().toString();

  Map<String, dynamic> toMap() => {
    "tag": tag,
    "data": data,
    "timestamp": timestamp,
  };

  factory AnyLog.fromMap(Map<String, dynamic> map) {
    return AnyLog(
      tag: map["tag"] as String? ?? "",
      data: map["data"] as Map<String, dynamic>? ?? <String, dynamic>{},
      timestamp: map["timestamp"] as String?,
    );
  }
}
