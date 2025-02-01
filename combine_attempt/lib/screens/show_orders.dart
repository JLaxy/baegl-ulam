import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/models/order.dart';
import 'package:login/models/ordered_ulam.dart';
import 'package:login/screens/show_order.dart';

class ShowOrders extends StatefulWidget {
  const ShowOrders({Key? key, required this.docID});
  final String docID;

  @override
  State<ShowOrders> createState() => _ShowOrdersState();
}

class _ShowOrdersState extends State<ShowOrders> {
  // Easy to edit values
  static const double listViewItemHoriPadding = 15;
  static const double listViewItemVertPadding = 10;
  static const int statusBarBGColor = 0xffdedcdb;
  static const double orderItemContainerRadius = 20;
  static const double orderItemContainerHeight = 70;
  late final Future<List<UserOrder>> futureOrderList;
  late List<UserOrder>? orderList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureOrderList = _retrieveOrders();
  }

  // Builds orders
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: FutureBuilder(
        future: futureOrderList,
        builder: (context, snapshot) {
          // Handles operations
          switch (snapshot.connectionState) {
            // If still retrieving
            case ConnectionState.waiting:
              // Show loading screen
              return const Center(child: CircularProgressIndicator());
            // If done retrieving
            case ConnectionState.done:
              print(snapshot);
              if (snapshot.hasError) {
                return const Center(
                  child: Text("error retrieving"),
                );
              } else if (snapshot.hasData) {
                orderList = snapshot.data;
                print("number of orders");
                print(orderList?.length.toString() as String);
                return _buildOrders();
              } else {
                return const Center(
                  child: Text("unkown if-else defaulted"),
                );
              }
            default:
              return const Center(
                child: Text("tite"),
              );
          }
        },
      ),
    );
  }

  // Retrieves user orders from Firebase.
  Future<List<UserOrder>> _retrieveOrders() async {
    // Retrieveing data from Firebase
    List<UserOrder> localOrderList = [];
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.docID)
          .collection('orders')
          .get();

      final listOfOrders = snapshot.docs.toList();

      print(listOfOrders.length);

      // For each user order, process it
      listOfOrders.forEach(
        (element) async {
          localOrderList.add(await _processOrder(element.data(), element.id));
        },
      );
    } catch (e) {
      print("Error in _retrieveOrder function");
      print(e);
    }

    // TEMPORARY; WILL NOT WORK IF YOU REMOVE THIS; THE PROBLEM IS THAT IT IS NOT WAITING FOR THE FOREACH METHOD ABOVE
    await Future.delayed(Duration(seconds: 1));
    return localOrderList;
  }

  // Creates User Orders
  Future<UserOrder> _processOrder(orderInfo, String iD) async {
    List<OrderedUlam> ulamList = [];

    try {
      // Retrieving data from Firebase
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.docID)
          .collection('orders')
          .doc(iD)
          .collection("ulams_ordered_info")
          .get();

      // Converting result to list
      final ulams = snapshot.docs.toList();

      // For each ulam in the list, create OrderedUlam object then add to ulamList
      ulams.forEach(
        (element) {
          var ulam = element.data();
          // add object to list
          ulamList.add(
            OrderedUlam(
              id: element.id,
              ulamName: ulam["ulam_name"],
              quantity: ulam["quantity"],
              price: ulam["price"].toDouble(),
            ),
          );
        },
      );
    } catch (e) {
      print("Error in _processOrder function");
      print(e);
    }

    // Return new order
    return UserOrder(
        id: iD,
        deliveryFee: orderInfo["delivery_fee"].toDouble(),
        finishOrderTime: orderInfo["finish_order_time"],
        mop: orderInfo["mop"],
        orderCost: orderInfo["order_cost"].toDouble(),
        orderStatus: orderInfo["order_status"],
        eta: orderInfo["eta"].toDouble(),
        deliveryRiderName: orderInfo["delivery_rider_name"],
        orderTime: orderInfo["order_time"],
        deliveryAddress: orderInfo["delivery_address"],
        orderedUlamsList: ulamList,
        deliveryRiderID: orderInfo["delivery_rider_id"]);
  }

  ListView _buildOrders() {
    List<GestureDetector> localList = [];
    List<Padding> rows = [];
    var count = 0;

    for (var order in orderList!) {
      localList.add(_buildOrderItemWidget(order.orderTime.toDate().toString(),
          order.orderStatus.toUpperCase(), order));
      ++count;

      // If will add 2 to column
      if (localList.length == 2) {
        rows.add(
          _addListToView(
            _buildColumn(localList[0], localList[1]),
          ),
        );
        localList.clear();
        //If will only add 1 to column
      } else if (count == orderList!.length) {
        rows.add(
          _addListToView(
            _buildSoloColumn(localList[0]),
          ),
        );
        localList.clear();
      }
    }

    return ListView(
      children: [...rows],
    );
  }

  // Adds column orders in a listview row
  Padding _addListToView(Widget localColumn) {
    return Padding(
        padding: const EdgeInsets.only(
            left: listViewItemHoriPadding,
            right: listViewItemHoriPadding,
            top: listViewItemVertPadding,
            bottom: listViewItemVertPadding),
        child: localColumn);
  }

  // Places Order Item Widget into columns
  Row _buildColumn(GestureDetector order1, GestureDetector order2) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [order1, order2]);
  }

  Column _buildSoloColumn(GestureDetector order1) {
    return Column(children: [order1]);
  }

  // Builds Order Item Widget
  GestureDetector _buildOrderItemWidget(
      String timeStamp, String status, UserOrder order) {
    return GestureDetector(
      // Action; Navigates to order tapped
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ShowOrder(
                  order: order,
                )),
      ),
      // Contains order image and status
      child: Container(
        decoration: const BoxDecoration(
          color: Color(statusBarBGColor),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(orderItemContainerRadius),
            topRight: Radius.circular(orderItemContainerRadius),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: orderItemContainerHeight,
              child: Align(alignment: Alignment.center, child: Text(timeStamp)),
            ),
            Text("Status: $status")
          ],
        ),
      ),
    );
  }
}
