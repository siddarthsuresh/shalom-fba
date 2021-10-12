import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shalom_fba/model/Attendance.dart';
import 'package:shalom_fba/model/Profile.dart';

class DatabaseService {

  final String uid;

  DatabaseService({this.uid});

  final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('Profiles');
  final CollectionReference attendanceCollection =
      FirebaseFirestore.instance.collection('Attendance');

  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  List<Profile> _getProfileFromMap(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) => Profile.fromMap(e, e.id)).toList();
  }

  Stream<DocumentSnapshot> getProfileDetails() {
    return profileCollection.doc(uid).snapshots();
  }

  Stream<List<Profile>> getProfiles() {
    return profileCollection.snapshots().map(_getProfileFromMap);
  }

  List<Attendance> _getAttendance(QuerySnapshot snapshot, String date) {
    print ('$date : ${snapshot.docs.length}');
    return snapshot.docs.map((e) => Attendance.fromMap(e, e.id, date)).toList();
  }

  Future<List<Attendance>> getAttendanceDetails() async {
    List<Attendance> attendanceList = [];
    return await attendanceCollection.get().then((val) => val.docs).then((value) async {
      for (int i = 0; i < value.length; i++) {
        print('Date : ${value[i].id}');
      Stream<List<Attendance>> attendance = attendanceCollection
            .doc(value[i].id)
            .collection("Present").snapshots().map((event) =>
          _getAttendance(event, value[i].id));
        attendance.listen((element) {
              attendanceList.addAll(element);
      });
      print('attendance added');
      }
      await Future.delayed(Duration(seconds: 1));
      print('size : ${attendanceList.length}');
      return attendanceList;
    });
  }


  Stream<List<Profile>> getProfilesByCategory(int category) {
    if (category == 10) {
      return profileCollection
          .where("age", isLessThanOrEqualTo: category.toString())
          .snapshots()
          .map(_getProfileFromMap);
    } else if (category == 16) {
      return profileCollection
          .where("age", isGreaterThan: "10")
          .where("age", isLessThanOrEqualTo: category.toString())
          .snapshots()
          .map(_getProfileFromMap);
    } else if (category == 21) {
      return profileCollection
          .where("age", isGreaterThan: "16")
          .where("age", isLessThanOrEqualTo: category.toString())
          .snapshots()
          .map(_getProfileFromMap);
    } else {
      return profileCollection
          .where("age", isGreaterThan: "21")
          .where("age", isLessThanOrEqualTo: category.toString())
          .snapshots()
          .map(_getProfileFromMap);
    }
  }

  Future<bool> isAdmin() async {
    DocumentSnapshot documentSnapshot = await profileCollection.doc(uid).get();
    String admin = documentSnapshot['isAdmin'];
    if (admin != null && admin == 'true') {
      print('isAdmin == true');
      return true;
    } else {
      print('isAdmin == false');
      return false;
    }
  }

  Future createProfile(Profile profileData) async {
    try {
      String imageURL = await saveImages(profileData.image, uid);
      await profileCollection
          .doc(uid)
          .set(profileData.toJson())
          .then((_) async {
        return await profileCollection
            .doc(uid)
            .update({"profileImage": imageURL});
      });
    } catch (e) {
      return e.toString();
    }
  }

  Future updateAttendance(List<Profile> profilesList) async {
    DateTime selectedDate = DateTime.now();
    String status = "";
    print('inside update Attendance');
    profilesList.forEach((profile) async {
      print('updating for ${profile.firstName}');
       await attendanceCollection
          .doc("${selectedDate.toLocal()}".split(' ')[0])
          .collection("Present")
          .doc("${profile.uid}")
          .set({"name": "${profile.firstName} ${profile.lastName}"});
    });
    return await attendanceCollection
        .doc("${selectedDate.toLocal()}".split(' ')[0]).set({"Status" : "Present"});
  }

  Future updateProfileImage(String url, String userId) async {
    return await profileCollection
        .doc(userId)
        .update({"profileImage": url}).then((_) {
      print('Updated Image URL');
    });
  }

  Future<String> updateProfile(Profile profile, String userId) async {
    return await profileCollection
        .doc(userId)
        .update(profile.toJson())
        .then((_) {
      return 'Updated Profile';
    });
  }

  Future<String> saveImages(File _image, String userId) async {
    return await uploadFile(_image, userId);
  }

  Future<String> uploadFile(File _image, String userId) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Profiles/Images/$userId');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
    });
    return returnURL;
  }

  Future<bool> checkExist() async {
    try {
      var doc = await profileCollection.doc(uid).get();
      bool isDocExists = doc.exists;
      print('Is Doc Exists : $isDocExists');
      return isDocExists;
    } catch (e) {
      throw e;
    }
  }
}
