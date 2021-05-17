import 'package:flutter/material.dart';
import 'package:my_city/src/pages/signup.dart';
import 'package:my_city/src/screens/landing_screen.dart';
import 'package:my_city/src/services/user_service.dart';
import 'package:my_city/src/widgets/custom_alert.dart';
import 'package:my_city/src/widgets/custom_loading.dart';
import 'package:my_city/src/widgets/page_background.dart';
import 'package:my_city/src/widgets/page_title.dart';
import 'package:my_city/src/widgets/round_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/input_field.dart';

class LogScreen extends StatefulWidget {
  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  BuildContext showLoadingDialogContext;
  UserService _userService = UserService();

  String _loginNIC = "";
  String _loginPassword = "";

  FocusNode _passwordFocusNode;

  void _submitForm() async {
    if (_loginNIC != "" && _loginPassword != "") {
      CustomLoading.showLoadingDialog(
        context: context,
        message: "Loging...",
      );
      await _loginAccount();
    } else {
      CustomAlert.alertDialogBuilder(
        context: context,
        title: "Error",
        message: "Some input fields are empty..!",
        action: "Ok",
      );
    }
  }

  Future _loginAccount() async {
    try {
      String userId = await _userService.loginUser(_loginNIC, _loginPassword);

      if (userId != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("uid", userId);
        prefs.setBool("access", true);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => LandingScreen(),
          ),
          (route) => false,
        );
      } else {
        CustomLoading.closeLoading(context: context);
        CustomAlert.alertDialogBuilder(
          context: context,
          title: "Error",
          message: "wrong NIC please try again..!",
          action: "Ok",
        );
      }
    } catch (e) {
      CustomAlert.alertDialogBuilder(
        context: context,
        title: "Error",
        message: "$e",
        action: "Ok",
      );
    }
  }

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: Stack(
        children: [
          PageBackground(
              height: MediaQuery.of(context).size.height / 3.2,
              width: MediaQuery.of(context).size.width),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.2,
              ),
              PageTitle(title: "Hello there, \nwelcome back", fontSize: 36.0),
              SizedBox(
                height: 40,
              ),
              MyInputField(
                fontSize: 20.0,
                hintText: "NIC...",
                onChanged: (value) {
                  _loginNIC = value;
                },
                onSubmitted: (value) {
                  _passwordFocusNode.requestFocus();
                },
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 20.0,
              ),
              MyInputField(
                fontSize: 20.0,
                hintText: "Password...",
                onChanged: (value) {
                  _loginPassword = value;
                },
                isPassword: true,
                focusNode: _passwordFocusNode,
                onSubmitted: (value) {
                  _submitForm();
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              RoundButton(
                  text: "Login",
                  onPressed: () {
                    _submitForm();
                  }),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        "Create a new account",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
