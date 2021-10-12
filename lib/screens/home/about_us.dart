
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shalom_fba/service/authentication_service.dart';
import 'package:shalom_fba/service/database_service.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final _databaseService =
  DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);
  final AuthenticationService _authService =
  AuthenticationService(FirebaseAuth.instance);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Card(
                  clipBehavior: Clip.antiAlias,
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 2,
                  child: Image(image: AssetImage('assets/images/coverphoto.jpg'),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.topCenter,),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40.0,
                        child:  Image(image: AssetImage('assets/images/shalomlogofinal.png'),
                          height:60.0,),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text('Shalom Football Academy', style:
                        TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Montserrat-Bold',
                            fontWeight: FontWeight.w500),),
                      ),
                    ],
                  )
                ),
            Card(
              clipBehavior: Clip.antiAlias,
              borderOnForeground: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overview : ',
                      style: TextStyle(
                          fontSize: 19.0,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text(
                      'Shalom Football Academy(SFA) was established in the year 2006 with a vision'
                          ' to develop quality football players along with good character.',
                    style: TextStyle(
                        fontSize: 17.0,
                        fontFamily: 'Montserrat-Bold',
                        fontWeight: FontWeight.normal),),
                    SizedBox(height: 15,),
                    Text(
                      'Core Values of SFA : ',
                      style: TextStyle(
                          fontSize: 19.0,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text(
                    'We make every effort to ensure that are players are highly competent.\n'
                        '\nWe nurture good life values in the young minds that will make them excel'
                        ' in their personal life and benefit the society.',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.normal),),
                  ],
                ),
              ),),
                Card(
                  clipBehavior: Clip.antiAlias,
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 2,
                  child:
                    ListTile(
                      onTap: _launchFbPage,
                      leading: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image(
                          image: AssetImage('assets/images/facebook240.png'),
                        ),
                      ),
                      title: Text('Like us on Facebook', style:
                      TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Montserrat-Bold',
                          fontWeight: FontWeight.w500),),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  _launchFbPage() async {
    String fbProtocolUrl;
    if (Platform.isIOS) {
      fbProtocolUrl = 'fb://profile/156179991135840';
    } else {
      fbProtocolUrl = 'fb://page/156179991135840';
    }

    String fallbackUrl = 'https://www.facebook.com/SFAshalomfootballacademy';

    try {
      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);

      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false);
    }
  }
}
