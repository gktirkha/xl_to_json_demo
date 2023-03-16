class ExcelException implements Exception {
  String message;
  ExcelException(this.message);
  @override
  String toString() {
    return message;
  }
}
