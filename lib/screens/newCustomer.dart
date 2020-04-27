import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horsesapp/screens/allCustomersList.dart';
import 'package:horsesapp/screens/main.dart';

import '../database.dart';
import '../models/Customer.dart';

class NewCustomer extends StatefulWidget{

  @override
  _NewCustomerState createState() => _NewCustomerState();
}

class _NewCustomerState extends State<NewCustomer>{
  String name ="";
  String email = "";
  String password ="";
  DBProvider dbProvider= DBProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: 180,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color.fromRGBO(73, 130, 129, 1.0), Color.fromRGBO(0, 44, 44, 1.0)]
                )
            ),
          ),
          Positioned(
            top: 10,
            right: 0,
            left: 0,
            child: Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      "New Customer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: 90,
                      right: 20,
                      left: 20
                  ),
                  height: 300,
                  width: 400,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:  BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(25, 85, 85, .1),
                            blurRadius: 20,
                            spreadRadius: 10
                        )
                      ]
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                  'Customers name:',
                                  style: TextStyle(
                                      color: Color.fromRGBO(25, 85, 85, 1.0),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top:33.0, bottom: 33.0),
                                child: Text(
                                  'Customers email:',
                                  style: TextStyle(
                                      color: Color.fromRGBO(25, 85, 85, 1.0),
                                  ),
                                ),
                              ),
                              Text(
                                'Customers password:',
                                style: TextStyle(
                                    color: Color.fromRGBO(25, 85, 85, 1.0),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                child: TextFormField(
                                  onChanged: (nameVal){
                                    name = nameVal;
                                    print("new value of name $name");
                                  },
                                  controller: TextEditingController(
                                      text: "$name"
                                  ),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(bottom: -30)
                                  ),
                                ),
                                width: 140,
                              ),
                              Container(
                                child: TextFormField(
                                  onChanged: (emailVal){
                                    email = emailVal;
                                    print("new value of email $email");
                                  },
                                  controller: TextEditingController(
                                      text: "$email"
                                  ),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(bottom: -30)
                                  ),
                                ),
                                width: 140,
                              ),
                              Container(
                                child: TextFormField(
                                  onChanged: (passVal){
                                    password = passVal;
                                    print("new value of password $password");
                                  },
                                  controller: TextEditingController(
                                      text: "$password"
                                  ),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(bottom: -30)
                                  ),
                                ),
                                width: 140,
                              ),
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: 300,
                            child: Divider(
                              height: 1,
                              color: Color.fromRGBO(25, 85, 85, .3),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        _saveCustomer()
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _saveCustomer(){
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff002c2c),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width/ 3,
        padding: EdgeInsets.fromLTRB(10.0,5.0,10.0,5.0),
        child: Text(
          "Save",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18.5,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ), onPressed: () {
          Customer newCust = new Customer(name, email, password);
           Future<int> saved =_saveCustomerFun(newCust);
           saved.then(( int value) =>{
             if(value > 0){
               Navigator.pushNamedAndRemoveUntil(context, "/allCustomers", (_) => false),
               _showDialog("New Customer was successfully saved.")
             }else{
                _showDialog("New Customer was not saved.")
             }
           });
      },
      ),
    );
  }
  Future<int>  _saveCustomerFun(Customer customer) async{
    int result = await dbProvider.insertCustomer(customer);
    return result;
  }

  void _showDialog(String mess){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Text(
                mess,
              textAlign: TextAlign.center,
            ),
          );
        }
    );
  }

}