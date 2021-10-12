import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shalom_fba/Animation/faded_animation.dart';
import 'package:shalom_fba/model/Profile.dart';
import 'package:shalom_fba/screens/decoration/input_decoration.dart';
import 'package:shalom_fba/screens/loading.dart';
import 'package:shalom_fba/service/database_service.dart';

class SettingsForm extends StatefulWidget {
  final Profile profileDetails;
  SettingsForm({
    Profile profile
  }): this.profileDetails = profile;
    @override
  _SettingsFormState createState() => _SettingsFormState(profileDetails);
}

class _SettingsFormState extends State<SettingsForm> {
  bool loading = false;
  final DatabaseService _databaseService = new DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);
  final Profile profile;
  final _formKey = GlobalKey<FormState>();
  _SettingsFormState(this.profile);
  final List<String> education = ['School', 'College', 'Others'];
  final List<String> kitSize = [
    'X-Small',
    'Small',
    'Medium',
    'Large',
    'X-Large'
  ];
  final List<String> position = [
    'Goal Keeper',
    'Defender',
    'Midfielder',
    'Striker'
  ];
  final List<String> foot = [
    'Left',
    'Right',
  ];
  var _controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    void showInSnackBar(String value) {
      Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text(value)
      ));
    }
    return loading ? Loading() :
    Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: MediaQuery.of(context).size.height/2 - 100,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(children: [
                          FadeAnimation(
                            1.8,
                            100,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: InputTextFormDecoration()
                                  .containerBoxDecoration(),
                              child: Column(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 8.0, left: 8.0),
                                  decoration:
                                  InputTextFormDecoration()
                                      .formBoxDecoration(),
                                  child: TextFormField(
                                    initialValue: profile.firstName ?? '',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 20),
                                    validator: (value) =>
                                    value.isEmpty
                                        ? 'Enter your First name'
                                        : null,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: "First Name",
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontFamily:
                                            'Montserrat-SemiBold',
                                            fontWeight:
                                            FontWeight.normal),
                                        focusedBorder:
                                        UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors
                                                    .black))),
                                    onChanged: (val) {
                                      setState(() {
                                        profile.firstName = val;
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FadeAnimation(
                            1.8,
                            100,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: InputTextFormDecoration()
                                  .containerBoxDecoration(),
                              child: Column(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 8.0, left: 8.0),
                                  decoration:
                                  InputTextFormDecoration()
                                      .formBoxDecoration(),
                                  child: TextFormField(
                                    initialValue: profile.lastName ?? '',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 20),
                                    validator: (value) =>
                                    value.isEmpty
                                        ? 'Enter your last name'
                                        : null,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: "Last Name",
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontFamily:
                                            'Montserrat-SemiBold',
                                            fontWeight:
                                            FontWeight.normal),
                                        focusedBorder:
                                        UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors
                                                    .black))),
                                    onChanged: (val) {
                                      setState(() {
                                        profile.lastName = val;
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FadeAnimation(
                            1.8,
                            100,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: InputTextFormDecoration()
                                  .containerBoxDecoration(),
                              child: Column(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 8.0, left: 8.0),
                                  decoration:
                                  InputTextFormDecoration()
                                      .formBoxDecoration(),
                                  child: TextFormField(
                                    initialValue: profile.age ?? '',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 20),
                                    validator: (value) =>
                                    value.isEmpty
                                        ? 'Enter your age'
                                        : null,
                                    keyboardType:
                                    TextInputType.number,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: "Age",
                                        labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontFamily:
                                            'Montserrat-SemiBold',
                                            fontWeight:
                                            FontWeight.normal),
                                        focusedBorder:
                                        UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors
                                                    .black))),
                                    onChanged: (val) {
                                      setState(() {
                                        profile.age = val;
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FadeAnimation(
                            1.8,
                            100,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: InputTextFormDecoration()
                                  .containerBoxDecoration(),
                              child: Column(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 8.0, left: 8.0),
                                  decoration:
                                  InputTextFormDecoration()
                                      .formBoxDecoration(),
                                  child: DropdownButtonFormField(
                                    value: profile.currentEducation ?? '',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 20),
                                    validator: (value) => value ==
                                        null ||
                                        value.isEmpty
                                        ? 'Select your current education'
                                        : null,
                                    decoration: InputTextFormDecoration(
                                        text:
                                        'Current Education')
                                        .inputFormDecoration(),
                                    items: education
                                        .map((educationType) {
                                      return DropdownMenuItem(
                                          value: educationType,
                                          child:
                                          Text(educationType));
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        profile.currentEducation = val;
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FadeAnimation(
                            1.8,
                            100,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: InputTextFormDecoration()
                                  .containerBoxDecoration(),
                              child: Column(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 8.0, left: 8.0),
                                  decoration:
                                  InputTextFormDecoration()
                                      .formBoxDecoration(),
                                  child: TextFormField(
                                    initialValue: profile.institutionName,
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 20),
                                    validator: (value) => value
                                        .isEmpty
                                        ? 'Enter the name of the institution'
                                        : null,
                                    decoration:
                                    InputTextFormDecoration(
                                        text:
                                        'Institution Name')
                                        .inputFormDecoration(),
                                    onChanged: (val) {
                                      setState(() {
                                        profile.institutionName = val;
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FadeAnimation(
                            1.8,
                            100,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: InputTextFormDecoration()
                                  .containerBoxDecoration(),
                              child: Column(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 8.0, left: 8.0),
                                  decoration:
                                  InputTextFormDecoration()
                                      .formBoxDecoration(),
                                  child: TextFormField(
                                    initialValue: profile.contactName ?? '',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 20),
                                    validator: (value) => value
                                        .isEmpty
                                        ? 'Please enter contact person name'
                                        : null,
                                    decoration: InputTextFormDecoration(
                                        text:
                                        'Name of contact person')
                                        .inputFormDecoration(),
                                    onChanged: (val) {
                                      setState(() {
                                        profile.contactName = val;
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FadeAnimation(
                            1.8,
                            100,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: InputTextFormDecoration()
                                  .containerBoxDecoration(),
                              child: Column(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 8.0, left: 8.0),
                                  decoration:
                                  InputTextFormDecoration()
                                      .formBoxDecoration(),
                                  child: TextFormField(
                                    initialValue: profile.contactNumber ?? '',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 20),
                                    validator: (value) => value
                                        .isEmpty
                                        ? 'Please enter contact number'
                                        : null,
                                    keyboardType:
                                    TextInputType.number,
                                    decoration:
                                    InputTextFormDecoration(
                                        text:
                                        'Contact number')
                                        .inputFormDecoration(),
                                    onChanged: (val) {
                                      setState(() {
                                        profile.contactNumber = val;
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FadeAnimation(
                            1.8,
                            100,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: InputTextFormDecoration()
                                  .containerBoxDecoration(),
                              child: Column(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 8.0, left: 8.0),
                                  decoration:
                                  InputTextFormDecoration()
                                      .formBoxDecoration(),
                                  child: TextFormField(
                                    initialValue: profile.height ?? '',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 20),
                                    validator: (value) =>
                                    value.isEmpty
                                        ? 'Please enter height'
                                        : null,
                                    keyboardType:
                                    TextInputType.number,
                                    decoration:
                                    InputTextFormDecoration(
                                        text:
                                        'Height in cm')
                                        .inputFormDecoration(),
                                    onChanged: (val) {
                                      setState(() {
                                        profile.height = val;
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FadeAnimation(
                            1.8,
                            100,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: InputTextFormDecoration()
                                  .containerBoxDecoration(),
                              child: Column(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 8.0, left: 8.0),
                                  decoration:
                                  InputTextFormDecoration()
                                      .formBoxDecoration(),
                                  child: TextFormField(
                                    initialValue: profile.weight ?? '',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 20),
                                    validator: (value) => value == null ||
                                        value.isEmpty
                                        ? 'Please enter weight'
                                        : null,
                                    keyboardType:
                                    TextInputType.number,
                                    decoration:
                                    InputTextFormDecoration(
                                        text:
                                        'Weight in kg')
                                        .inputFormDecoration(),
                                    onChanged: (val) {
                                      setState(() {
                                        profile.weight = val;
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FadeAnimation(
                            1.8,
                            100,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: InputTextFormDecoration()
                                  .containerBoxDecoration(),
                              child: Column(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 8.0, left: 8.0),
                                  decoration:
                                  InputTextFormDecoration()
                                      .formBoxDecoration(),
                                  child: DropdownButtonFormField(
                                    value: profile.kitSize ?? '',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 20),
                                    validator: (value) =>
                                    value == null ||
                                        value.isEmpty
                                        ? 'Select your kit size'
                                        : null,
                                    decoration:
                                    InputTextFormDecoration(
                                        text: 'Kit Size')
                                        .inputFormDecoration(),
                                    items: kitSize.map((size) {
                                      return DropdownMenuItem(
                                          value: size,
                                          child: Text(size));
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        profile.kitSize = val;
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FadeAnimation(
                            1.8,
                            100,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: InputTextFormDecoration()
                                  .containerBoxDecoration(),
                              child: Column(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 8.0, left: 8.0),
                                  decoration:
                                  InputTextFormDecoration()
                                      .formBoxDecoration(),
                                  child: DropdownButtonFormField(
                                    value: profile.positionOfPlay ?? '',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 20),
                                    validator: (value) =>
                                    value == null ||
                                        value.isEmpty
                                        ? 'Select your position'
                                        : null,
                                    decoration:
                                    InputTextFormDecoration(
                                        text:
                                        'Position of Play')
                                        .inputFormDecoration(),
                                    items: position
                                        .map((positionOfPlay) {
                                      return DropdownMenuItem(
                                          value: positionOfPlay,
                                          child:
                                          Text(positionOfPlay));
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        profile.positionOfPlay = val;
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FadeAnimation(
                            1.8,
                            100,
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: InputTextFormDecoration()
                                  .containerBoxDecoration(),
                              child: Column(children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(
                                      bottom: 8.0, left: 8.0),
                                  decoration:
                                  InputTextFormDecoration()
                                      .formBoxDecoration(),
                                  child: DropdownButtonFormField(
                                    value: profile.foot ?? '',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 20),
                                    validator: (value) =>
                                    value == null ||
                                        value.isEmpty
                                        ? 'Select your strong foot'
                                        : null,
                                    decoration:
                                    InputTextFormDecoration(
                                        text:
                                        'Strong Foot')
                                        .inputFormDecoration(),
                                    items: foot
                                        .map((strongFoot) {
                                      return DropdownMenuItem(
                                          value: strongFoot,
                                          child:
                                          Text(strongFoot));
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        profile.foot = val;
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              ButtonTheme(
                minWidth: double.infinity,
                height: 40.0,
                child: RaisedButton(
                  child: Text(
                    'Update',
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
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        loading = true;
                      });
                      print(profile.toJson());
                      var result = await _databaseService.updateProfile(profile, profile.uid);
                      if (result is String){
                        setState(() {
                          loading = false;
                        });
                        showInSnackBar("Success Your profile is updated!!!");
                      }
                      else {
                        showInSnackBar("Oops Something went wrong! \n Profile not updated :( ");
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
