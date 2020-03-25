import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horsesapp/customerProfile.dart';
import 'package:horsesapp/newCustomer.dart';

class AllCustomers extends StatefulWidget{

  @override
  _AllCustomersState createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(73,130, 129, 1.0),
//      backgroundColor: Color.fromRGBO(255, 199, 159, 1.0),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(73,130, 129, 1.0),
//        backgroundColor: Color.fromRGBO(255, 199, 159, 1.0) ,
        centerTitle: true,
        title: Text(
          "Customers",
          style: TextStyle(
              color: Color.fromRGBO(0, 44, 44, 1.0),
//            color:  Color.fromRGBO(171, 104, 68, 1.0),
            fontWeight: FontWeight.bold,
            fontSize: 22.0
          ),
        ),
      ),
      body: Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (context, index){
              return Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.0),
                    color: Colors.white
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0
                    ),
                    leading: Container(
                      padding: EdgeInsets.only(
                        right: 12.0
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                            width: 1.0,
                            color: Colors.white24
                          )
                        )
                      ),
                      child: Icon(
                        Icons.person,
                        color: Color.fromRGBO(0, 44, 44, 1.0),
//                        color: Color.fromRGBO(171, 104, 68, 1.0)
                      ),
                    ),
                    title: Text(
                      "Vet ${index+1}",
                      style: TextStyle(
                          color: Color.fromRGBO(0, 44, 44, 1.0),
//                        color: Color.fromRGBO(171, 104, 68, 1.0),
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_right,
                      color: Color.fromRGBO(0, 44, 44, 1.0),
//                      color: Color.fromRGBO(171, 104, 68, 1.0),
                      size: 30.0,
                    ),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomerProfile()
                          )
                      );
                    },
                  ),
                  ),
                ),
              );
            }
        ),
      ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(238, 237, 9, 1.0),
//          backgroundColor: Color.fromRGBO(255, 199, 159, 1.0),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewCustomer()
                )
            );
          },
          child: Icon(
              Icons.add,
            color: Color.fromRGBO(0, 44, 44, 1.0),
//            color: Color.fromRGBO(171, 104, 68, 1.0),
          ),
        ),
//      bottomNavigationBar: Container(
//        height: 55.0,
//        child: BottomAppBar(
//          color: Color.fromRGBO(224, 150, 112, 1.0),
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              IconButton(
//                icon: Icon(Icons.home, color: Colors.white),
//                onPressed: () {},
//              )
//            ],
//          ),
//        ),
//      ),
    );
  }
}