import 'package:flutter/material.dart';
import 'package:shalom_fba/model/Profile.dart';
class PlayerCard extends StatefulWidget {
  final Profile profile;
  PlayerCard(this.profile);

  @override
  _PlayerCardState createState() => _PlayerCardState(this.profile);
}

class _PlayerCardState extends State<PlayerCard> {

  final Profile _profile;
  _PlayerCardState(this._profile);

  @override
  Widget build(BuildContext context) {
    print('Profile inside card : ${_profile.firstName}');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.white,
      elevation: 10,
      child: ListTile(
        onTap: (){
          Navigator.of((context)).pushNamed('/dashboard',arguments: {
            'profile': _profile
          });
        },
        leading: CircleAvatar(
          radius: 25.0,
          backgroundImage: NetworkImage(_profile.photoUrl),
        ),
        title: Text('${_profile.firstName} ${_profile.lastName}'),
        subtitle: Text('${_profile.positionOfPlay}'),
      ),
    );
  }
}

