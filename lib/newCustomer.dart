import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horsesapp/allCustomers.dart';
import 'package:horsesapp/main.dart';

class NewCustomer extends StatefulWidget{

  @override
  _NewCustomerState createState() => _NewCustomerState();
}

class _NewCustomerState extends State<NewCustomer>{

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
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              'Customers name:',
                              style: TextStyle(
                                  color: Color.fromRGBO(25, 85, 85, 1.0),
                                  fontSize: 15
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right:5.0),
                            child: TextFormField(
//                              onChanged: (payload){
//                                heightPayload =payload;
//                                print("new value of name $heightPayload");
//                              },
                              controller: TextEditingController(
                                  text: ""
                              ),
                            ),
                            width: 190,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              'Customers email:',
                              style: TextStyle(
                                  color: Color.fromRGBO(25, 85, 85, 1.0),
                                  fontSize: 15
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right:5.0),
                            child: TextFormField(
//                              onChanged: (payload){
//                                heightPayload =payload;
//                                print("new value of name $heightPayload");
//                              },
                              controller: TextEditingController(
                                  text: ""
                              ),
                            ),
                            width: 190,
                          ),
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
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Material(
                                    borderRadius: BorderRadius.all(Radius.circular(100)),
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(Radius.circular(100)),
                                      onTap: (){},
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child:  Tab(
                                          icon: new Image.asset("assets/icon_horse.png"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Horses",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  _addHorseBtn(),
                                ],
                              )
                            ],
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

  Widget _addHorseBtn(){
    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: RaisedButton(
        padding: EdgeInsets.all(0),
        color: Color.fromRGBO(25, 85,85, 1.0),
        textColor: Colors.white,
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(title: "Horses",)
              )
          );
        },
        child: Text("Add horse"),
      ),
    );
  }

  Widget _saveCustomer(){
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff002c2c),
//      color: Color(0xffab6844),
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
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllCustomers()
            )
        );
      },
      ),
    );
  }
}