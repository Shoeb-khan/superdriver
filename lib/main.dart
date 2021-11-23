import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';

import 'generated/l10n.dart';
import 'route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/models/setting.dart';
import 'src/repository/settings_repository.dart' as settingRepo;
import 'src/repository/user_repository.dart' as userRepo;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GlobalConfiguration().loadFromAsset("configurations");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
//  /// Supply 'the Controller' for this application.
//  MyApp({Key key}) : super(con: Controller(), key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    settingRepo.initSettings();

    userRepo.getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: settingRepo.setting,
        builder: (context, Setting _setting, _) {
          print(_setting.toMap());
          return MaterialApp(
              navigatorKey: settingRepo.navigatorKey,
              title: _setting.appName,
              initialRoute: '/Splash',
              onGenerateRoute: RouteGenerator.generateRoute,
              debugShowCheckedModeBanner: false,
              locale: _setting.mobileLanguage.value,
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              theme:  Brightness.light == Brightness.light
                  ? ThemeData(
                      fontFamily: 'ProductSans',
                      primaryColor: Colors.white,
                      disabledColor: Colors.grey,
                      cardColor: Colors.lightBlue[50],
                      secondaryHeaderColor: Color(0xFF043832).withOpacity(1.0),
                      floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
                      brightness: Brightness.light,
                      hintColor: Color(0xFF919191),
                      primaryColorLight: Colors.white,
                      backgroundColor: Colors.black,
                      //accentColor: Color(0xFFFc8019),
                      accentColor:Colors.black,
                      dividerColor: Color(0xFF8c98a8).withOpacity(0.1),
                      focusColor: Color(0xFF2abd03).withOpacity(1.0),
                      primaryColorDark: Color(0xFF2abd03),
                      textTheme: TextTheme(
                        headline5: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: Colors.black, height: 1.3),
                        headline4: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.black, height: 1.3),
                        headline3: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: Colors.black, height: 1.3),
                        headline2: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600, color: Colors.black, height: 1.4),
                        headline1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black, height: 1.4),
                        subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: Colors.black, height: 1.3),
                        subtitle2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: Colors.black, height: 1.2),
                        headline6: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: Colors.black, height: 1.3),
                        bodyText2: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Colors.black, height: 1.2),
                        bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Colors.black, height: 1.3),
                        caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Color(0xFF8c98a8).withOpacity(1.0), height: 1.7),
                      ),
                    )
                  : ThemeData(
                      fontFamily: 'ProductSans',
                      primaryColor: Color(0xFF252525),
                      brightness: Brightness.dark,
                      scaffoldBackgroundColor: Color(0xFF2C2C2C),
                      primaryColorLight: Colors.white,
                      accentColor: Colors.black,
                      dividerColor: Color(0xFF9999aa).withOpacity(0.1),
                      hintColor: Color(0xFFaeaeae),
                      focusColor: Color(0xFF2abd03).withOpacity(1.0),
                      backgroundColor: Colors.white,
                      primaryColorDark: Color(0xFF2abd03).withOpacity(1.0),
                      textTheme: TextTheme(
                        headline5: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: Color(0xFF9999aa).withOpacity(1), height: 1.3),
                        headline4: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, color: Color(0xFF9999aa).withOpacity(1), height: 1.3),
                        headline3: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w700, color: Color(0xFF9999aa).withOpacity(1), height: 1.3),
                        headline2: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w600, color: Color(0xFF043832).withOpacity(1.0), height: 1.4),
                        headline1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Color(0xFF9999aa).withOpacity(1.0), height: 1.4),
                        subtitle1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500, color: Color(0xFF9999aa).withOpacity(1), height: 1.3),
                        subtitle2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: Color(0xFF9999aa).withOpacity(1), height: 1.2),
                        headline6: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: Color(0xFF043832).withOpacity(1.0), height: 1.3),
                        bodyText2: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500, color: Color(0xFF9999aa).withOpacity(1), height: 1.2),
                        bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Color(0xFF9999aa).withOpacity(1), height: 1.3),
                        caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: Color(0xFF9999aa).withOpacity(0.6), height: 1.7),
                      ),
                    ));
        });
  }
}
