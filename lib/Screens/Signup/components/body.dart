import 'package:flutter/material.dart';
import 'package:flutterser/Screens/Login/login_screen.dart';
import 'package:flutterser/Screens/Login/task.dart';
import 'package:flutterser/Screens/Signup/components/background.dart';
import 'package:flutterser/Screens/Signup/components/or_divider.dart';
import 'package:flutterser/Screens/Signup/components/social_icon.dart';
import 'package:flutterser/components/already_have_an_account_acheck.dart';
import 'package:flutterser/components/rounded_button.dart';
import 'package:flutterser/components/rounded_input_field.dart';
import 'package:flutterser/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  FirebaseAuth _firebaseAuth;
  String email, password;
  bool newuser;
  SharedPreferences logindata;

  RoundedInputField _roundedInputField;
  RoundedPasswordField _roundedPasswordField;


  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    print(newuser);

  }






  Future<FirebaseUser> registuser(BuildContext context) async {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: email, password: password)
        .then((result) {
      print(result.user.email);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => task()),
      );


    }



    );

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check_if_already_login();
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
              "GİRİŞ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "Email",

              onChanged: (value) =>email=value,



            ),
            RoundedPasswordField(

              onChanged: (value)=>password=value,



            ),
            RoundedButton(
              text: "Kayıt ol",
              press: () {
                logindata.setString('username', password);

                registuser(context);

              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
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
