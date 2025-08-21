abstract class AddRequestEvent {}

class AddProductEvent extends AddRequestEvent {
  final String product;
  final String quantity;
  final String note;

  AddProductEvent(
      {required this.product, required this.quantity, required this.note});
}

class ClearAllEvent extends AddRequestEvent {}

class DeleteProductEvent extends AddRequestEvent {
  final int index;

  DeleteProductEvent({required this.index});
}

class SearchProductEvent extends AddRequestEvent {
  final String query;

  SearchProductEvent({required this.query});
}
