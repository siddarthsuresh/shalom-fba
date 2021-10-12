import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';

class AlertDialogBox{

  final String title;
  final String desc;
  final String route;
  AlertDialogBox(this.title, this.desc, this.route);

  Alert confirmationPopup(BuildContext dialogContext) {
  var alertStyle = AlertStyle(
    animationType: AnimationType.grow,
    overlayColor: Colors.black87,
    isOverlayTapDismiss: false,
    isCloseButton: false,
    titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
    animationDuration: Duration(milliseconds: 300),
  );

  return Alert(
      context: dialogContext,
      style: alertStyle,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          child: Text(
            "Okay",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () async {
            if (route.isNotEmpty){
              Navigator.pop(dialogContext);
              await Navigator.of((dialogContext)).popAndPushNamed(route);
            }
            else {
              Navigator.pop(dialogContext, true);
            }
          },
          color: Colors.black,
        )
      ]);
}
}