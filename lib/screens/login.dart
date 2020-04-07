import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horsesapp/database.dart';
import 'package:horsesapp/models/Customer.dart';
import 'package:horsesapp/screens/allCustomersList.dart';
import 'package:horsesapp/screens/customerProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{
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

//  firstTime() async{
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    bool firstTime = prefs.getBool('first_time');
//
//    if (firstTime != null && !firstTime) {// Not first time
//      print("db by mala byt plna");
//    } else {// First time
//      prefs.setBool('first_time', false);
//      _fillDB();
//    }
//  }



//  void _fillDB(){
//    Customer vet1 = new Customer("Jano", "jano@vet.com", "jano123");
//    Customer customer1 = new Customer("Kubo", "kubo@gmail.com.com", "kubo123");
//    Customer customer2 = new Customer("Miro", "miro@gmail.com", "miro123");
//
//    db.insertCustomer(vet1);
//    db.insertCustomer(customer1);
//    db.insertCustomer(customer2);
//  }

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


//  @override
//  void initState() {
//    super.initState();
//    firstTime();
//  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       key: _formKey,
       resizeToAvoidBottomPadding: false,
       body: Container(
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
    return Center(
      child: _isLoading
      ? CircularProgressIndicator()
      : SingleChildScrollView(
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
    );
  }

  Widget _passwordField(){
    return TextFormField(
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
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AllCustomersList()));
            // ignore: unrelated_type_equality_checks
//            if(user.name.compareTo("Jano") == true){
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (BuildContext context) => AllCustomersList()
//              ));
//            }else {
//              Navigator.of(context).push(MaterialPageRoute(
//                  builder: (BuildContext context) => CustomerProfile(customer: user,)
//              )
//              );
//            }
          }else{
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Wrong email or password"),
              )
            );
          }},
      ),
    );
  }
}