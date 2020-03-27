import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horsesapp/screens/allCustomersList.dart';
import 'package:horsesapp/screens/main.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{
  final _formKey = GlobalKey<FormState>();
  String username, password = "";


  @override
  Widget build(BuildContext context) {
     return Scaffold(
       resizeToAvoidBottomPadding: false,
       body: Container(
         height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xff498281),Color(0xff185555)]
//              colors: [Color(0xffffc79f),Color(0xffe09670)]
            )
          ),
           child: Padding(
             padding: const EdgeInsets.all(36.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 SizedBox(
                   height: 155.0,
                   child: Image.asset(
                       "assets/logo_horse.png",
                     fit: BoxFit.contain,
                   )
                 ),
                 _loginForm(),
               ],
             ),
           )),
     );
  }

  Widget _loginForm(){
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 35.0,
            ),
            _nameField(),
            SizedBox(
              height: 25.0,
            ),
            _passwordField(),
            SizedBox(
              height: 25.0,
            ),
            _loginBtn(),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _nameField(){
    return TextFormField(
      onChanged: (name){
        username= name;
      },
      style: TextStyle(
        color: Colors.white
      ),
      obscureText: false,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(32.0)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.circular(32.0)
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0,15.0),
        hintText: 'username',
        hintStyle: TextStyle(
          color: Colors.white
        ),
      ),
    );
  }

  Widget _passwordField(){
    return TextFormField(
      onChanged: (pass){
        password = pass;
      },
      style: TextStyle(
          color: Colors.white
      ),
      obscureText: false,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(32.0)
          ),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.circular(32.0)
        ),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0,15.0),
          hintText: 'password',
          hintStyle: TextStyle(
              color: Colors.white
          ),
      ),
    );
  }

  Widget _loginBtn(){
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff002c2c),
//      color: Color(0xffab6844),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0,15.0,20.0,15.0),
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.5,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ), onPressed: () {
          _submitForm();
      },
      ),
    );
  }

  void _submitForm(){
    if(username == "Admin123" && password == "Admin123"){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllCustomersList()
          )
      );
    } else(
    // ignore: unnecessary_statements
    print("zle meno a heslo")
    );
  }
}