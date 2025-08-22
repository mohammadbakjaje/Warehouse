class RequestState {
  final List<Map<String, String>> requests;
  final bool isLoading;
  final String error;

  RequestState({
    required this.requests,
    this.isLoading = false,
    this.error = "",
  });
}
