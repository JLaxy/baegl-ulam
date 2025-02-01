import 'package:flutter/material.dart';
import 'package:login/models/order.dart';
import 'package:login/models/ordered_ulam.dart';

class ShowOrder extends StatefulWidget {
  const ShowOrder({super.key, required this.order});
  final UserOrder order;

  @override
  State<ShowOrder> createState() => _ShowOrderState();
}

class _ShowOrderState extends State<ShowOrder> {
  // Easy to edit values
  static const estDelTimeTextStyle = TextStyle();
  static const timeTextStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const orderDetailsStyle = TextStyle(fontWeight: FontWeight.bold);
  static const orderDetailsLeftTextStyle = TextStyle();
  static const orderDetailsRightTextStyle = TextStyle();
  static const dividerPadding = 20.0;
  static const orderDetailsRowPadding = 20.0;
  static const orderUlamDetailsPadding =
      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10);
  late double orderUlamTotalCost = 0;

  // Image Icons
  static const List<DecorationImage> images = [
    DecorationImage(
      fit: BoxFit.contain,
      image: NetworkImage(
          "https://static.vecteezy.com/system/resources/previews/027/238/039/original/cute-chef-cooking-food-clipart-illustration-ai-generative-png.png"),
    ),
    DecorationImage(
      fit: BoxFit.contain,
      image: NetworkImage(
          "https://cdn-icons-png.flaticon.com/512/5610/5610944.png"),
    )
  ];

  // Builds screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: _buildScrollView());
  }

  // ScrollView of page
  SingleChildScrollView _buildScrollView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Estimated Delivery Time Text
          _buildEstDelTimeText(),
          // Order Status Text
          _buildOrderStatusText(),
          // Image Icon
          _buildImageIcon(),
          // Divider
          _buildDivider(),
          // Order details text
          _buildOrderDetailsText(),
          // Order details container
          _buildOrderDetailsContainer(),
          // Divider
          _buildDivider(),
          // Order Ulam Details
          _buildOrderUlamDetailsContainer(),
          // Final Prices Container
          _buildFinalPriceContainer()
        ],
      ),
    );
  }

  // Estimated Delivery Time Text
  Align _buildEstDelTimeText() => const Align(
        alignment: Alignment.center,
        child: Text(
          "Estimated Delivery Time",
          style: estDelTimeTextStyle,
        ),
      );

  // Order Status Text
  Text _buildOrderStatusText() => Text(
        (widget.order.orderStatus) == "complete"
            ? "Completed"
            : ("${widget.order.eta} Minutes"),
        style: timeTextStyle,
      );

  // Image Icon
  Container _buildImageIcon() => Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
            image: (widget.order.orderStatus) == "complete"
                ? images[1]
                : images[0]),
        width: 500,
        height: 250,
      );

  // returns Divider with Padding
  Padding _buildDivider() => const Padding(
        padding: EdgeInsets.only(left: dividerPadding, right: dividerPadding),
        child: Divider(
          thickness: 2,
          color: Colors.black,
        ),
      );

  // Order Details Text
  Align _buildOrderDetailsText() => const Align(
        alignment: Alignment.center,
        child: Text(
          "Order Details",
          style: orderDetailsStyle,
        ),
      );

  // Order Details Container
  Container _buildOrderDetailsContainer() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          _buildOrderDetailsRow("Your Order Number", widget.order.id),
          _buildOrderDetailsRow(
              "Delivery Address", widget.order.deliveryAddress),
          _buildOrderDetailsRow("Rider ID", widget.order.deliveryRiderID),
          _buildOrderDetailsRow("Rider Name", widget.order.deliveryRiderName),
          _buildOrderCompletionTimeRow(),
        ],
      ),
    );
  }

  // Order Completion Time
  Row _buildOrderCompletionTimeRow() {
    // Checks if orderstatus is complete
    if (widget.order.orderStatus == "complete") {
      // Then show order completion time
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              left: orderDetailsRowPadding,
            ),
            child: Text("Completion Time"),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: orderDetailsRowPadding,
            ),
            child: Text(widget.order.finishOrderTime!.toDate().toString()),
          ),
        ],
      );
    }
    // Else, return empty row
    return Row();
  }

  // Returns row in order details
  Row _buildOrderDetailsRow(String text1, String text2) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: orderDetailsRowPadding),
            child: Text(text1, style: orderDetailsLeftTextStyle),
          ),
          Padding(
            padding: const EdgeInsets.only(right: orderDetailsRowPadding),
            child: Text(
              text2,
              style: orderDetailsRightTextStyle,
            ),
          )
        ],
      );

  // Ulam Details Container
  Container _buildOrderUlamDetailsContainer() {
    var ulamList = widget.order.orderedUlamsList;
    return Container(
      padding: orderUlamDetailsPadding,
      child: Row(
        children: [
          Expanded(
            flex: 0,
            child: Container(
              child: _buildOrderUlamQuantityCols(ulamList),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: _buildOrderUlamNameCols(ulamList),
            ),
          ),
          Expanded(
            flex: 0,
            child: Container(
              child: _buildOrderUlamPricesCols(ulamList),
            ),
          ),
        ],
      ),
    );
  }

  // Quantity Column
  Column _buildOrderUlamQuantityCols(List<OrderedUlam> localList) {
    List<Text> quantities = [];
    for (var ulam in localList) {
      quantities.add(
        Text(
          ulam.quantity.toString(),
        ),
      );
    }

    return Column(
      children: [
        const Text("Quantity", style: TextStyle(fontWeight: FontWeight.bold)),
        ...quantities
      ],
    );
  }

  // Ulam Name Column
  Column _buildOrderUlamNameCols(List<OrderedUlam> localList) {
    List<Widget> names = [];
    for (var ulam in localList) {
      names.add(
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(ulam.ulamName),
          ),
        ),
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Ulam", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        ...names,
      ],
    );
  }

  // Ulam Price Column
  Column _buildOrderUlamPricesCols(List<OrderedUlam> localList) {
    List<Widget> prices = [];

    for (var ulam in localList) {
      var price = ulam.price;
      orderUlamTotalCost += price;

      prices.add(
        Align(
          alignment: Alignment.centerRight,
          child: Text(price.toString()),
        ),
      );
    }

    print(orderUlamTotalCost);

    return Column(
      children: [
        const Align(
          alignment: Alignment.centerRight,
          child: Text("Price", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...prices,
      ],
    );
  }

  // Final Prices Container
  Align _buildFinalPriceContainer() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: orderUlamDetailsPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Subtotal Text
            Text(
              "Subtotal: $orderUlamTotalCost",
              style: orderDetailsStyle,
            ),
            // Delivery Fee Text
            Text(
              "Delivery Fee: ${widget.order.deliveryFee}",
              style: orderDetailsStyle,
            ),
            // Order Total Text
            Text(
              "Order Total: ${orderUlamTotalCost + widget.order.deliveryFee}",
              style: orderDetailsStyle,
            ),
          ],
        ),
      ),
    );
  }
}
