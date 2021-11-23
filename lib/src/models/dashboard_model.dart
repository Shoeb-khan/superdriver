class DashboardModel{

  int todayOrders = 0;
  int totalOrders = 0;
  int thisMonthOrders = 0;
  double todayEarn = 0;
  double thisMonthEarn = 0;
  double lastSDays = 0;
  double totalEarn = 0;
  double cashInHand = 0;








  // used for indicate if client logged in or not
  bool auth;

//  String role;

  DashboardModel();

  DashboardModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      todayOrders = jsonMap['todayOrders'] != null ? jsonMap['todayOrders'] : 0;
      thisMonthOrders = jsonMap['thisMonthOrders'] != null ? jsonMap['thisMonthOrders'] : 0;
      totalOrders = jsonMap['totalOrders'] != null ? jsonMap['totalOrders'] : 0;
      todayEarn = jsonMap['todayEarn'].toDouble() != null ? jsonMap['todayEarn'].toDouble() : 0;
      totalEarn = jsonMap['totalEarn'].toDouble()  != null ? jsonMap['totalEarn'].toDouble() : 0;
      thisMonthEarn = jsonMap['thisMonthEarn'].toDouble()  != null ? jsonMap['thisMonthEarn'].toDouble() : 0;
      lastSDays = jsonMap['lastSMonth'].toDouble()  != null ? jsonMap['lastSMonth'].toDouble() : 0;
      cashInHand = jsonMap['cashInHand'].toDouble()  != null ? jsonMap['cashInHand'].toDouble() : 0;

    } catch (e) {

      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["todayOrders"] = todayOrders;
    map["totalOrders"] =  totalOrders;
    map["thisMonthOrders"] = thisMonthOrders;

    map["todayEarn"] = todayEarn;
    map["totalEarn"] = totalEarn;
    map["cashInHand"] = cashInHand;







    return map;
  }



}