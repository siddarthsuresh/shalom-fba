import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shalom_fba/model/Profile.dart';
import 'package:shalom_fba/screens/category/PlayerCard.dart';
import 'package:shalom_fba/screens/loading.dart';
import 'package:shalom_fba/service/authentication_service.dart';
import 'package:shalom_fba/service/database_service.dart';

class PlayersList extends StatefulWidget {
  @override
  _PlayersListState createState() => _PlayersListState();
}

class _PlayersListState extends State<PlayersList> {
  bool attendance = false;
  TextEditingController controller = new TextEditingController();
  Map data = {};
  List<Profile> profilesList = [];
  List<Profile> selectedProfiles = [];
  bool _activeSearch = false;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute
        .of(context)
        .settings
        .arguments;
    int years = int.parse(data['category']);
    String title = '';
    if (years > 21) {
      title = 'Seniors';
    }
    else {
      title = 'Under $years';
    }
    final _databaseService =
    DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);
    final AuthenticationService _authService =
    AuthenticationService(FirebaseAuth.instance);
    return StreamBuilder<List<Profile>>(
        stream: _databaseService.getProfilesByCategory(years),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            profilesList = snapshot.data;
            return Scaffold(resizeToAvoidBottomPadding: false,
              appBar: _activeSearch ? AppBar(
                leading: Icon(Icons.search),
                backgroundColor: Colors.black87,
                title: TextField(
                  autofocus: true,
                  controller: controller,
                  onChanged: onSearchTextChanged,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0
                  ),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[500]
                      ),
                      focusedBorder:
                      UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .black))
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _activeSearch = false;
                        onSearchTextChanged('');
                      });
                    },
                  )
                ],
              ) : attendance ? AppBar(
                backgroundColor: Colors.black87,
                title: Text('Attendance'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => setState(() { attendance = false;
                    selectedProfiles.clear();
                    }),
                  ),
                ],
              ): AppBar(
                backgroundColor: Colors.black87,
                title: Text(title),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => setState(() => _activeSearch = true),
                  ),
                ],
              ),
              body: Column(
                children: [
                  SizedBox(height: 10.0,),
                  new Container(
                    child: new Expanded(
                      child: searchResult.isNotEmpty || controller.text.isNotEmpty
                          ?
                      new ListView.builder(
                          itemCount: searchResult.length,
                          itemBuilder: (context, i) {
                            return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: Colors.white,
                                  elevation: 5,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.of((context)).pushNamed(
                                          '/dashboard', arguments: {
                                        'profile': searchResult[i]
                                      });
                                    },
                                    leading: CircleAvatar(
                                      radius: 25.0,
                                      backgroundImage: NetworkImage(
                                          searchResult[i].photoUrl),
                                    ),
                                    title: Text('${searchResult[i]
                                        .firstName} ${searchResult[i]
                                        .lastName}'),
                                    subtitle: Text(
                                        '${searchResult[i].positionOfPlay}'),
                                  ),
                                )
                            );
                          }) :
                      ListView.builder(
                          itemCount: profilesList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.white,
                                elevation: 5,
                                child: ListTile(
                                  trailing: attendance ? selectedProfiles.any((profile) => profile.uid == profilesList[index].uid) ?
                                  Icon(Icons.check_circle_outline_rounded, color: Colors.black,)
                                      : Icon(Icons.add_circle_outline, color: Colors.black,) : null,
                                  onTap: () {
                                    if (attendance){
                                      if (selectedProfiles.any((profile) => profile.uid == profilesList[index].uid)){
                                        setState(() {
                                          selectedProfiles.removeWhere((profile) => profile.uid == profilesList[index].uid);
                                        });
                                      }
                                      else {
                                        setState(() {
                                          selectedProfiles.add(profilesList[index]);
                                        });
                                      }
                                    }
                                    else {
                                      Navigator.of((context)).pushNamed(
                                          '/dashboard', arguments: {
                                        'profile': profilesList[index]
                                      });
                                    }

                                  },
                                  leading: CircleAvatar(
                                    radius: 25.0,
                                    backgroundImage: NetworkImage(
                                        profilesList[index].photoUrl),
                                  ),
                                  title: Text('${profilesList[index]
                                      .firstName} ${profilesList[index]
                                      .lastName}'),
                                  subtitle: Text(
                                      '${profilesList[index].positionOfPlay}'),
                                ),
                              )
                            );
                          }
                      )
                    ),
                  ),
                ],
              ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                setState(() {
                  _databaseService.updateAttendance(selectedProfiles);
                  attendance = !attendance;
                  selectedProfiles.clear();
                });
              },
              child: attendance ? Icon(Icons.done_rounded,color: Colors.white,) : Icon(Icons.calendar_today,color: Colors.white,) ,
              backgroundColor: Colors.black,
            ),);
          } else {
            return Loading();
          }
        }
    );
  }

  onSearchTextChanged(String text) async {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {
        controller.text = '';
      });
      return;
    }

    profilesList.forEach((profile) {
      if (profile.firstName.toLowerCase().contains(text.trim().toLowerCase()) ||
          profile.lastName.toLowerCase().contains(text.trim().toLowerCase())) {
        searchResult.add(profile);
      }
    });
    setState(() {});
  }

  List<Profile> searchResult = [];

}

