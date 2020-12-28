
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:villageboard/src/helpers/app_config.dart' as ex;

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  color: ex.Colors().randomColor(),
                  child: Text('${this.widget}',
                    style: TextStyle(fontSize: 28.0),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: FutureBuilder(
                  future: _initialization,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      print("### Error: ${snapshot.error?.toString()}");
                      showNextPage(context, hasError: true);
                    } else {
                      if (snapshot.connectionState == ConnectionState.done) {
                        showNextPage(context);
                      }
                    }
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: Scaffold(
                        body: SafeArea(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  void showNextPage(BuildContext context, {bool hasError = false}) {
    Future.delayed(Duration(milliseconds: 1000)).then((value) {
      try {
        if (hasError == true || FirebaseAuth.instance.currentUser == null) {
          Navigator.of(context).pushNamedAndRemoveUntil('/SignIn', (route) => false);
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil('/Main', (route) => false);
        }
      } catch (e) {
        print('Error: $e');
      }
    });
  }

}
