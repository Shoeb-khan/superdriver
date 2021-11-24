import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:products_deliveryboy/src/controllers/order_controller.dart';

class OtpVerification extends StatefulWidget {
  OtpVerification({Key key,this.orderId}) : super(key: key);
  String orderId;
  dynamic mobile;

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends StateMVC<OtpVerification> {

  OrderController _con;
  String otp;

  _OtpVerificationState() : super(OrderController()) {
    _con = controller;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        /**  leading: _con.currentMarket?.latitude == null
            ? new IconButton(
            icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
            onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
            )
            : IconButton(
            icon: new Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
            onPressed: () => Navigator.of(context).pushNamed('/Pages', arguments: 2),
            ), */
        title: Text(
          'Verification ',
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image(image: AssetImage('assets/img/splashscreen2.png'),
            //   height:MediaQuery.of(context).size.width/2,width:MediaQuery.of(context).size.width/2,
            //   fit: BoxFit.fill,
            // ),
            Text('Verify Your OTP',
                style: Theme.of(context).textTheme.headline6),
            SizedBox(
              height: 20,
            ),
            Image(image: AssetImage('assets/img/splashscreen2.png'),
              height:MediaQuery.of(context).size.width/2,width:MediaQuery.of(context).size.width/2,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Please Enter the OTP sent on Customer Registered Number',
                style: TextStyle(),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            OtpTextField(
              obscureText: true,
              numberOfFields: 6,
              borderColor: Color(0xFF512DA8),
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {
                setState(() {
                  otp =verificationCode;
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Container(

              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                      onPressed: () {
                        _con.statusUpdate('Delivered', widget.orderId, otp);
                      },
                      height: 40,
                      child: Text('Submit',
                          style: Theme.of(context).textTheme.bodyText1.merge(
                              TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600))),
                      color: Theme.of(context).accentColor,
                      shape: StadiumBorder()),

                  SizedBox(width: 20,),
                  FlatButton(
                      onPressed: () {
                        _con.sendOTP(widget.orderId, widget.mobile, 2);

                      },
                      height: 40,
                      child: Text('Resend',
                          style: Theme.of(context).textTheme.bodyText1.merge(
                              TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600))),
                      color: Theme.of(context).accentColor,
                      shape: StadiumBorder()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
