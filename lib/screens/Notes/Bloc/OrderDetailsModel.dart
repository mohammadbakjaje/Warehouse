// order_details_model.dart
class OrderDetailsModel {
  final int id;
  final String status;
  final List<Item> items;

  OrderDetailsModel({
    required this.id,
    required this.status,
    required this.items,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<Item> itemList = itemsList.map((i) => Item.fromJson(i)).toList();

    return OrderDetailsModel(
      id: json['id'],
      status: json['status'],
      items: itemList,
    );
  }
}

class Item {
  final String productName;
  final int quantityRequested;
  final int quantityApproved;

  Item({
    required this.productName,
    required this.quantityRequested,
    required this.quantityApproved,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      productName: json['product']['name'],
      quantityRequested: json['quantity_requested'],
      quantityApproved:
          json['quantity_approved'] == null ? 0 : json['quantity_approved'],
    );
  }
}
