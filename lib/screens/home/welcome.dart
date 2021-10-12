import 'package:flutter/material.dart';
import 'package:shalom_fba/Animation/faded_animation.dart';
import 'package:shalom_fba/screens/home/dashboard.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome_background_new.jpg'),
            fit: BoxFit.fill
          )
        ),
        child: FadeAnimation(
          0.5, 500,
          Container(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 100.0,),
                    Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: Image(
                        image: AssetImage('assets/images/shalomlogofinal.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      'Welcome to ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: 'Montserrat-SemiBold',
                          fontSize: 30.0,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      'Shalom Football Academy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: 'Montserrat-SemiBold',
                          fontSize: 30.0,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 25.0, left: 20.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text("Get Started", style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat-Bold',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FadeAnimation(0.5,500,Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: FloatingActionButton(
          onPressed: (){
            Navigator.of((context)).popAndPushNamed('/buildProfile');
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DashboardPage()));
          },
          child: Icon(Icons.arrow_right_alt,
          color: Colors.black,),
          backgroundColor: Colors.white,
        ),
      ),
      ),
    );
  }
}
