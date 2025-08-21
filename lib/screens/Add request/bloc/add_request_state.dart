abstract class AddRequestState {}

class AddRequestInitial extends AddRequestState {}

class ProductAddedState extends AddRequestState {
  final List<Map<String, String>> productRequests;

  ProductAddedState({required this.productRequests});
}

class AddRequestErrorState extends AddRequestState {
  final String errorMessage;

  AddRequestErrorState({required this.errorMessage});
}

class ProductSearchState extends AddRequestState {
  final List<Map<String, dynamic>> products;

  ProductSearchState({required this.products});
}
