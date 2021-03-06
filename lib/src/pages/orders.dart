import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:products_deliveryboy/src/repository/user_repository.dart';
import 'package:responsive_ui/responsive_ui.dart';
import '../../generated/l10n.dart';
import '../controllers/order_controller.dart';

class OrdersWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  OrdersWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  _OrdersWidgetState createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends StateMVC<OrdersWidget> {
  OrderController _con;

  _OrdersWidgetState() : super(OrderController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).order,
          style: Theme.of(context)
              .textTheme
              .headline6
              .merge(TextStyle(letterSpacing: 1.3)),
        ),
        /**    actions: <Widget>[
            new ShoppingCartButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
            ], */
      ),
      body: RefreshIndicator(
        onRefresh: _con.refreshOrders,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10),
          children: <Widget>[
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("orderDetails")
                    .where("driverId", isEqualTo: currentUser.value.id)
                    .where("status", isEqualTo: 'Shipped')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError || snapshot.data == null) {
                    return Container();
                  } else {
                    if (snapshot.data.docs.length == 0) {
                      return Center(
                        child: Text("No Data Found"),
                      );
                    }
                    else{
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot course = snapshot.data.docs[index];
                        return Theme(
                            data: theme,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/OrderDetails',arguments: "${course['orderId']}");
                              },
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.topLeft,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 10, left: 10, right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Theme.of(context)
                                                        .focusColor
                                                        .withOpacity(0.05),
                                                    offset: Offset(0, 5),
                                                    blurRadius: 1)
                                              ],
                                              /*border: Border.all(
                              width: 1,
                              color:Theme.of(context).dividerColor,
                          ),*/

                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [

                                                      Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  left: 15,
                                                                  right: 15,
                                                                  top: 20),
                                                              child: Text(
                                                                  '#${course['orderId']}',
                                                                  style: Theme.of(
                                                                      context)
                                                                      .textTheme
                                                                      .headline3),
                                                            ),
                                                            Container(
                                                              padding:
                                                              EdgeInsets
                                                                  .only(
                                                                left: 15,
                                                                right: 15,
                                                              ),
                                                              child: Text(
                                                                  '',
                                                                  style: Theme.of(
                                                                      context)
                                                                      .textTheme
                                                                      .caption
                                                                      .merge(TextStyle(
                                                                      color: Theme.of(context)
                                                                          .primaryColorDark,
                                                                      fontWeight:
                                                                      FontWeight.w600))),
                                                            ),
                                                          ]),
                                                      Container(
                                                          padding:
                                                          EdgeInsets.only(
                                                              left: 10,
                                                              right: 10,
                                                              top: 20),
                                                          child: Text(
                                                            course['status'],
                                                            style: Theme.of(
                                                                context)
                                                                .textTheme
                                                                .subtitle1
                                                                .merge(TextStyle(
                                                                color: Theme.of(
                                                                    context)
                                                                    .primaryColorDark)),
                                                          )),


                                                    ],
                                                  ),

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          padding:
                                                          EdgeInsets.only(
                                                              left: 10,
                                                              right: 10,
                                                              top: 20),
                                                          child: Text(
                                                            "PickUp Detials",
                                                            style: Theme.of(
                                                                context)
                                                                .textTheme
                                                                .subtitle1
                                                                .merge(TextStyle(
                                                                color: Colors.black)),
                                                          )),
                                                      Container(
                                                          padding:
                                                          EdgeInsets.only(
                                                              left: 10,
                                                              right: 10,
                                                              top: 20),
                                                          child: Text(
                                                            'Delivery Detials',
                                                            style: Theme.of(
                                                                context)
                                                                .textTheme
                                                                .subtitle1
                                                                .merge(TextStyle(
                                                                color: Colors.black)),
                                                          )),
                                                    ],
                                                  ),

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                  EdgeInsets.only(
                                                                      left: 15,
                                                                      right: 15,
                                                                      top: 20),
                                                                  child:
                                                                  CachedNetworkImage(
                                                                    imageUrl:
                                                                    "${GlobalConfiguration().getString('base_upload')}uploads/vendor_image/vendor_${course['shopId']}.png",
                                                                    imageBuilder: (context, imageProvider) => Container(
                                                                      height: MediaQuery.of(context).size.width*0.12,
                                                                      width: MediaQuery.of(context).size.width*0.12,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                                                        image: DecorationImage(
                                                                          image: imageProvider,
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    placeholder: (context,
                                                                        url) =>
                                                                        CircularProgressIndicator(),
                                                                    errorWidget: (context,
                                                                        url, error) =>
                                                                        Icon(Icons.error),
                                                                    height: 70,
                                                                    width: 70,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Container(
                                                                      padding: EdgeInsets.only(
                                                                          left: 15,
                                                                          bottom: 10,
                                                                          right: 15,
                                                                          top: 20),
                                                                      child: Column(children: [
                                                                        Container(
                                                                            child: Text(
                                                                              course['shopName'],
                                                                              style:
                                                                              Theme.of(context)
                                                                                  .textTheme
                                                                                  .headline3,
                                                                            )),
                                                                        Container(
                                                                            child: Text(
                                                                              '',
                                                                              style: Theme.of(
                                                                                  context)
                                                                                  .textTheme
                                                                                  .bodyText1
                                                                                  .merge(TextStyle(
                                                                                  fontFamily:
                                                                                  'ProductSans-Thin')),
                                                                            ))
                                                                      ])),
                                                                ),


                                                                // Column(
                                                                //     crossAxisAlignment:
                                                                //     CrossAxisAlignment
                                                                //         .end,
                                                                //     children: [
                                                                //       Container(
                                                                //         padding: EdgeInsets
                                                                //             .only(
                                                                //             left: 15,
                                                                //             right: 15,
                                                                //             top: 20),
                                                                //         child: Text(
                                                                //             '#${course['orderId']}',
                                                                //             style: Theme.of(
                                                                //                 context)
                                                                //                 .textTheme
                                                                //                 .headline3),
                                                                //       ),
                                                                //       Container(
                                                                //         padding:
                                                                //         EdgeInsets
                                                                //             .only(
                                                                //           left: 15,
                                                                //           right: 15,
                                                                //         ),
                                                                //         child: Text(
                                                                //             '',
                                                                //             style: Theme.of(
                                                                //                 context)
                                                                //                 .textTheme
                                                                //                 .caption
                                                                //                 .merge(TextStyle(
                                                                //                 color: Theme.of(context)
                                                                //                     .primaryColorDark,
                                                                //                 fontWeight:
                                                                //                 FontWeight.w600))),
                                                                //       ),
                                                                //     ]),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                              children: [

                                                                Expanded(
                                                                  child: Container(
                                                                      padding: EdgeInsets.only(
                                                                          left: 15,
                                                                          bottom: 10,
                                                                          right: 15,
                                                                          top: 20),
                                                                      child: Column(children: [
                                                                        Container(
                                                                            child: Text(
                                                                              course['userName'],
                                                                              style:
                                                                              Theme.of(context)
                                                                                  .textTheme
                                                                                  .headline3,
                                                                            )),
                                                                        Container(
                                                                            child: Text(
                                                                              '',
                                                                              style: Theme.of(
                                                                                  context)
                                                                                  .textTheme
                                                                                  .bodyText1
                                                                                  .merge(TextStyle(
                                                                                  fontFamily:
                                                                                  'ProductSans-Thin')),
                                                                            ))
                                                                      ])),
                                                                ),
                                                                Container(
                                                                  padding:
                                                                  EdgeInsets.only(
                                                                      left: 15,
                                                                      right: 15,
                                                                      top: 20),
                                                                  child:
                                                                  CachedNetworkImage(
                                                                    imageUrl:
                                                                    "${GlobalConfiguration().getString('base_upload')}uploads/vendor_image/vendor_${course['userId']}.png",
                                                                    imageBuilder: (context, imageProvider) => Container(
                                                                      height: MediaQuery.of(context).size.width*0.12,
                                                                      width: MediaQuery.of(context).size.width*0.12,
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.all(Radius.circular(50)),
                                                                        image: DecorationImage(
                                                                          image: imageProvider,
                                                                          fit: BoxFit.cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    placeholder: (context,
                                                                        url) =>
                                                                        CircularProgressIndicator(),
                                                                    errorWidget: (context,
                                                                        url, error) =>
                                                                        Icon(Icons.error),
                                                                    height: 70,
                                                                    width: 70,
                                                                  ),
                                                                ),


                                                                // Column(
                                                                //     crossAxisAlignment:
                                                                //     CrossAxisAlignment
                                                                //         .end,
                                                                //     children: [
                                                                //       Container(
                                                                //         padding: EdgeInsets
                                                                //             .only(
                                                                //             left: 15,
                                                                //             right: 15,
                                                                //             top: 20),
                                                                //         child: Text(
                                                                //             '#${course['orderId']}',
                                                                //             style: Theme.of(
                                                                //                 context)
                                                                //                 .textTheme
                                                                //                 .headline3),
                                                                //       ),
                                                                //       Container(
                                                                //         padding:
                                                                //         EdgeInsets
                                                                //             .only(
                                                                //           left: 15,
                                                                //           right: 15,
                                                                //         ),
                                                                //         child: Text(
                                                                //             '',
                                                                //             style: Theme.of(
                                                                //                 context)
                                                                //                 .textTheme
                                                                //                 .caption
                                                                //                 .merge(TextStyle(
                                                                //                 color: Theme.of(context)
                                                                //                     .primaryColorDark,
                                                                //                 fontWeight:
                                                                //                 FontWeight.w600))),
                                                                //       ),
                                                                //     ]),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 15,
                                                        bottom: 10,
                                                        right: 15,
                                                        top: 10),
                                                    child: Wrap(children: [
                                                      Div(
                                                          colS: 12,
                                                          colM: 12,
                                                          colL: 12,
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .disabledColor,
                                                                    border: Border.all(
                                                                        width:
                                                                            3,
                                                                        color: Colors
                                                                            .white54),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.3),
                                                                        spreadRadius:
                                                                            2,
                                                                        blurRadius:
                                                                            10,
                                                                        offset: Offset(
                                                                            0,
                                                                            3), // changes position of shadow
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Icon(
                                                                      Icons
                                                                          .circle,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .disabledColor
                                                                          .withOpacity(
                                                                              0.1),
                                                                      size: 15),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        DottedLine(
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  lineLength: double
                                                                      .infinity,
                                                                  lineThickness:
                                                                      1.0,
                                                                  dashLength:
                                                                      4.0,
                                                                  dashColor:
                                                                      Colors
                                                                          .grey,
                                                                  dashRadius:
                                                                      0.0,
                                                                  dashGapLength:
                                                                      4.0,
                                                                  dashGapColor:
                                                                      Colors
                                                                          .transparent,
                                                                  dashGapRadius:
                                                                      0.0,
                                                                )),
                                                                Container(
                                                                  child: Icon(
                                                                      Icons
                                                                          .delivery_dining,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .disabledColor,
                                                                      size: 29),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        DottedLine(
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  lineLength: double
                                                                      .infinity,
                                                                  lineThickness:
                                                                      1.0,
                                                                  dashLength:
                                                                      4.0,
                                                                  dashColor:
                                                                      Colors
                                                                          .grey,
                                                                  dashRadius:
                                                                      0.0,
                                                                  dashGapLength:
                                                                      4.0,
                                                                  dashGapColor:
                                                                      Colors
                                                                          .transparent,
                                                                  dashGapRadius:
                                                                      0.0,
                                                                )),
                                                                Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .disabledColor,
                                                                    border: Border.all(
                                                                        width:
                                                                            3,
                                                                        color: Colors
                                                                            .white54),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(0.3),
                                                                        spreadRadius:
                                                                            2,
                                                                        blurRadius:
                                                                            10,
                                                                        offset: Offset(
                                                                            0,
                                                                            3), // changes position of shadow
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  child: Icon(
                                                                      Icons
                                                                          .circle,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 15),
                                                                ),
                                                              ])),
                                                    ]),
                                                  ),
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: Wrap(children: [
                                                        Div(
                                                          colS: 6,
                                                          colM: 6,
                                                          colL: 6,
                                                          child: Container(
                                                              width: double
                                                                  .infinity,
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 15,
                                                                      bottom:
                                                                          20,
                                                                      right:
                                                                          10),
                                                              child: Wrap(
                                                                  children: [
                                                                    RichText(
                                                                      text: new TextSpan(
                                                                          text:
                                                                              '',
                                                                          style: Theme.of(context).textTheme.headline5.merge(TextStyle(color: Colors.orange)),
                                                                          children: [
                                                                            new TextSpan(
                                                                                text: '',
                                                                                style: Theme.of(context).textTheme.caption)
                                                                          ]),
                                                                    )
                                                                  ])),
                                                        ),
                                                        Div(
                                                          colS: 6,
                                                          colM: 6,
                                                          colL: 6,
                                                          child: InkWell(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                      '/OrderDetails',arguments: "${course['orderId']}");
                                                            },
                                                            child: Container(
                                                                width: double
                                                                    .infinity,
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        bottom:
                                                                            20,
                                                                        right:
                                                                            15),
                                                                child: Text(
                                                                  'View Details',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .subtitle1
                                                                      .merge(TextStyle(
                                                                          color:
                                                                              Colors.orange)),
                                                                )),
                                                          ),
                                                        )
                                                      ])),
                                                ]),
                                          ),
                                        ),

                                        /* Positioned.fill(
                              left: -10,
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      margin: EdgeInsets.only(top: 30, left: 1),
                                      child: Image(image: AssetImage('assets/img/waiting.png'), fit: BoxFit.fitWidth, width: 110, height: 40))),
                            ),*/
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },
                    );}
                  }
                }),
          ],
        ),
      ),
    );
  }
}
