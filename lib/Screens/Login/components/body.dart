import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterser/Screens/Login/components/background.dart';
import 'package:flutterser/Screens/Signup/signup_screen.dart';
import 'package:flutterser/components/already_have_an_account_acheck.dart';
import 'package:flutterser/components/rounded_button.dart';
import 'package:flutterser/components/rounded_input_field.dart';
import 'package:flutterser/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../task.dart';
class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  FirebaseAuth _firebaseAuth;
  String email, password;

  RoundedInputField _roundedInputField;
  RoundedPasswordField _roundedPasswordField;
  bool newuser;
  SharedPreferences logindata;

  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    print(newuser);

    }




  @override
  void initState() {
    // TODO: implement initState


    super.initState();
    check_if_already_login();


  }


  Future<FirebaseUser> login() async {
    AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password);

    FirebaseUser user = result.user;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => task()),
    );

  }








  Future<FirebaseUser> registuser() async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: email, password: password)
        .then((result) {
      print(result.user.email);
    });
  }


void send(String a,String b){
    print(a);
    print(b);
}

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Giriş",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: " Email",
              onChanged: (value) =>email=value,


            ),
            RoundedPasswordField(
              onChanged: (value)=>password=value,
            ),
            RoundedButton(


              text: "Giriş",
              press: () {
         //registuser();
                logindata.setString('username', password);


                login();

              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {



                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}