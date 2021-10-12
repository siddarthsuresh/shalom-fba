import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shalom_fba/model/Profile.dart';
import 'package:shalom_fba/screens/build_profile.dart';
import 'package:shalom_fba/screens/home/settings_form.dart';
import 'package:shalom_fba/screens/loading.dart';
import 'package:shalom_fba/service/authentication_service.dart';
import 'package:shalom_fba/service/database_service.dart';

class DashboardPage extends StatefulWidget {
  final Function admin;
  DashboardPage({this.admin});
  @override
  _DashboardPageState createState() => _DashboardPageState(admin);
}


class _DashboardPageState extends State<DashboardPage> {
  Function _admin;
  _DashboardPageState(this._admin);
  Map data = {};
  final _databaseService = DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);
  final _authenticationService = AuthenticationService(FirebaseAuth.instance);
  Profile profile = new Profile();
  List<File> _images = [];
  File _image; // Used only if you need a single picture


  Future getImage(bool gallery, String uid) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }
    if (pickedFile != null) {
      File image = File(pickedFile.path);
      profile.image = image ?? "";
      String url = await _databaseService.saveImages(image, uid);
      _databaseService.updateProfileImage(url, uid);
    }
    setState(()  {
      if (pickedFile != null) {
        // _images.add(File(pickedFile.path));
        _image = File(pickedFile.path); // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    void _showSettingsPanel(){
      showModalBottomSheet(context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: SettingsForm(profile: profile,),
            );
          });
    }
    return StreamBuilder<DocumentSnapshot>(
      stream: _databaseService.getProfileDetails(),
      builder: (context, snapshot) {
        if (snapshot.hasData || data != null){
          if (data != null){
            profile = data.isNotEmpty ? data['profile'] : Profile.fromMap(snapshot.data, FirebaseAuth.instance.currentUser.uid);
          }
          else {
            profile = Profile.fromMap(snapshot.data, FirebaseAuth.instance.currentUser.uid);
          }
          print(profile.dateOfBirth);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black87,
            title: Text('Profile'),
            actions: <Widget>[
             profile.isAdmin.toLowerCase() == "true" ? IconButton(
                  icon:Icon(Icons.list_alt_outlined) ,
                  onPressed: _admin,
                color: Colors.white,
              ) : IconButton(
               icon:Icon(Icons.refresh) ,
               onPressed: (){},
               color: Colors.white,
             ),
              IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    _authenticationService.signOut();
                    Navigator.of(context).popAndPushNamed('/wrapper');
                  })
            ],
          ),
          body: SingleChildScrollView(
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 0,
                borderOnForeground: true,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/cover_background_light_grey.jpg'),
                        alignment: Alignment.topCenter,
                    fit: BoxFit.fitWidth),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0, left: 10.0),
                        child: Container(
                          height: 130,
                          width: 130,
                          child: Stack(
                            children:[ CircleAvatar(
                              radius: 65.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                              ),
                              backgroundImage: _image !=null ? AssetImage(_image.path) :
                             NetworkImage  (profile.downloadURL),
                            ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[600],
                                  radius: 20.0,
                                  child: IconButton(
                                    icon: Icon(Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 22,),
                                    onPressed: (){
                                      getImage(true, profile.uid);
                                    },
                                  ),
                                ),
                              ),
                         ] ),
                        ),
                      ),
                      // ]),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                             '${profile.firstName} ${profile.lastName}',
                              style: TextStyle(
                                  fontSize: 25.0,
                                  fontFamily: 'Montserrat-Bold',
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          IconButton(icon: Icon(Icons.edit), onPressed: (){
                            _showSettingsPanel();
                          })
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 2.0,
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            DetailsCard(title: 'Category',
                            subtitle:  (int.parse(profile.age) <= 10 ? 'Under 10' : int.parse(profile.age) <= 16 ? 'Under 16' :
                            int.parse(profile.age) <= 21 ? 'Under 21' : 'Seniors') ,imageSrc: 'assets/images/team_card.png',
                                height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width).detailsCard(),
                            SizedBox(
                              width: 5.0,
                            ),
                            DetailsCard(title: 'Position',subtitle: '${profile.positionOfPlay} | ${profile.foot} Foot',imageSrc:  'assets/images/player_image_card.png',
                                height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width).detailsCard(),
                            SizedBox(
                              width: 5.0,
                            ),
                            DetailsCard(title: 'Physique',subtitle: '${profile.height} cms | ${profile.weight} kgs',imageSrc: 'assets/images/man_physique.png',
                                height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width).detailsCard(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        );
        }
        else{
          return Loading();
        }
      }
    );
  }
}

class DetailsCard{
  final String title;
  final String subtitle;
  final String imageSrc;
  final double width;
  final double height;

  DetailsCard({this.title, this.subtitle, this.imageSrc, this.width, this.height});

  Widget detailsCard(){
    return Card(
      borderOnForeground: true,
      clipBehavior: Clip.antiAlias,
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
              image:
              AssetImage(imageSrc),
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
                padding: const EdgeInsets.only(
                    left: 7.0, top: 2.0),
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.start,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 22.0,
                            fontFamily:
                            'Montserrat-SemiBold',
                            fontWeight: FontWeight.normal)),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(subtitle,
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 17.0,
                            fontFamily:
                            'Montserrat-SemiBold',
                            fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
