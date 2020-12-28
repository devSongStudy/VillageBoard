
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:villageboard/src/helpers/app_config.dart' as ex;

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SignInButton(
                        Buttons.Google,
                        onPressed: () => signInGoogle()
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signInGoogle() async {
    try {
      SVProgressHUD.show();

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final GoogleAuthCredential googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =  await _auth.signInWithCredential(googleAuthCredential);
      User user = userCredential.user;
      if (user == null) {
        throw Exception("User is null");
      }

      SVProgressHUD.showSuccess(status: "Success");
      SVProgressHUD.dismiss(delay: Duration(milliseconds: 500), completion: () {
        showNextPage(context);
      });
    } on NoSuchMethodError catch (noSuchMethodError) {
      print("사용자 로그인 취소");
      SVProgressHUD.dismiss();

    } catch (error) {
      print("Error: $error");
      SVProgressHUD.showError(status: error.toString());
      SVProgressHUD.dismiss(delay: Duration(milliseconds: 2000));
    }

  }

  void showNextPage(BuildContext context) {
    try {
      Navigator.of(context).pushNamedAndRemoveUntil('/Main', (route) => false);
    } catch (e) {
      print('Error: $e');
    }
  }

}
