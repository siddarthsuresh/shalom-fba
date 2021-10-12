import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shalom_fba/model/Profile.dart';
import 'package:shalom_fba/screens/loading.dart';
import 'package:shalom_fba/service/authentication_service.dart';
import 'package:shalom_fba/service/database_service.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Profile profile = new Profile();

  @override
  Widget build(BuildContext context) {
    final _databaseService =
        DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);
    final AuthenticationService _authService =
        AuthenticationService(FirebaseAuth.instance);
    return StreamBuilder<Object>(
        stream: _databaseService.getProfileDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            profile = Profile.fromMap(
                snapshot.data, FirebaseAuth.instance.currentUser.uid);
            return Scaffold(
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
                backgroundColor: Colors.black87,
                title: Text('Shalom FBA'),
                // actions: <Widget>[
                //   IconButton(
                //       icon: Icon(Icons.logout),
                //       onPressed: () {
                //         _authService.signOut();
                //         Navigator.of(context).popAndPushNamed('/wrapper');
                //       })
                // ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                'Welcome ${profile.firstName},',
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontFamily: 'Montserrat-Bold',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: CircleAvatar(radius: 30.0,
                                backgroundImage: NetworkImage  (profile.downloadURL),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of((context)).pushNamed('/playersList',arguments: {
                              'category': '10'
                            });
                          },
                          child: DetailsCard(title: 'Under 10', subtitle: 'Player\'s List & Details', imageSrc: 'assets/images/under10.png' ,
                              width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height).detailsCard(),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of((context)).pushNamed('/playersList',arguments: {
                              'category': '16'
                            });
                          },
                          child: DetailsCard(title: 'Under 16', subtitle: 'Player\'s List & Details', imageSrc: 'assets/images/under16.png' ,
                              width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height).detailsCard(),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of((context)).pushNamed('/playersList',arguments: {
                              'category': '21'
                            });
                          },
                          child: DetailsCard(title: 'Under 21', subtitle: 'Player\'s List & Details', imageSrc: 'assets/images/under21.png' ,
                              width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height).detailsCard(),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of((context)).pushNamed('/playersList',arguments: {
                              'category': '70'
                            });
                          },
                          child: DetailsCard(title: 'Seniors', subtitle: 'Player\'s List & Details', imageSrc: 'assets/images/seniors.png' ,
                              width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height).detailsCard(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}

class DetailsCard {
  final String title;
  final String subtitle;
  final String imageSrc;
  final double width;
  final double height;

  DetailsCard(
      {this.title, this.subtitle, this.imageSrc, this.width, this.height});

  Widget detailsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        borderOnForeground: true, clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.white,
        elevation: 3,
        child: Container(
          height: 125,
          width: width,
          decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.grey[300],
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
              image: DecorationImage(
                image: AssetImage(imageSrc),
                alignment: Alignment.topRight,
              )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 7.0, top: 2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.0,
                              fontFamily: 'Montserrat-SemiBold',
                              fontWeight: FontWeight.normal)),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(subtitle,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 17.0,
                              fontFamily: 'Montserrat-SemiBold',
                              fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
