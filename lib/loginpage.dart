import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/Homepageku.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginrespon.dart';

class loginpageku extends StatefulWidget {
  const loginpageku({Key key}) : super(key: key);

  @override
  _loginpagekuState createState() => _loginpagekuState();
}



class _loginpagekuState extends State<loginpageku> {
  bool isloading = false;

  TextEditingController txtemailcontroller = new TextEditingController();
  TextEditingController txtpasswordcontroller = new TextEditingController();



  TextFormField txtku(String title){
    return TextFormField(
      controller: txtemailcontroller,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      // initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        hintText: title,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }
  TextFormField txtkupass(String title){
    return TextFormField(
      controller: txtpasswordcontroller,
      keyboardType: TextInputType.visiblePassword,
      autofocus: false,
      obscureText: true,
      // initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        hintText: title,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: isloading ? Center(child: CircularProgressIndicator(),) :  ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            // logo,
            Container(
              margin: EdgeInsets.only(top: 50.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Text("Movie DB",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 48.0),
            txtku("Email"),
            SizedBox(height: 8.0),
            txtkupass("Password"),
            SizedBox(height: 24.0),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.lightBlueAccent.shade100,
                elevation: 5.0,
                child: MaterialButton(
                  minWidth: 200.0,
                  height: 42.0,
                  onPressed: () {
                    setState(() {
                      isloading = true;
                    });
                    signin(txtemailcontroller.text, txtpasswordcontroller.text,context);
                  },
                  color: Colors.lightBlueAccent,
                  child: Text('Log In', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            // forgotLabel
          ],
        ),
      ),
    );
  }

  signin(String email, String password, BuildContext context) async {
    final body = {
      "email": email,
      "password": password,
    };

    Map<String, String> headers = {
      'Content-type': 'application/json',
    };

    var bodys = json.encode(body);
    var responku = await http.post("http://tamlocalcenter-dev.ap-southeast-1.elasticbeanstalk.com/api/identity/token",headers: headers, body: bodys);
    print("body " + body.toString() + "--" + responku.body.toString());
    Loginrespon loginmodel = Loginrespon.fromJson(json.decode(responku.body));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (loginmodel.failed == false && loginmodel.succeeded == true) {

      setState(() {
        isloading = false;
        prefs.setString("username", loginmodel.data.userName);
        prefs.setString("email", loginmodel.data.email);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Myhomepage()));
      });

    } else{
      setState(() {
        isloading = false;
        print(responku.body);
      });
    }
  }
}
