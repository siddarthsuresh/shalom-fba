import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String _uid;
  String _firstName;
  String _lastName;
  String _age;
  DateTime _dateOfBirth;
  String _currentEducation;
  String _institutionName;
  String _contactName;
  String _contactNumber;
  String _height;
  String _weight;
  String _kitSize;
  String _positionOfPlay;
  File _uploadImage;
  String _downloadURL;
  String _foot;
  String _isAdmin;


  String get isAdmin => _isAdmin;

  set isAdmin(String value) {
    _isAdmin = value;
  }

  String get foot => _foot;

  set foot(String value) {
    _foot = value;
  }

  File get uploadImage => _uploadImage;

  set uploadImage(File value) {
    _uploadImage = value;
  }

  Profile();

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get lastName => _lastName;

  set lastName(String value) {
    _lastName = value;
  }

  String get photoUrl => _downloadURL;

  set photoUrl(String value) {
    _downloadURL = value;
  }

  String get positionOfPlay => _positionOfPlay;

  set positionOfPlay(String value) {
    _positionOfPlay = value;
  }

  String get kitSize => _kitSize;

  set kitSize(String value) {
    _kitSize = value;
  }

  String get weight => _weight;

  set weight(String value) {
    _weight = value;
  }

  String get height => _height;

  set height(String value) {
    _height = value;
  }

  String get contactNumber => _contactNumber;

  set contactNumber(String value) {
    _contactNumber = value;
  }

  String get contactName => _contactName;

  set contactName(String value) {
    _contactName = value;
  }

  String get institutionName => _institutionName;

  set institutionName(String value) {
    _institutionName = value;
  }

  String get currentEducation => _currentEducation;

  set currentEducation(String value) {
    _currentEducation = value;
  }

  DateTime get dateOfBirth => _dateOfBirth;

  set dateOfBirth(DateTime value) {
    _dateOfBirth = value;
  }

  String get age => _age;

  set age(String value) {
    _age = value;
  }

  File get image => _uploadImage;

  set image(File value) {
    _uploadImage = value;
  }

  String get downloadURL => _downloadURL;

  set downloadURL(String value) {
    _downloadURL = value;
  }

  Profile.fromMap(DocumentSnapshot snapshot, String id) :
        _uid = id ?? '',
        _firstName = snapshot['firstName'] ?? '',
        _lastName = snapshot['lastName'] ?? '',
        _age = snapshot['age'] ?? '',
        _dateOfBirth = DateTime.parse(snapshot['dateOfBirth']) ?? '',
        _currentEducation = snapshot['currentEducation'] ?? '',
        _institutionName = snapshot['institutionName'] ?? '',
        _contactName = snapshot['contactName'] ?? '',
        _contactNumber = snapshot['contactNumber'] ?? '',
        _height = snapshot['height'] ?? '',
        _weight = snapshot['weight'] ?? '',
        _kitSize = snapshot['kitSize'] ?? '',
        _positionOfPlay = snapshot['positionOfPlay'] ?? '',
        _downloadURL = snapshot['profileImage'] ?? '',
        _foot = snapshot['foot'] ?? '',
        _isAdmin = snapshot['isAdmin'] ?? '';

  toJson(){
    return {
      "firstName": _firstName,
      "lastName": _lastName,
      "age": _age,
      "dateOfBirth": _dateOfBirth.toString(),
      "currentEducation": _currentEducation,
      "institutionName": _institutionName,
      "contactName": _contactName,
      "contactNumber": _contactNumber,
      "height": _height,
      "weight": _weight,
      "kitSize": _kitSize,
      "positionOfPlay": _positionOfPlay,
      "foot": _foot,
      "isAdmin": _isAdmin
    };
  }

}