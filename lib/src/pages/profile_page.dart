import 'package:flutter/material.dart';
import 'package:my_city/src/models/user_modal.dart';
import 'package:my_city/src/pages/login.dart';
import 'package:my_city/src/socpe%20model/user_model.dart';
import 'package:my_city/src/widgets/page_title.dart';
import 'package:my_city/src/widgets/text_list_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel _userModel = UserModel();
  String _userId;
  getUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString("uid");
  }

  @override
  Widget build(BuildContext context) {
    getUid();
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(height: 50),
          PageTitle(title: "Profile", fontSize: 38),
          SizedBox(
            height: 20.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(65),
                      child: Container(
                        color: Colors.white,
                        width: 110,
                        height: 110,
                      ),
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          "https://images.pexels.com/photos/2078265/pexels-photo-2078265.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              FutureBuilder(
                future: _userModel.getUserById(_userId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "${snapshot.error}",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    User user = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          user.Name,
                          style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          user.NIC,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          FutureBuilder(
            future: _userModel.getUserById(_userId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  "${snapshot.error}",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ));
              }
              if (snapshot.hasData) {
                User user = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Personal info",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextListTile(
                              title: "Name",
                              subTitle: user.Name,
                            ),
                            Divider(
                              height: 15.0,
                              color: Colors.purple,
                            ),
                            TextListTile(
                              title: "NIC",
                              subTitle: user.NIC,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "Area info",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextListTile(
                              title: "Admin Area",
                              subTitle: user.AdminArea,
                            ),
                            Divider(
                              height: 15.0,
                              color: Colors.purple,
                            ),
                            TextListTile(
                              title: "Postal Code",
                              subTitle: "${user.PostalCode}",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
          SizedBox(
            height: 30.0,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LogScreen()));
                print("loged out");
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "log out",
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}
