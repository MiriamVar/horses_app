import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horsesapp/database.dart';
import 'package:horsesapp/models/Customer.dart';
import 'package:horsesapp/screens/allCustomersList.dart';
import 'package:horsesapp/screens/customerProfile.dart';

class LoginPage extends StatefulWidget{

  static Customer currentUser;

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  DBProvider db = DBProvider();
  bool _isLoading = false;
  Future<List<Customer>> customers;
  List<Customer> customersList;

  Future<Customer> _loginUser(String name, String password) async {
    Customer user = await db.loginCustomer(name, password);
    if(user == null){
      print("z db mi nic nevratilo");
      return null;
    }
    else{
      return user;
    }
  }


  @override
  Widget build(BuildContext context) {
     return Scaffold(
       key: _formKey,
       resizeToAvoidBottomPadding: true,
       body: SingleChildScrollView(
         child: Container(
           height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xff498281),Color(0xff185555)]
              )
            ),
             child: Padding(
               padding: const EdgeInsets.all(36.0),
               child: Column(
                 mainAxisSize: MainAxisSize.max,
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
       ),
     );
  }

  Widget _loginForm(){
    return Center(
      child: _isLoading
      ? CircularProgressIndicator()
      : Column(
        mainAxisSize: MainAxisSize.min,
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
    );
  }
  
  Widget _nameField(){
    return Container(
      height: 50,
      child: TextFormField(
       controller: _nameController,
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
          hintText: 'name',
          hintStyle: TextStyle(
            color: Colors.white
          ),
        ),
      ),
    );
  }

  Widget _passwordField(){
    return Container(
      height: 50,
      child: TextFormField(
        controller: _passwordController,
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
        ), onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          Customer user = await _loginUser(_nameController.text, _passwordController.text);
          setState(() {
            _isLoading = false;
          });
          if(user != null){
            if(user.name == "Vet"){
              // user by mal byt Vet
              LoginPage.currentUser = user;
              Navigator.pushReplacementNamed(context, "/allCustomers");
            }else {
              // user by mal byt iny customer
              LoginPage.currentUser = user;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => CustomerProfile(customer: user,)
              )
              );
            }
          }else{
          _showDialog();
          }},
      ),
    );
  }

  void _showDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text(
                "Wrong name or password",
              textAlign: TextAlign.center,
            ),
          );
        }
    );
  }
}