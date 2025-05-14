class AppStrings {
  static const strNoRouteFound = "no_route_found";
  static const strAppName = "app_name";

  static const String strSuccess = "success";
  // error handler
  static const String strBadRequestError = "Bad Request";
  static const String strNoContent = "No Content";
  static const String strForbiddenError = "Forbidden";
  static const String strUnauthorizedError = "Incorrect API key";
  static const String strNotFoundError = "Not Found";
  static const String strConflictError = "conflict_error";
  static const String strInternalServerError = "Internal Server Error";
  static const String strUnknownError = "Unknown Error";
  static const String strTimeoutError = "Timeout Error";
  static const String strDefaultError = "Default Error";
  static const String strCacheError = "Cache Error";
  static const String strNoInternetError = "No Internet";
}

class DocumentType {
  static const String invoice = "0";
  static const String typeCreditNote = "2";
}

class DocumentStatus {
  //Invoice Status
  static const String unpaid = "1";
  static const String draft = "2";
  static const String paid = "0";
  static const String cancelled = "";
}
