class ApiOption {
  final String baseUrl;
  final String apiKey;

  bool get invalid => baseUrl == null || apiKey == null;

  ApiOption({this.baseUrl, this.apiKey});
}
