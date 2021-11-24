import 'package:flutter/material.dart';
import 'package:products_deliveryboy/src/pages/loginPage.dart';
import 'package:products_deliveryboy/src/pages/map.dart';
import 'package:products_deliveryboy/src/pages/orders_history.dart';
import 'package:products_deliveryboy/src/pages/otp_verification.dart';
import 'package:products_deliveryboy/src/pages/register.dart';
import 'package:products_deliveryboy/src/pages/topup.dart';
import 'package:products_deliveryboy/src/pages/wallet.dart';
import 'src/pages/languages.dart';
import 'src/pages/notifications.dart';
import 'src/pages/order.dart';
import 'src/pages/pages.dart';
import 'src/pages/settings.dart';
import 'src/pages/splash_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    // final List<dynamic> args1 = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/wallet':
        return MaterialPageRoute(builder: (_) => WalletPage());
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => Register());
      case '/Pages':
        return MaterialPageRoute(builder: (_) => PagesTestWidget(currentTab: args));
      case '/OrderDetails':
        return MaterialPageRoute(builder: (_) => OrderWidget(orderId: args));
      case '/Notifications':
        return MaterialPageRoute(builder: (_) => NotificationsWidget());
      case '/Languages':
        return MaterialPageRoute(builder: (_) => LanguagesWidget());
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      case '/withdraw':
        return MaterialPageRoute(builder: (_) => TopUpPage());
      case '/Settings':
        return MaterialPageRoute(builder: (_) => SettingsWidget());
      case '/Map':
        return MaterialPageRoute(builder: (_) => MapWidget(orderDetails: args,));
      case '/Otp':
        return MaterialPageRoute(builder: (_) => OtpVerification(orderId: args));
      case '/OrderHistory':
        return MaterialPageRoute(builder: (_) => OrdersHistoryWidget());
      default:
        // If there is no such named route in the switch statement, e.g. /thi
        return MaterialPageRoute(builder: (_) => Scaffold(body: SizedBox(height: 0)));
    }
  }
}
