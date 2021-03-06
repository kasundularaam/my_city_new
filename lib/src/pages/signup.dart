import 'package:flutter/material.dart';
import 'package:my_city/src/models/user_modal.dart';
import 'package:my_city/src/screens/landing_screen.dart';
import 'package:my_city/src/services/user_service.dart';
import 'package:my_city/src/widgets/custom_alert.dart';
import 'package:my_city/src/widgets/custom_loading.dart';
import 'package:my_city/src/widgets/page_background.dart';
import 'package:my_city/src/widgets/page_title.dart';
import 'package:my_city/src/widgets/round_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/input_field.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  BuildContext showLoadingDialogContext;
  UserService _userService = UserService();
  User _user = User();

  String _signinName = "";
  String _signinNIC = "";
  int _signinPostalCode = 0;
  String _signinAdminArea = "Kottawa";
  String _signinPassword = "";

  FocusNode _nicFocusNode;
  FocusNode _postalCodeFocusNode;
  FocusNode _passwordFocusNode;

  void _submitForm() async {
    if (_signinNIC != "" &&
        _signinName != "" &&
        _signinPostalCode != "" &&
        _signinPassword != "") {
      CustomLoading.showLoadingDialog(
        context: context,
        message: "Signing...",
      );
      await _createNewAccount();
    } else {
      CustomAlert.alertDialogBuilder(
        context: context,
        title: "Error",
        message: "Some fields are empty!..",
        action: "Ok",
      );
    }
  }

  Future _createNewAccount() async {
    _user = User(
      name: _signinName,
      nic: _signinNIC,
      password: _signinPassword,
      area: _signinAdminArea,
      postalCode: _signinPostalCode,
    );

    try {
      String userId = await _userService.signUpUser(_user);
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
          message: "something went wrong",
          action: "Ok",
        );
      }
    } catch (e) {
      CustomLoading.closeLoading(context: context);
      CustomAlert.alertDialogBuilder(
        context: context,
        title: "Error",
        message: "error code: $e",
        action: "Ok",
      );
    }
  }

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    _nicFocusNode = FocusNode();
    _postalCodeFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _nicFocusNode.dispose();
    _postalCodeFocusNode.dispose();
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
            width: MediaQuery.of(context).size.height,
          ),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.2,
              ),
              PageTitle(title: "Hello there,\nwelcome back", fontSize: 36.0),
              SizedBox(
                height: 40,
              ),
              MyInputField(
                fontSize: 20.0,
                hintText: "Name...",
                onChanged: (value) {
                  _signinName = value;
                },
                onSubmitted: (value) {
                  _nicFocusNode.requestFocus();
                },
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 20,
              ),
              MyInputField(
                fontSize: 20.0,
                hintText: "NIC...",
                onChanged: (value) {
                  _signinNIC = value;
                },
                focusNode: _nicFocusNode,
                onSubmitted: (value) {
                  _postalCodeFocusNode.requestFocus();
                },
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 20,
              ),
              MyInputField(
                fontSize: 20.0,
                hintText: "Postal Code...",
                onChanged: (value) {
                  _signinPostalCode = int.parse(value);
                },
                focusNode: _postalCodeFocusNode,
                onSubmitted: (value) {
                  _passwordFocusNode.requestFocus();
                },
                textInputAction: TextInputAction.next,
              ),
              SizedBox(
                height: 20,
              ),
              MyInputField(
                isPassword: true,
                fontSize: 20.0,
                hintText: "Password...",
                onChanged: (value) {
                  _signinPassword = value;
                },
                focusNode: _passwordFocusNode,
                onSubmitted: (value) {
                  _submitForm();
                },
                textInputAction: TextInputAction.done,
              ),
              SizedBox(
                height: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Admin area",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 18.0),
                        ),
                        DropdownButton(
                          value: _signinAdminArea,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 20.0),
                          dropdownColor: Colors.white,
                          items: <DropdownMenuItem<String>>[
                            new DropdownMenuItem(
                              child: new Text('Kottawa'),
                              value: "Kottawa",
                            ),
                            new DropdownMenuItem(
                              child: new Text('Homagama'),
                              value: "Homagama",
                            ),
                            new DropdownMenuItem(
                              child: new Text('Maharagama'),
                              value: "Maharagama",
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _signinAdminArea = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              RoundButton(
                  text: "Create Account",
                  onPressed: () {
                    _submitForm();
                  }),
              SizedBox(
                height: 20.0,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
