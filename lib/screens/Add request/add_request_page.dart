import 'package:flutter/material.dart';

class AddRequestPage extends StatefulWidget {
  static String id = "AddRequestPage";
  @override
  _AddRequestPage createState() => _AddRequestPage();
}

class _AddRequestPage extends State<AddRequestPage> {
  final TextEditingController productIdController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  List<Map<String, String>> productRequests = [];

  // Function to add product to the list
  void addProduct() {
    setState(() {
      productRequests.add({
        'id': productIdController.text,
        'quantity': quantityController.text,
        'note': noteController.text,
      });

      // Clear the inputs
      productIdController.clear();
      quantityController.clear();
      noteController.clear();
    });
  }

  // Function to clear all products in the list
  void clearAll() {
    setState(() {
      productRequests.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Material Request"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product ID'),
            TextField(
              controller: productIdController,
              decoration: InputDecoration(hintText: "Enter Product ID"),
            ),
            SizedBox(height: 16),
            Text('Quantity'),
            TextField(
              controller: quantityController,
              decoration: InputDecoration(hintText: "Enter Quantity"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text('Note'),
            TextField(
              controller: noteController,
              decoration: InputDecoration(hintText: "Add a note"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addProduct,
              child: Text("+ Add Product"),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: productRequests.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title:
                          Text('Product ID: ${productRequests[index]["id"]}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Quantity: ${productRequests[index]["quantity"]}'),
                          Text('Note: ${productRequests[index]["note"]}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            productRequests.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: clearAll,
                  child: Text('Clear All'),
                  style: ElevatedButton.styleFrom(),
                ),
                ElevatedButton(
                  onPressed: () {
                    // You can handle the submission logic here
                  },
                  child: Text('Submit Request'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
