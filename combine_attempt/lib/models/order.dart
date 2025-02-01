import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/models/ordered_ulam.dart';

class UserOrder {
  final String id;
  final double deliveryFee;
  final String deliveryRiderID;
  Timestamp? finishOrderTime;
  final String mop;
  final double orderCost;
  final String orderStatus;
  final String deliveryRiderName;
  final double eta;
  final Timestamp orderTime;
  final String deliveryAddress;
  final List<OrderedUlam> orderedUlamsList;

  UserOrder(
      {required this.id,
      required this.deliveryFee,
      required this.deliveryRiderID,
      this.finishOrderTime,
      required this.mop,
      required this.eta,
      required this.deliveryRiderName,
      required this.orderCost,
      required this.orderStatus,
      required this.orderTime,
      required this.deliveryAddress,
      required this.orderedUlamsList});
}
