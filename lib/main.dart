import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shalom_fba/screens/attendance_calendar.dart';
import 'package:shalom_fba/screens/build_profile.dart';
import 'package:shalom_fba/screens/category/player_list.dart';
import 'package:shalom_fba/screens/home/about_us.dart';
import 'package:shalom_fba/screens/home/dashboard.dart';
import 'package:shalom_fba/screens/home/home.dart';
import 'package:shalom_fba/screens/login/sign_in.dart';
import 'package:shalom_fba/screens/login/sign_up.dart';
import 'package:shalom_fba/service/authentication_service.dart';
import 'package:shalom_fba/wrapper.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(create: (_) => AuthenticationService(FirebaseAuth.instance)),
          StreamProvider(create: (context) => context.read<AuthenticationService>().authStateChanges),
        ],
        child: MaterialApp(
          home: Wrapper(),
          routes: {
            '/signUp': (context) => SignUp(),
            '/signIn': (context) => SignIn(),
            '/dashboard': (context) => DashboardPage(),
            '/wrapper': (context) => Wrapper(),
            '/buildProfile': (context) => BuildProfile(),
            '/playersList':(context) => PlayersList(),
            '/attendanceCalendar':(context) => AttendanceCalendar(),
            '/aboutUs': (context) => AboutUs(),
            '/adminHome':(context) => AdminHome()
          }
        ));
  }
}


