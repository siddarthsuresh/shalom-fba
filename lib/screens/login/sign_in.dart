import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shalom_fba/Animation/faded_animation.dart';
import 'package:shalom_fba/service/authentication_service.dart';

import '../loading.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthenticationService _authService =
      AuthenticationService(FirebaseAuth.instance);
  final _formKey = GlobalKey<FormState>();
  String error = '';
  String email = '';
  String password = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
            child: Container(
              color: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/logo_background.jpg'),
                        fit: BoxFit.fill
                  )),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 200.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(90.0)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            padding:
                                EdgeInsets.only(top: 35.0, left: 15.0, right: 20.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20.0,
                                ),
                                Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Montserrat-SemiBold',
                                      fontSize: 40.0,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  height: 50.0,
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      FadeAnimation(
                                          1.8,
                                          100,
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 20.0,
                                                      offset: Offset(0, 10))
                                                ]),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(
                                                              color: Colors
                                                                  .grey[100]))),
                                                  child: TextFormField(
                                                    validator: (value) => value
                                                                .isEmpty ||
                                                            !value.contains('@') ||
                                                            !value.contains('.')
                                                        ? 'Enter a valid email'
                                                        : null,
                                                    decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        labelText: "Email",
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.grey[400]),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black))),
                                                    onChanged: (val) {
                                                      setState(() {
                                                        email = val;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: TextFormField(
                                                      validator: (value) => value
                                                                  .length <
                                                              6
                                                          ? 'Minimum password length is 6'
                                                          : null,
                                                      obscureText: true,
                                                      decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          labelText: "Password",
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  Colors.grey[400]),
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .black))),
                                                      onChanged: (val) {
                                                        setState(() {
                                                          password = val;
                                                        });
                                                      }),
                                                )
                                              ],
                                            ),
                                          )),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        alignment: Alignment(1.0, 0.0),
                                        padding:
                                            EdgeInsets.only(top: 15.0, left: 20.0),
                                        child: InkWell(
                                          child: Text(
                                            'Forgot Password',
                                            style: TextStyle(
                                                color: Colors.grey[500],
                                                fontWeight: FontWeight.normal,
                                                fontFamily: 'Montserrat-SemiBold',
                                                decoration:
                                                    TextDecoration.underline),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40.0,
                                      ),
                                      ButtonTheme(
                                        minWidth: double.infinity,
                                        height: 40.0,
                                        child: RaisedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState.validate()) {
                                              setState(() {
                                                loading = true;
                                              });
                                              dynamic result = await _authService
                                                  .signInWithEmail(email, password);
                                              if (result == null) {
                                                setState(() {
                                                  error =
                                                      'Could not sign in with those credentials';
                                                  loading = false;
                                                });
                                              }
                                            }
                                          },
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: 'Montserrat-Bold'),
                                          ),
                                          color: Colors.black,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft: Radius.circular(10),
                                                  bottomRight: Radius.circular(10)),
                                              side:
                                                  BorderSide(color: Colors.black)),
                                        ),
                                      ),
                                      // Uncomment to enable new register from user
                                      /*SizedBox(
                                height: 5.0,
                              ),
                              ButtonTheme(
                                minWidth: double.infinity,
                                height: 40.0,
                                buttonColor: Colors.transparent,
                                child: RaisedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.email),
                                  label: Text(
                                    'Login with e-mail',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat-Bold'),
                                  ),
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.black)),
                                  elevation: 0.0,
                                  highlightElevation: 0.0,
                                ),
                              ),
                    ],
                ),
                    ),
                ),
                SizedBox(
                    height: 15.0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                Text(
                    'New to Shalom FBA ?',
                    style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat-Bold'),
                ),
                SizedBox(
                    width: 5.0,
                ),
                InkWell(
                    onTap: () {
                              Navigator.of(context).pushNamed('/signUp');
                    },
                    child: Text(
                              'Register',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat-Thin',
                                  decoration: TextDecoration.underline),
                    ),
                ),
                    ],
                ),*/
                                      SizedBox(height: 12.0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            error,
                                            style: TextStyle(
                                                color: Colors.red, fontSize: 14.0),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]),
                ),
              ),
            ),
          ));
  }
}
