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
      code: json['error']['code'],
      message: json['error']['message'],
      source: json['debug']['source'],
    );
  }

  @override
  String toString() => '$code: $message ($source)';
}
