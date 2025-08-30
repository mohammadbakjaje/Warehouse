class ProductMovement {
  final int id;
  final String name;
  final int quantity;
  final String unit;
  final String status;

  ProductMovement({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.status,
  });

  factory ProductMovement.fromJson(Map<String, dynamic> json) {
    return ProductMovement(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      unit: json['unit'],
      status: json['status'],
    );
  }
}

class MovementRecord {
  final int id;
  final int productId;
  final String type; // 'entry' or 'exit'
  final String referenceSerial;
  final int prvQuantity;
  final int noteQuantity;
  final int afterQuantity;
  final DateTime date;
  final String? imagePath;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  MovementRecord({
    required this.id,
    required this.productId,
    required this.type,
    required this.referenceSerial,
    required this.prvQuantity,
    required this.noteQuantity,
    required this.afterQuantity,
    required this.date,
    this.imagePath,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MovementRecord.fromJson(Map<String, dynamic> json) {
    return MovementRecord(
      id: json['id'],
      productId: json['product_id'],
      type: json['type'],
      referenceSerial: json['reference_serial'],
      prvQuantity: json['prv_quantity'],
      noteQuantity: json['note_quantity'],
      afterQuantity: json['after_quantity'],
      date: DateTime.parse(json['date']),
      imagePath: json['image_path'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class ProductMovementResponse {
  final bool success;
  final String message;
  final List<MovementRecord> data;

  ProductMovementResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductMovementResponse.fromJson(Map<String, dynamic> json) {
    return ProductMovementResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => MovementRecord.fromJson(item))
          .toList(),
    );
  }
}
