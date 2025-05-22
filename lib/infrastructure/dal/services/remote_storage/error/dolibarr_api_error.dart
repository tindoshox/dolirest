class DolibarrApiError {
  final int code;
  final String message;
  final String source;

  DolibarrApiError({
    required this.code,
    required this.message,
    required this.source,
  });

  factory DolibarrApiError.fromJson(Map<String, dynamic> json) {
    return DolibarrApiError(
      code: json['error']?['code'] ?? -1,
      message: json['error']?['message'] ?? 'Unknown error',
      source: json['debug']?['source'] ?? 'Unknown source',
    );
  }

  factory DolibarrApiError.generic(dynamic error, [String source = 'Unknown']) {
    return DolibarrApiError(
      code: -1,
      message: error.toString(),
      source: source,
    );
  }

  @override
  String toString() => '$code: $message ($source)';
}
