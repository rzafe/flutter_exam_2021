
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Helpers {
  late final DateTime currentSnackBarTime;

  Future<bool> checkInternetConnection() async {
    final ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  void createSnackBar(String message, BuildContext context) {
    final DateTime now = DateTime.now();

    final SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
    );

    if (currentSnackBarTime == null ||
        now.difference(currentSnackBarTime) > const Duration(seconds: 5)) {
      currentSnackBarTime = now;

      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      // timeInSecForIos: 2,
    );
  }

  void openLoadingDialogWithMessage(BuildContext context, String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            content: Wrap(
              children: <Widget>[
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: <Widget>[
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      const SizedBox(width: 20,),
                      Text(
                        message,
                        style: const TextStyle(fontSize: 19),),
                    ],
                  ),
                )
              ],
            )
        );
      },
    );
  }

}