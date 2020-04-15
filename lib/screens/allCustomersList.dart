import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horsesapp/database.dart';
import 'package:sqflite/sqflite.dart';
import '../models/Customer.dart';
import 'customerProfile.dart';
import 'newCustomer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AllCustomersList extends StatefulWidget{

  @override
  _AllCustomersListState createState() => _AllCustomersListState();
}

class _AllCustomersListState extends State<AllCustomersList>{
  DBProvider dbProvider= DBProvider();
  List<Customer> customersList;
  int count = 0;
  int index2 = 0;

  @override
  Widget build(BuildContext context) {
    if(customersList == null){
      customersList = List<Customer>();
      updateListView();
    }
    return Scaffold(
      backgroundColor: Color.fromRGBO(73,130, 129, 1.0),
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(73,130, 129, 1.0),
        centerTitle: true,
        title: Text(
          "Customers",
          style: TextStyle(
              color: Color.fromRGBO(0, 44, 44, 1.0),
            fontWeight: FontWeight.bold,
            fontSize: 22.0
          ),
        ),
      ),
      body: Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: count,
            itemBuilder: (context, index){
            index2 = index;
              return Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 6.0),
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
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
                        ),
                      ),
                      title: Text(
                        "${this.customersList[index].name}",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 44, 44, 1.0),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_right,
                        color: Color.fromRGBO(0, 44, 44, 1.0),
                        size: 30.0,
                      ),
                      onPressed: (){
                       navigateToProfile(this.customersList[index]);
                      },
                    ),
                    ),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        _deleteCustomer(this.customersList[index2].id);
                        print("mazem customera");
                        updateListView();
                      },
                    ),
                  ],
                ),
              );
            }
        ),
      ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(238, 237, 9, 1.0),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewCustomer()
                )
            );
            updateListView();
          },
          child: Icon(
              Icons.add,
            color: Color.fromRGBO(0, 44, 44, 1.0),
          ),
        ),
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = dbProvider.initDB();
    dbFuture.then((database){
      Future<List<Customer>> customersListFuture = dbProvider.getCustomersList();
      customersListFuture.then((customersList){
        setState(() {
          this.customersList = customersList;
          this.count = customersList.length;
        });
      });
    });
  }

  void navigateToProfile(Customer customerko) async{
    print(customerko.id);
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CustomerProfile(customer: customerko);
    }));
//    if(result == true){
//      updateListView();
//    }
  }

  void _deleteCustomer(int idC) async{
    await dbProvider.deleteCustomer(idC);
  }
}

