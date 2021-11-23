import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:products_deliveryboy/src/helpers/custom_trace.dart';
import 'package:products_deliveryboy/src/models/order_list.dart';
import 'package:products_deliveryboy/src/repository/user_repository.dart';
import '../helpers/helper.dart';
import '../models/order_status.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as userRepo;

// ignore: missing_return
Future<Stream<OrderList>> getOrders() async {
  // for delivered status
  User _user = userRepo.currentUser.value;

  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}Api_delivery/${GlobalConfiguration().getString('api_base_url')}Api_delivery/order/list/${_user.id}?$_apiToken';
  print(url);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return OrderList.fromJSON(data);
    });
  } on Exception catch (error) {
    print(error);
  }
}

Future<bool> status(status, orderId, otp) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}Api_delivery/deliverStatus/update/$status/$orderId/$otp?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(''),
  );
  print(url);
  print(json.decode(response.body)['data']);
  return json.decode(response.body)['data'];
}

Future<bool> sendOtpStatus(mobile, orderId) async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}Api_delivery/sendOtp/$mobile/$orderId';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(''),
  );
  print(url);
  print(json.decode(response.body)['success']);
  return json.decode(response.body)['success'];
}


// ignore: missing_return
Future<Stream<OrderList>> getOrdersHistory() async {
  User _user = userRepo.currentUser.value;
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url = '${GlobalConfiguration().getString('api_base_url')}Api_delivery/order/orderhistory/${userRepo.currentUser.value.id}?$_apiToken';
  print(url);
  try {
    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return OrderList.fromJSON(data);
    });
  } on Exception catch (error) {
    print(error);
  }
}

Future<Stream<OrderStatus>> getOrderStatus() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Stream.value(new OrderStatus());
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url = '${GlobalConfiguration().getString('api_base_url')}order_statuses?$_apiToken';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return OrderStatus.fromJSON(data);
  });
}


Future<OrderList> getOrderDetails(id) async {

  Uri uri = Helper.getUri('Api_delivery/order/orderDetails/${currentUser.value.id}/$id');
  Map<String, dynamic> _queryParams = {};

  _queryParams['api_token'] = currentUser.value.apiToken;
  uri = uri.replace(queryParameters: _queryParams);
    print(uri);
  OrderList res;
  try {
    final response = await http.get(uri, headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    if (response.statusCode == 200 ) {

      print(response.body);
     res = OrderList.fromJSON(json.decode(response.body)['data']);

    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
    }
  } catch (e) {
    print(CustomTrace(StackTrace.current, message: e.toString()).toString());
    return OrderList.fromJSON({});
  }
  return res;
}