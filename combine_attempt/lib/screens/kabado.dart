import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order extends StatefulWidget {
  final String docId;

  const Order({Key? key, required this.docId}) : super(key: key);

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  DocumentSnapshot? _foodSnapshot;
  Map<String, int> _ingredientQuantities = {};

  @override
  void initState() {
    super.initState();
    _fetchFoodDetails();
  }

  Future<void> _fetchFoodDetails() async {
    final DocumentSnapshot? foodDoc = await FirebaseFirestore.instance
        .collection('food')
        .doc(widget.docId)
        .get();

    if (mounted) {
      if (foodDoc != null && foodDoc.exists) {
        setState(() {
          _foodSnapshot = foodDoc;
        });
      } else {
        // Handle the case where the document doesn't exist
      }
    }
  }

  void _incrementQuantity(String ingredient) {
    setState(() {
      if (_ingredientQuantities.containsKey(ingredient)) {
        _ingredientQuantities[ingredient] =
            _ingredientQuantities[ingredient]! + 1;
      } else {
        _ingredientQuantities[ingredient] = 1;
      }
    });
  }

  void _decrementQuantity(String ingredient) {
    setState(() {
      if (_ingredientQuantities.containsKey(ingredient) &&
          _ingredientQuantities[ingredient]! > 0) {
        _ingredientQuantities[ingredient] =
            _ingredientQuantities[ingredient]! - 1;
      }
    });
  }

  double _calculateTotalPrice() {
    double totalPrice = 0.0;
    if (_foodSnapshot != null) {
      final List<String> priceList = _foodSnapshot!['price'].split(', ');

      _ingredientQuantities.forEach((ingredient, quantity) {
        int index =
            _foodSnapshot!['ingredients'].split(', ').indexOf(ingredient);
        if (index >= 0 && index < priceList.length) {
          totalPrice += quantity * double.parse(priceList[index]);
        }
      });
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Details'),
      ),
      body: _foodSnapshot == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          20.0), // Adjust the radius as needed
                      child: Image.network(
                        _foodSnapshot!['image'],
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text('Description: ${_foodSnapshot!['description']}'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ingredients:'),
                      // Display ingredients with +/- buttons
                      for (var pair in _getIngredientsWithPrices(
                          _foodSnapshot!['ingredients'],
                          _foodSnapshot!['price']))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${pair['ingredient']} - ${pair['price']}'),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    _decrementQuantity(pair['ingredient']!);
                                  },
                                ),
                                Text(
                                  '${_ingredientQuantities[pair['ingredient']] ?? 0}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    _incrementQuantity(pair['ingredient']!);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      Text(
                          'Total: \₱${_calculateTotalPrice().toStringAsFixed(2)}'),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  List<Map<String, String>> _getIngredientsWithPrices(
      String ingredients, String prices) {
    List<String> ingredientList = ingredients.split(', ');
    List<String> priceList = prices.split(', ');

    List<Map<String, String>> ingredientsWithPrices = [];

    for (int i = 0; i < ingredientList.length; i++) {
      ingredientsWithPrices.add({
        'ingredient': ingredientList[i],
        'price': priceList.length > i ? priceList[i] : 'Price not available',
      });
    }

    return ingredientsWithPrices;
  }
}
