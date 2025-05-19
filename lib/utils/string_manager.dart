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

class ValidationStatus {
  //Invoice Status
  static const String draft = "0"; ////"statut": "0"
  static const String validated = "1"; //"statut": "1"
  static const String creditAvalable = "2"; //"statut": "2"
}

class PaidStatus {
//Payment state
  static const String unpaid = "0"; //"paye": "0"
  static const String paid = "1"; //"paye": "1"
}
