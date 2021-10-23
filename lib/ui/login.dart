import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exam_2021/model/api_result.dart';
import 'package:flutter_exam_2021/service/api/cms/login_presenter.dart';
import 'package:flutter_exam_2021/utilities/helpers.dart';
import 'package:http/http.dart' as http;

import 'screen1.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late BuildContext scaffoldContext;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRememberMe = false;
  bool isErrorEmailAdd = false;
  bool isErrorPassword = false;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode rememberMeFocusNode = FocusNode();
  int backPress = 0;

  final LoginPresentation loginPresentation = LoginPresentation();
  final Helpers helpers = Helpers();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _onBackPressed(),
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Builder(
          builder: (BuildContext context) {
            scaffoldContext = context;
            return SafeArea(
              child: Container(
                  color: Colors.blue,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: _loginLayout(),
                      ),
                      Text(
                        'v1.0.0',
                        style: const TextStyle(
                          color: Colors.black,),
                      ),
                    ],
                  )
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _loginLayout() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width / 2,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Text(
                            'Login into your account',
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'RobotoRegular',
                                fontSize: 15),
                          ),
                        ),
                        _emailLayout(),
                        _passwordLayout(),
                        // _rememberMeLayout(),
                        SizedBox(height: 20,),
                        loginButtonLayout(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailLayout() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      height: 58,
      child: TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: emailFocusNode,
        onFieldSubmitted: (String term) {
          _fieldFocusChange(context, emailFocusNode, passwordFocusNode);
        },
        keyboardType: TextInputType.text,
        inputFormatters: [
          WhitelistingTextInputFormatter(
            RegExp('[a-zA-Z0-9_.@]'),
          )
        ],
        cursorColor: Colors.blue,
        controller: _emailController,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.person,
            color: Colors.blue,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                color: isErrorEmailAdd == false
                    ? Colors.transparent : Colors.red
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                width: 2.0,
                color: isErrorEmailAdd == false
                    ? Colors.blue : Colors.red
            ),
          ),
          border: const OutlineInputBorder(),
          labelText: 'Mobile Number',
          labelStyle: const TextStyle(
              fontFamily: 'RobotoRegular',
              fontSize: 15),
          fillColor: Colors.green.withOpacity(0.5),
          filled: true,
        ),
        style: const TextStyle(
            fontSize: 15,
            fontFamily: 'RobotoRegular',
            color: Colors.black),
      ),
    );
  }

  Widget _passwordLayout() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      height: 58,
      child: TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: passwordFocusNode,
        onFieldSubmitted: (String term) {
          _fieldFocusChange(context, passwordFocusNode, rememberMeFocusNode);
        },
        keyboardType: TextInputType.text,
        inputFormatters: [
          WhitelistingTextInputFormatter(
            RegExp('[a-zA-Z0-9_.@]'),
          )
        ],
        cursorColor: Colors.blue,
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.vpn_key,
            color: Colors.blue,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                color: isErrorPassword == false
                    ? Colors.transparent : Colors.red
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
                width: 2.0,
                color: isErrorPassword == false
                    ? Colors.blue : Colors.red
            ),
          ),
          border: const OutlineInputBorder(),
          labelText: 'Password',
          labelStyle: const TextStyle(
              fontFamily: 'RobotoRegular',
              fontSize: 15),
          fillColor: Colors.green.withOpacity(0.5),
          filled: true,
        ),
        style: const TextStyle(
            fontSize: 15,
            fontFamily: 'RobotoRegular',
            color: Colors.black),
      ),
    );
  }

  Widget _rememberMeLayout() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Checkbox(
            focusNode: rememberMeFocusNode,
            value: _isRememberMe,
            activeColor: Colors.blue,
            onChanged: (bool? value) {
              setState(() {
                _isRememberMe = value!;
              });
            },
          ),
          Text(
            'Remember Me',
            style: TextStyle(
                fontFamily: 'RobotoRegular',
                color: _isRememberMe == true
                    ? Colors.blue : Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget loginButtonLayout() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      width: double.infinity,
      height: 50,
      child: RaisedButton(
        child: Text(
          'LOGIN',
          style: const TextStyle(
              fontFamily: 'RobotoBold',
              color: Colors.white),
        ),
        onPressed: _btnLogin,
        color: Colors.green,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        splashColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  Future<void> _btnLogin() async {
    // final bool emailValid = RegExp(
    //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //     .hasMatch(_emailController.text);

    helpers.checkInternetConnection().then((bool internet) async {
      if (internet != null && internet) {
        /// Internet Present Case
        if (_emailController.text == '' && _passwordController.text == '') {
          helpers.showToast('Please input mobile number and/or password');
          setState(() {
            isErrorEmailAdd = true;
            isErrorPassword = true;
          });
        }
        else if (_emailController.text == '') {
          helpers.showToast('Please input mobile number');
          setState(() {
            isErrorEmailAdd = true;
          });
        }
        // else if (!emailValid) {
        //   helpers.showToast('Please input a valid mobile number');
        //   setState(() {
        //     isErrorEmailAdd = true;
        //   });
        // }
        else if (_passwordController.text == '') {
          helpers.showToast('Please input password');
          setState(() {
            isErrorEmailAdd = false;
            isErrorPassword = true;
          });
        }
        else {
          /// LOGIN
          helpers.openLoadingDialogWithMessage(context, 'Logging in...');
          await loginPresentation.postLoginAPI(_emailController.text, _passwordController.text).then((res) async {
            Navigator.pop(context);
            final APIResult result = res;
            if (result.status == 'success') {
              String accessToken = result.result['accessToken'];
              setState(() {
                isErrorEmailAdd = false;
                isErrorPassword = false;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) =>
                          Screen1(accessToken: accessToken,)),
                );
              });
            } else {
              setState(() {
                isErrorEmailAdd = true;
                isErrorPassword = true;
              });
              helpers.showToast('You have entered an invalid mobile number and/or password.');
              // helpers.createSnackBar(dialogInvalidCredentials, scaffoldContext);
            }
          }, onError: (e) {
            Navigator.pop(context);
            print(e.toString());
            helpers.showToast('Something went wrong. Please try again.');
            // helpers.createSnackBar('', scaffoldContext);
          });
        }
      } else {
        /// No Internet Present Case
        helpers.createSnackBar('No internet connection.  Please connect online and try again.', scaffoldContext);
      }
    });
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus,
      FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  _onBackPressed() {
    print('On Back Pressed');
    setState(() {
      backPress = backPress + 1;
    });
    if (backPress > 1) {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    }
  }

}
