import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visa_curbside/models/order.dart';
import 'package:visa_curbside/models/dataStore.dart';
import '../settings/settings.dart';
import 'package:visa_curbside/screens/order/pendingOrder.dart';
import './pickupOrder.dart';
import './pastOrder.dart';
import '../../models/store.dart';
import 'package:visa_curbside/services/DatabaseHelper.dart';
import 'package:visa_curbside/shared/constants.dart';
import 'dart:async';

DatabaseHelper databaseHelper = new DatabaseHelper();

class OrderPage extends StatefulWidget {
  
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  _liveUpdates() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {});
      timer.cancel();
     });
  }
  @override
  Widget build(BuildContext context) {
    //_liveUpdates();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        heroTag: "order screen",
        transitionBetweenRoutes: false,
        middle: Text("Visa Curbside"),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
              SizedBox(height: 15,),
              FutureBuilder<List<Order>>(
                future: databaseHelper.getOrdersFromUID(globalUser.uid.toString()),
                initialData: List(),
                builder: (context, snapshot) {
                    
                  
                  return snapshot.hasData ?
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, int position) {
                        final order = snapshot.data[position];
                        
                        if (order.isPending == 1 && order.isReadyForPickup == 0) {
                          return PendingOrderCard(order);
                        } else if (order.isPending == 0 && order.isReadyForPickup == 1) {
                          return PickupOrderCard(order); 
                        } else if (order.isPending == 0 && order.isReadyForPickup == 0) {
                          return PastOrderCard(order);
                        } else if (order.isPending == 1 || order.isPending == 1) {
                          return PendingOrderCard(order);
                        } else if (order.shopperID == "READY_FOR_PICKUP_HEADER") {
                          return Text(" Ready for Pick Up", style: kOrderHeadersTextStyle);
                        } else if (order.shopperID == "PENDING_HEADER") {
                          return Text(" Pending Orders", style: kOrderHeadersTextStyle);
                        } else if (order.shopperID == "PAST_ORDER_HEADER") {
                          return Text(" Past Orders", style: kOrderHeadersTextStyle);
                        } else if (order.shopperID == "NO_READY_FOR_PICKUP_ORDERS") {
                          return Center(child: Text("No Orders", style: TextStyle(fontSize: 12, color: Colors.grey),),);
                        } else if (order.shopperID == "NO_PENDING_ORDERS") {
                          return Center(child: Text("No Orders", style: TextStyle(fontSize: 12, color: Colors.grey),),);
                        } else if (order.shopperID == "NO_PAST_ORDERS") {
                          return Center(child: Text("No Orders", style: TextStyle(fontSize: 12, color: Colors.grey),),);
                        }
                      }
                    ),
                  )
                : 
                Center(
                  child: CircularProgressIndicator()
                );
                }
              )
          ],
        ),
      ),
    );
  }
}
