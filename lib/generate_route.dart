import 'package:flutter/material.dart';
import 'package:villageboard/src/views/auth/signin_view.dart';
import 'package:villageboard/src/views/auth/signup_view.dart';
import 'package:villageboard/src/views/main/detail_view.dart';
import 'package:villageboard/src/views/main/main_view.dart';
import 'package:villageboard/src/views/main/write_view.dart';
import 'package:villageboard/src/views/splash_view.dart';

class GenerateRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/Splash':
        return MaterialPageRoute(builder: (_) => SplashView());

      // Auth
      case '/SignIn':
        return MaterialPageRoute(builder: (_) => SignInView());
      case '/SignUp':
        return MaterialPageRoute(builder: (_) => SignUpView());

      // Main
      case '/Main':
        return MaterialPageRoute(builder: (_) => MainView());
      case '/Detail':
        return MaterialPageRoute(builder: (_) => DetailView(articleData: args));
      case '/Write':
        return MaterialPageRoute(builder: (_) => WriteView());

      default:
        return MaterialPageRoute(builder: (_) => Scaffold(body: SafeArea(child: Text('Route Error'),),));
    }
  }
}