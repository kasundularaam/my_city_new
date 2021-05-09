import 'package:flutter/material.dart';
import 'package:my_city/src/models/user_modal.dart';
import 'package:my_city/src/pages/signup.dart';
import 'package:my_city/src/screens/main_screen.dart';
import 'package:my_city/src/socpe%20model/user_model.dart';
import 'package:my_city/src/widgets/custom_alert.dart';
import 'package:my_city/src/widgets/custom_loading.dart';
import 'package:my_city/src/widgets/page_background.dart';
import 'package:my_city/src/widgets/page_title.dart';
import 'package:my_city/src/widgets/round_button.dart';
import '../widgets/input_field.dart';

class LogScreen extends StatefulWidget {
  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  BuildContext showLoadingDialogContext;
  UserModel _userModel = UserModel();
  User _loginUser = User();

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
      List<User> userList = await _userModel.getUserByNIC(_loginNIC);

      if (userList.isNotEmpty) {
        CustomLoading.closeLoading(context: context);
        _loginUser = userList[0];

        if (_loginUser != null) {
          if (_loginUser.Password == _loginPassword) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MainScreen(
                  currentUser: _loginUser,
                ),
              ),
            );
          } else {
            CustomLoading.closeLoading(context: context);
            CustomAlert.alertDialogBuilder(
              context: context,
              title: "Error",
              message: "wrong Password please try again..!",
              action: "Ok",
            );
          }
        }
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
      print("error: $e");
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
                      Navigator.of(context).pushReplacement(
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
