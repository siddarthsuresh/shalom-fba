import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shalom_fba/Animation/faded_animation.dart';
import 'package:shalom_fba/model/Profile.dart';
import 'package:shalom_fba/screens/decoration/alert_dialog.dart';
import 'package:shalom_fba/screens/decoration/input_decoration.dart';
import 'package:shalom_fba/service/authentication_service.dart';
import 'package:shalom_fba/service/database_service.dart';

import 'loading.dart';

class BuildProfile extends StatefulWidget {
  @override
  _BuildProfileState createState() => _BuildProfileState();
}

class _BuildProfileState extends State<BuildProfile> {
  Profile profile = new Profile();
  final AuthenticationService _authService =
      AuthenticationService(FirebaseAuth.instance);
  final DatabaseService _databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);
  final _formKey = GlobalKey<FormState>();
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
  String error = '';
  bool loading = false;
  DateTime selectedDate = DateTime.now();
  List<File> _images = [];
  File _image; // Used only if you need a single picture

  Future getImage(bool gallery) async {
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

    setState(() {
      if (pickedFile != null) {
        // _images.add(File(pickedFile.path));
        _image = File(pickedFile.path);
        profile.image = _image ?? ""; // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1960, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        profile.dateOfBirth = selectedDate;
        _controller.text = ("${selectedDate.toLocal()}".split(' ')[0]);
      });
  }

  var _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 70.0,
                    child: SingleChildScrollView(
                        child: Container(
                            color: Colors.black87,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/only_background.jpg'),
                                        fit: BoxFit.fill)),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 60.0, bottom: 50.0),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                            'Setup your profile',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Montserrat-Light',
                                                fontSize: 40.0,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
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
                                        padding: EdgeInsets.only(
                                            top: 35.0, left: 25.0, right: 20.0),
                                        child: Column(children: [
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Form(
                                            key: _formKey,
                                            child: Column(children: [
                                              FadeAnimation(
                                                1.8,
                                                100,
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration:
                                                      InputTextFormDecoration()
                                                          .containerBoxDecoration(),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0,
                                                          left: 8.0),
                                                      decoration:
                                                          InputTextFormDecoration()
                                                              .formBoxDecoration(),
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 20),
                                                        validator: (value) => value
                                                                .isEmpty
                                                            ? 'Enter your first name'
                                                            : null,
                                                        decoration: InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            labelText:
                                                                "First Name",
                                                            labelStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Montserrat-SemiBold',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                            focusedBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black))),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            profile.firstName =
                                                                val;
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
                                                  decoration:
                                                      InputTextFormDecoration()
                                                          .containerBoxDecoration(),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0,
                                                          left: 8.0),
                                                      decoration:
                                                          InputTextFormDecoration()
                                                              .formBoxDecoration(),
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 20),
                                                        validator: (value) => value
                                                                .isEmpty
                                                            ? 'Enter your last name'
                                                            : null,
                                                        decoration: InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            labelText:
                                                                "Last Name",
                                                            labelStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Montserrat-SemiBold',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                            focusedBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black))),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            profile.lastName =
                                                                val;
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
                                                  decoration:
                                                      InputTextFormDecoration()
                                                          .containerBoxDecoration(),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0,
                                                          left: 8.0),
                                                      decoration:
                                                          InputTextFormDecoration()
                                                              .formBoxDecoration(),
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 20),
                                                        validator: (value) =>
                                                            value.isEmpty
                                                                ? 'Enter your age'
                                                                : null,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration: InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            labelText: "Age",
                                                            labelStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Montserrat-SemiBold',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                            focusedBorder: UnderlineInputBorder(
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
                                                  decoration:
                                                      InputTextFormDecoration()
                                                          .containerBoxDecoration(),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0,
                                                          left: 8.0),
                                                      decoration:
                                                          InputTextFormDecoration()
                                                              .formBoxDecoration(),
                                                      child: TextFormField(
                                                        controller: _controller,
                                                        enableInteractiveSelection:
                                                            false,
                                                        // will disable paste operation
                                                        focusNode:
                                                            new AlwaysDisabledFocusNode(),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 20),
                                                        validator: (value) => value
                                                                .isEmpty
                                                            ? 'Enter your date of birth'
                                                            : null,
                                                        decoration:
                                                            InputDecoration(
                                                                suffixIcon:
                                                                    IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    _selectDate(
                                                                        context);
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .calendar_today),
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                labelText:
                                                                    "Date of Birth",
                                                                labelStyle: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Montserrat-SemiBold',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                                focusedBorder:
                                                                    UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Colors.black))),
                                                        onChanged: (val) {},
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
                                                  decoration:
                                                      InputTextFormDecoration()
                                                          .containerBoxDecoration(),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0,
                                                          left: 8.0),
                                                      decoration:
                                                          InputTextFormDecoration()
                                                              .formBoxDecoration(),
                                                      child:
                                                          DropdownButtonFormField(
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 20),
                                                        validator: (value) =>
                                                            value == null ||
                                                                    value
                                                                        .isEmpty
                                                                ? 'Select your current education'
                                                                : null,
                                                        decoration: InputTextFormDecoration(
                                                                text:
                                                                    'Current Education')
                                                            .inputFormDecoration(),
                                                        items: education.map(
                                                            (educationType) {
                                                          return DropdownMenuItem(
                                                              value:
                                                                  educationType,
                                                              child: Text(
                                                                  educationType));
                                                        }).toList(),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            profile.currentEducation =
                                                                val;
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
                                                  decoration:
                                                      InputTextFormDecoration()
                                                          .containerBoxDecoration(),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0,
                                                          left: 8.0),
                                                      decoration:
                                                          InputTextFormDecoration()
                                                              .formBoxDecoration(),
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 20),
                                                        validator: (value) => value
                                                                .isEmpty
                                                            ? 'Enter the name of the institution'
                                                            : null,
                                                        decoration: InputTextFormDecoration(
                                                                text:
                                                                    'Institution Name')
                                                            .inputFormDecoration(),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            profile.institutionName =
                                                                val;
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
                                                  decoration:
                                                      InputTextFormDecoration()
                                                          .containerBoxDecoration(),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0,
                                                          left: 8.0),
                                                      decoration:
                                                          InputTextFormDecoration()
                                                              .formBoxDecoration(),
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
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
                                                            profile.contactName =
                                                                val;
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
                                                  decoration:
                                                      InputTextFormDecoration()
                                                          .containerBoxDecoration(),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0,
                                                          left: 8.0),
                                                      decoration:
                                                          InputTextFormDecoration()
                                                              .formBoxDecoration(),
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 20),
                                                        validator: (value) => value
                                                                .isEmpty
                                                            ? 'Please enter contact number'
                                                            : null,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration: InputTextFormDecoration(
                                                                text:
                                                                    'Contact number')
                                                            .inputFormDecoration(),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            profile.contactNumber =
                                                                val;
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
                                                  decoration:
                                                      InputTextFormDecoration()
                                                          .containerBoxDecoration(),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0,
                                                          left: 8.0),
                                                      decoration:
                                                          InputTextFormDecoration()
                                                              .formBoxDecoration(),
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 20),
                                                        validator: (value) => value
                                                                .isEmpty
                                                            ? 'Please enter height'
                                                            : null,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration: InputTextFormDecoration(
                                                                text:
                                                                    'Height in cm')
                                                            .inputFormDecoration(),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            profile.height =
                                                                val;
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
                                                  decoration:
                                                      InputTextFormDecoration()
                                                          .containerBoxDecoration(),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0,
                                                          left: 8.0),
                                                      decoration:
                                                          InputTextFormDecoration()
                                                              .formBoxDecoration(),
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 20),
                                                        validator: (value) =>
                                                            value == null ||
                                                                    value
                                                                        .isEmpty
                                                                ? 'Please enter weight'
                                                                : null,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration: InputTextFormDecoration(
                                                                text:
                                                                    'Weight in kg')
                                                            .inputFormDecoration(),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            profile.weight =
                                                                val;
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
                                                  decoration:
                                                      InputTextFormDecoration()
                                                          .containerBoxDecoration(),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0,
                                                          left: 8.0),
                                                      decoration:
                                                          InputTextFormDecoration()
                                                              .formBoxDecoration(),
                                                      child:
                                                          DropdownButtonFormField(
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 20),
                                                        validator: (value) =>
                                                            value == null ||
                                                                    value
                                                                        .isEmpty
                                                                ? 'Select your kit size'
                                                                : null,
                                                        decoration:
                                                            InputTextFormDecoration(
                                                                    text:
                                                                        'Kit Size')
                                                                .inputFormDecoration(),
                                                        items:
                                                            kitSize.map((size) {
                                                          return DropdownMenuItem(
                                                              value: size,
                                                              child:
                                                                  Text(size));
                                                        }).toList(),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            profile.kitSize =
                                                                val;
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
                                                  decoration:
                                                      InputTextFormDecoration()
                                                          .containerBoxDecoration(),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0,
                                                          left: 8.0),
                                                      decoration:
                                                          InputTextFormDecoration()
                                                              .formBoxDecoration(),
                                                      child:
                                                          DropdownButtonFormField(
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 20),
                                                        validator: (value) =>
                                                            value == null ||
                                                                    value
                                                                        .isEmpty
                                                                ? 'Select your position'
                                                                : null,
                                                        decoration: InputTextFormDecoration(
                                                                text:
                                                                    'Position of Play')
                                                            .inputFormDecoration(),
                                                        items: position.map(
                                                            (positionOfPlay) {
                                                          return DropdownMenuItem(
                                                              value:
                                                                  positionOfPlay,
                                                              child: Text(
                                                                  positionOfPlay));
                                                        }).toList(),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            profile.positionOfPlay =
                                                                val;
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
                                                  decoration:
                                                      InputTextFormDecoration()
                                                          .containerBoxDecoration(),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0,
                                                          left: 8.0),
                                                      decoration:
                                                          InputTextFormDecoration()
                                                              .formBoxDecoration(),
                                                      child:
                                                          DropdownButtonFormField(
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 20),
                                                        validator: (value) =>
                                                            value == null ||
                                                                    value
                                                                        .isEmpty
                                                                ? 'Select your strong foot'
                                                                : null,
                                                        decoration: InputTextFormDecoration(
                                                                text:
                                                                    'Strong Foot')
                                                            .inputFormDecoration(),
                                                        items: foot
                                                            .map((strongFoot) {
                                                          return DropdownMenuItem(
                                                              value: strongFoot,
                                                              child: Text(
                                                                  strongFoot));
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
                                              SizedBox(
                                                height: 10.0,
                                              ),
                                              FadeAnimation(
                                                1.8,
                                                100,
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration:
                                                      InputTextFormDecoration()
                                                          .containerBoxDecoration(),
                                                  child:
                                                      Column(children: <Widget>[
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: 8.0,
                                                          left: 8.0),
                                                      decoration:
                                                          InputTextFormDecoration()
                                                              .formBoxDecoration(),
                                                      child: TextFormField(
                                                        enableInteractiveSelection:
                                                            false,
                                                        // will disable paste operation
                                                        focusNode:
                                                            new AlwaysDisabledFocusNode(),
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 20),
                                                        validator: (value) =>
                                                            _image == null
                                                                ? 'Please upload your picture'
                                                                : null,
                                                        decoration:
                                                            InputDecoration(
                                                                suffixIcon:
                                                                    IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    getImage(
                                                                        true);
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .add_photo_alternate_rounded),
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                labelText:
                                                                    "Upload Picture",
                                                                labelStyle: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Montserrat-SemiBold',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                                focusedBorder:
                                                                    UnderlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide(color: Colors.black))),
                                                        onChanged: (val) {
                                                          setState(() {
                                                            profile.photoUrl =
                                                                _image ?? "";
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      child: _image != null
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Image.file(
                                                                  _image),
                                                            )
                                                          : SizedBox(
                                                              height: 0.0),
                                                    )
                                                  ]),
                                                ),
                                              ),
                                            ]),
                                          ),
                                          // SizedBox(
                                          //   height: 20.0,
                                          // ),
                                          // ButtonTheme(
                                          //   minWidth: double.infinity,
                                          //   height: 40.0,
                                          //   child: RaisedButton(
                                          //     child: Text(
                                          //       'Submit',
                                          //       style: TextStyle(
                                          //           color: Colors.white,
                                          //           fontWeight:
                                          //               FontWeight.normal,
                                          //           fontFamily:
                                          //               'Montserrat-Bold'),
                                          //     ),
                                          //     color: Colors.black,
                                          //     shape: RoundedRectangleBorder(
                                          //         borderRadius:
                                          //             BorderRadius.only(
                                          //                 topLeft:
                                          //                     Radius.circular(
                                          //                         10),
                                          //                 bottomLeft:
                                          //                     Radius.circular(
                                          //                         10),
                                          //                 bottomRight:
                                          //                     Radius.circular(
                                          //                         10)),
                                          //         side: BorderSide(
                                          //             color: Colors.black)),
                                          //     onPressed: () async {
                                          //       if (_formKey.currentState
                                          //           .validate()) {
                                          //         setState(() {
                                          //           loading = true;
                                          //         });
                                          //         print(profile.toJson());
                                          //         var result =
                                          //             await _databaseService
                                          //                 .createProfile(
                                          //                     profile);
                                          //         if (result is String) {
                                          //           setState(() {
                                          //             loading = false;
                                          //           });
                                          //           AlertDialogBox(
                                          //                   "Oops",
                                          //                   "Something went wrong! \n Profile not created :( ",
                                          //                   '/buildProfile')
                                          //               .confirmationPopup(
                                          //                   context)
                                          //               .show();
                                          //         } else {
                                          //           AlertDialogBox(
                                          //                   "Success",
                                          //                   "Your profile is created!!!",
                                          //                   '/dashboard')
                                          //               .confirmationPopup(
                                          //                   context)
                                          //               .show();
                                          //         }
                                          //       }
                                          //     },
                                          //   ),
                                          // ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                        ]),
                                      ),
                                    ]),
                              ),
                            ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                    child: ButtonTheme(
                      minWidth: double.infinity,
                      height: 40.0,
                      child: RaisedButton(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight:
                              FontWeight.normal,
                              fontFamily:
                              'Montserrat-Bold'),
                        ),
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.only(
                                topLeft:
                                Radius.circular(
                                    10),
                                bottomLeft:
                                Radius.circular(
                                    10),
                                bottomRight:
                                Radius.circular(
                                    10)),
                            side: BorderSide(
                                color: Colors.black)),
                        onPressed: () async {
                          if (_formKey.currentState
                              .validate()) {
                            setState(() {
                              loading = true;
                            });
                            print(profile.toJson());
                            profile.isAdmin = "false";
                            var result =
                            await _databaseService
                                .createProfile(
                                profile);
                            if (result is String) {
                              setState(() {
                                loading = false;
                              });
                              AlertDialogBox(
                                  "Oops",
                                  "Something went wrong! \n Please try again :( ",
                                  '/buildProfile')
                                  .confirmationPopup(
                                  context)
                                  .show();
                            } else {
                              AlertDialogBox(
                                  "Success",
                                  "Your profile is created!!!",
                                  '/dashboard')
                                  .confirmationPopup(
                                  context)
                                  .show();
                            }
                          }
                          else {
                            AlertDialogBox(
                                "Oops",
                                "Please fill all the required fields! ",
                                '')
                                .confirmationPopup(
                                context)
                                .show();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Uncomment to enable Floating Action button
            /*floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  setState(() {
                    loading = true;
                  });
                  print(profile.toJson());
                  var result = await _databaseService.createProfile(profile);
                  if (result is String) {
                    AlertDialogBox(
                            "Oops",
                            "Something went wrong! \n Profile not created :( ",
                            '/buildProfile')
                        .confirmationPopup(context)
                        .show();
                  } else {
                    AlertDialogBox("Success", "Your profile is created!!!",
                            '/dashboard')
                        .confirmationPopup(context)
                        .show();
                  }
                }
              },
              child: Icon(
                Icons.done_rounded,
                color: Colors.white,
              ),
              backgroundColor: Colors.black,
            ),*/
          );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
