import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shalom_fba/screens/build_profile.dart';
import 'package:shalom_fba/screens/home/dashboard.dart';
import 'package:shalom_fba/screens/home/home.dart';
import 'package:shalom_fba/screens/home/main_screen.dart';
import 'package:shalom_fba/screens/home/welcome.dart';
import 'package:shalom_fba/screens/loading.dart';
import 'package:shalom_fba/screens/login/sign_in.dart';
import 'package:shalom_fba/service/database_service.dart';

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null){
      return FutureBuilder<Widget>(
        future: checkIfDocExists(),
        builder: (context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data;
          }
          else {
            return Loading();
          }
        }
      );
    }
    else{
      return SignIn();
    }
  }

  Future<Widget> checkIfDocExists() async {
    final _databaseService =  DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);
    bool _userExist =
    await _databaseService
        .checkExist();
    if (_userExist){
      bool _isAdmin = await _databaseService.isAdmin();
      if (_isAdmin){
        return MainScreen("true");
      }
      else{
        return MainScreen("false");
      }
    }
    else {
      return Welcome();
    }
  }
}