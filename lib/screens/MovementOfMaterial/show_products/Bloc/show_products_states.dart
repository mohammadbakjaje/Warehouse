// Abstract class for ProductState to represent all states
abstract class ProductState {}

// Initial state before any data is loaded
class ProductInitial extends ProductState {}

// State while products are being loaded
class ProductLoading extends ProductState {}

// State when products are successfully loaded
class ProductLoaded extends ProductState {
  final List<Map<String, dynamic>> products;

  ProductLoaded(this.products); // Constructor to pass the products list
}

// State when there is an error loading products
class ProductError extends ProductState {
  final String message;

  ProductError(this.message); // Constructor to pass the error message
}
