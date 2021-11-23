import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:products_deliveryboy/src/helpers/helper.dart';
import 'package:products_deliveryboy/src/models/register.dart';
import 'package:products_deliveryboy/src/repository/user_repository.dart';

import '../../generated/l10n.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;

class UserController extends ControllerMVC {
  User user = new User();
  bool hidePassword = true;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;
  Registermodel registerData = new Registermodel();
  OverlayEntry loader;
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),

  ];
  UserController() {
    loader = Helper.overlayLoader(context);
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {}).catchError((e) {
      print('Notification not configured');
    });
  }

  void login() async {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      repository.login(user).then((value) {
        if (value.apiToken != null) {
          currentUser.value.liveStatus = false;
          Fluttertoast.showToast(
            msg: "${S.of(context).login} ${S.of(context).successfully}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 5,
          );
          gettoken();
          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
        } else {
          // ignore: deprecated_member_use
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text('wrong_email_or_password'),
          ));
        }
      }).catchError((e) {
        loader.remove();
        // ignore: deprecated_member_use
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_account_is_not_exist),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  getLatLong() async {
    final query = "${registerData.address1},${registerData.address2},${registerData.city}, ${registerData.state},${registerData.zipcode}";
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print("${first.coordinates.latitude} : ${first.coordinates.longitude}");
    registerData.latitude = first.coordinates.latitude;
    registerData.longtitude = first.coordinates.longitude;
  }
  gettoken() {
    _firebaseMessaging.getToken().then((deviceid) {
      var table = 'driver' + currentUser.value.id;
      print(table);
      FirebaseFirestore.instance.collection('driverToken').doc(table).set({'Token': deviceid, 'Id': currentUser.value.id}).catchError((e) {
        print(e);
      });
    });
  }


  void register(File image) async {
    FocusScope.of(context).unfocus();
    Overlay.of(context).insert(loader);

    final uri = Uri.parse("${GlobalConfiguration().getString('api_base_url')}Api_delivery/register/");
    var request = http.MultipartRequest('POST', uri);
    Uint8List data = await image.readAsBytes();
    List<int> list = data.cast();
    request.fields['name'] = json.encode(registerData.toMap());
    var pic = await http.MultipartFile.fromBytes('image', list,filename: 'myFile.png');
    request.files.add(pic);
    print(registerData.toMap());
    var response = await request.send();
    print(uri);
    if (response.statusCode == 200) {
      response.stream.bytesToString().asStream().listen((event) {
        var parsedJson = json.decode(event);
        print(parsedJson);
        print(response.statusCode);
        //It's done...
      });
      Fluttertoast.showToast(
        msg: "${S.of(context).register} ${S.of(context).successfully}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
      );

      Navigator.of(context).pushReplacementNamed('/Login');

      Helper.hideLoader(loader);
    } else {
      Helper.hideLoader(loader);
    }
  }
  void resetPassword() {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      repository.resetPassword(user).then((value) {
        if (value != null && value == true) {
          // ignore: deprecated_member_use
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text('your_reset_link_has_been_sent_to_your_email'),
            action: SnackBarAction(
              label: S.current.login,
              onPressed: () {
                Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Login');
              },
            ),
            duration: Duration(seconds: 10),
          ));
        } else {
          // ignore: deprecated_member_use
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text('error_verify_email_settings'),
          ));
        }
      });
    }
  }
}
