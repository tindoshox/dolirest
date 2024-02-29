class DataOrException {
  DataOrException(
      {this.data, this.errorMessage, this.hasError = false, this.statusCode});
  dynamic data;
  bool hasError;
  int? statusCode;
  String? errorMessage;
}
