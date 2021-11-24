import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:products_deliveryboy/src/models/order_list.dart';
import 'package:products_deliveryboy/src/models/payment.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../generated/i18n.dart';
import '../repository/order_repository.dart';
import '../repository/order_repository.dart' as repository;

class OrderController extends ControllerMVC {
  List<OrderList> orders = <OrderList>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Payment paymentData =  new Payment();
  String mobileno;
  OrderController() {

    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }


   Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }


  void listenForOrdersHistory({String message}) async {
    final Stream<OrderList> stream = await getOrdersHistory();
    stream.listen((OrderList _order) {
      setState(() {
        orders.add(_order);
      });
    }, onError: (a) {
      print(a);
      // ignore: deprecated_member_use
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        // ignore: deprecated_member_use
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  updateData(id, status) {
    if(status=='Delivered') {
      FirebaseFirestore.instance.collection('orderDetails').doc(id).update({'driverStatus': status,'status':'Completed'}).catchError((e) {
        print(e);
        Fluttertoast.showToast(
          msg: 'Order is  completed successfully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
        );
        Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
      });
    } else{
      FirebaseFirestore.instance.collection('orderDetails').doc(id).update({'driverStatus': status}).catchError((e) {
        print(e);
      });

    }
  }

  sendOTP(orderId,mobile,action) async {

    repository.sendOtpStatus(mobile, orderId).then((value) {
      if(value) {
        if(action ==1) {
          String delivered = 'Delivered';
          Navigator.of(context).pushNamed(
              '/Otp', arguments: orderId);
        }
        else {
          Fluttertoast.showToast(
            msg: 'OTP Resend Successfully',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
          );
        }
      }
      else {
        Fluttertoast.showToast(
          msg: 'Something Went Wrong',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
        );
      }
    });

  }


  statusUpdate(status, orderId,otp) async {


    repository.status(status, orderId, otp).then((value) {

      if(value) {
        updateData(orderId, status);
        
        Navigator.of(context).pushNamed('/OrderHistory');

        Fluttertoast.showToast(
          msg: 'Order is  ' + status + ' successfully',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
        );
      }
      else {
        Fluttertoast.showToast(
          msg: 'Failed',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
        );
      }



      return value;
    });

  }

  Future<void> refreshOrders() async {
    orders.clear();

  }
}
