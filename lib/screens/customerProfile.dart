import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:horsesapp/database.dart';
import 'package:horsesapp/models/Horse.dart';
import 'package:horsesapp/screens/FindHorse.dart';
import 'package:horsesapp/screens/HorseInfo.dart';
import 'package:horsesapp/screens/allCustomersList.dart';
import 'package:horsesapp/screens/login.dart';
import 'package:horsesapp/screens/main.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:sqflite/sqflite.dart';


import '../models/Customer.dart';

class CustomerProfile extends StatefulWidget{

  CustomerProfile({Key key, @required this.customer}) : super(key: key);

  final Customer customer;

  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile>{
  DBProvider dbProvider= DBProvider();
  List<Horse> myHorses;
  int count = 0;
  StreamSubscription<NDEFMessage> _streamSubscription;
  bool _supportsNFC = false;
  List<NDEFMessage> _tags = [];
  int index2 = 0;
  int index3  = 0;
  bool connected=false;

  String chipNumberPayload, RFIDPayload, IDPayload, namePayload, commonNamePayload, sirPayload, damPayload, sexPayload, breedPayload, colourPayload, dobPayload, descriptionPayload;
  int tapeMeasurePayload, stickMeasurePayload, breastGirthPayload, weightPayload, numberPayload, yobPayload;
  double cannonGirthPayload;
  String ownerPayload;

  @override
  Widget build(BuildContext context) {
    if(myHorses == null){
      myHorses= List<Horse>();
      print(widget.customer.name);
      updateListView(widget.customer.id);
    }
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
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Padding(
//                   padding: EdgeInsets.only(top: 40),
//                   child: Text(
//                     "Profile",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
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
                 height: 500,
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
                 child: SingleChildScrollView(
                   child: Column(
                     mainAxisSize: MainAxisSize.max,
                     children: <Widget>[
                       SizedBox(
                         height: 20,
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: <Widget>[
                           if(LoginPage.currentUser.name == "Vet")IconButton(
                             icon: Icon(Icons.arrow_back),
                             color: Color.fromRGBO(25, 85, 85, 1.0),
                             iconSize: 20.0,
                             onPressed: () {
                               Navigator.pushNamedAndRemoveUntil(context, "/allCustomers", (_) => false);
                             },
                           ),
                           if(LoginPage.currentUser.name == "Vet")Padding(
                             padding: const EdgeInsets.only(left: 80.0),
                             child: Text(
                               '${widget.customer.name}',
                               style: TextStyle(
                                   color: Color.fromRGBO(25, 85, 85, 1.0),
                                   fontSize: 20
                               ),
                             ),
                           ),
                           if(LoginPage.currentUser.name == "Vet")IconButton(
                             padding: EdgeInsets.only(left: 85.0, right: 20.0),
                             icon: Icon(Icons.power_settings_new),
                             color: Color.fromRGBO(25, 85, 85, 1.0),
                             iconSize: 20.0,
                             onPressed: () {
                               LoginPage.currentUser == null;
                               Navigator.pushReplacementNamed(context, "/logout");
                             },
                           ),
                           if(LoginPage.currentUser.name != "Vet")Padding(
                             padding: const EdgeInsets.only(left: 120.0),
                             child: Text(
                               '${widget.customer.name}',
                               style: TextStyle(
                                   color: Color.fromRGBO(25, 85, 85, 1.0),
                                   fontSize: 20
                               ),
                             ),
                           ),
                           if(LoginPage.currentUser.name != "Vet")IconButton(
                             padding: EdgeInsets.only(left: 85.0, right: 20.0),
                             icon: Icon(Icons.power_settings_new),
                             color: Color.fromRGBO(25, 85, 85, 1.0),
                             iconSize: 20.0,
                             onPressed: () {
                               Navigator.pushReplacementNamed(context, "/logout");
                             },
                           ),
                         ],
                       ),
                       Container(
                         margin: EdgeInsets.only(top: 30),
                         padding: EdgeInsets.only(left: 20, right: 20, top: 8),
                         width: 320,
                         height: 65,
                         decoration: BoxDecoration(
                             color: Colors.white,
                             boxShadow: [
                               BoxShadow(
                                   color: Colors.black.withOpacity(.1),
                                   blurRadius: 30,
                                   spreadRadius: 5)
                             ],
                             borderRadius: BorderRadius.circular(10)),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: <Widget>[
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: <Widget>[
                                     Text(
                                       'email',
                                       style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 18,
                                       ),
                                     ),
                                     SizedBox(
                                       height: 3,
                                     ),
                                     Text(
                                       '${widget.customer.email}',
                                       style: TextStyle(
                                         color: Color.fromRGBO(73, 130, 129, 1.0)
                                       ),
                                     )
                                   ],
                                 ),
                               ],
                             ),
                           ],
                         ) ,
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
                            _findYourHorse(),
                           SizedBox(
                             height: 10,
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
                                    if(LoginPage.currentUser.name == "Vet") _addHorseBtn(),
                                 ],
                               )
                             ],
                           ),
                           OfflineBuilder(
                               connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child) {
                                 connected = connectivity != ConnectivityResult.none;
                                 if(connected){
                                   return Column(
                                     children: <Widget>[
                                       Container(
                                         width: 350,
                                         child: ListView.builder(
                                             scrollDirection: Axis.vertical,
                                             shrinkWrap: true,
                                             itemCount: count,
                                             itemBuilder: (context, index){
                                               index3= index;
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
                                                       color: Color.fromRGBO(73, 130, 129, .2),
                                                     ),
                                                     child: ListTile(
                                                       contentPadding: EdgeInsets.symmetric(
                                                           horizontal: 20.0,
                                                           vertical: 3.0
                                                       ),
                                                       title: Text(
                                                         "${myHorses[index].name}",
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
                                                           Navigator.push(
                                                               context,
                                                               MaterialPageRoute(
                                                                   builder: (context) => HorseInfo(customer: widget.customer, horsik: myHorses[index])
                                                               )
                                                           );
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
                                                         _deleteHorse(myHorses[index3].id);
                                                         print("horse was deleted");
                                                         updateListView(widget.customer.id);
                                                       },
                                                     ),
                                                   ],
                                                 ),
                                               );
                                             }
                                         ),
                                       ),
                                     ],
                                   );
                                 }
                                 else{
                                   return Container();
                                 }
                               },
                               builder: (context){
                                 return Container();
                               }
                           ),
                           SizedBox(
                             width: 14,
                           )
                         ],
                       )
                     ],
                   ),
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

  Widget _findYourHorse(){
    return Container(
      padding: EdgeInsets.only(right:  10.0),
      child: RaisedButton(
          padding: EdgeInsets.only(right: 10.0, left: 10.0),
          color: Color.fromRGBO(25, 85,85, 1.0),
          textColor: Colors.white,
          child: Text("Scan your horse"),
          onPressed: (){
            _findScannig(context);
          }
      ),
    );
  }

  Widget _addHorseBtn(){
    return OfflineBuilder(
        connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child) {
          connected = connectivity != ConnectivityResult.none;
          if (connected) {
            return Container(
              padding: EdgeInsets.only(right: 10.0),
              child: RaisedButton(
                padding: EdgeInsets.all(0),
                color: Color.fromRGBO(25, 85, 85, 1.0),
                textColor: Colors.white,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Container(
                            height: 140,
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    "For adding new horse scan a tag first.",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                    height: 100,
                                    child: Image.asset("assets/mircochip.jpg")
                                )
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text("Ok"),
                              onPressed: () {
                                _startScannig(context);
                              },
                            ),
                            new FlatButton(
                              child: new Text("Close"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      }
                  );
                },
                child: Text("Add horse"),
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.only(right: 10.0),
              child: Column(
                children: <Widget>[
                  Text("You are in offline mode"),
                  RaisedButton(
                    padding: EdgeInsets.all(0),
                    color: Color.fromRGBO(25, 85, 85, 1.0),
                    textColor: Colors.white,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Container(
                                height: 140,
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        "For adding new horse scan a tag first.",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                        height: 100,
                                        child: Image.asset("assets/mircochip.jpg")
                                    )
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text("Ok"),
                                  onPressed: () {
                                    _startScannig(context);
                                  },
                                ),
                                new FlatButton(
                                  child: new Text("Close"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          }
                      );
                    },
                    child: Text("Add horse"),
                  ),
                ],
              ),
            );
          }
        },
      builder: (context){
        return Container();
      },
    );
  }

  void updateListView(int idC) {
    final Future<Database> dbFuture = dbProvider.initDB();
    dbFuture.then((database){
      Future<List<Horse>> horsesListFuture = dbProvider.getMyHorsesList(idC);List();
      horsesListFuture.then((myHorses){
        setState(() {
          this.myHorses = myHorses;
          this.count = myHorses.length;
        });
      });
    });
  }

  void _startScannig(BuildContext context){
    try{
      // ignore: cancel_subscriptions
      StreamSubscription<NDEFMessage> subscription = NFC.readNDEF().listen(
              (tag){
            setState(() {
              _tags.insert(0,tag);
              print(tag);
              print("Record '${_tags[index2].records[0].id ?? "[NO ID]"}' with  TNF '${_tags[index2].records[0].tnf}, type '${_tags[index2].records[0].type}', payload '${_tags[index2].records[0].payload}' and data '${_tags[index2].records[0].data}' and language code '${_tags[index2].records[0].languageCode}''");

              //nacitavam iba ID chipu
              var record1 = jsonDecode(_tags[index2].records[0].payload);
              chipNumberPayload = record1["Chip number"];
              IDPayload = record1["ID number"];
              RFIDPayload = record1["RFID number"];
              print(chipNumberPayload);

              if(chipNumberPayload == null){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomerProfile(customer: widget.customer,)
                    )
                );
                _showDialog("Wrong chip");
              }
              if(chipNumberPayload != null && IDPayload == null && RFIDPayload == null){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(customer: widget.customer, tagID:  chipNumberPayload,)
                    )
                );
              } else{
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomerProfile(customer: widget.customer,)
                    )
                );
                _showDialog("You can't use this implant. On this implant is information saved.");
              }

            });
          },
          onDone: (){
            setState(() {
              _streamSubscription = null;
            });
          },
          onError: (exp){
            setState(() {
              _streamSubscription = null;
            });
          });
      setState(() {
        _streamSubscription = subscription;
      });
    }
    catch (error){
      print("error: $error");
    }
  }

  void _findScannig(BuildContext contextik){
    try{
      // ignore: cancel_subscriptions
      StreamSubscription<NDEFMessage> subscription = NFC.readNDEF().listen(
              (tag){
            setState(() {
              _tags.insert(0,tag);
              print(tag);
              print("Record '${_tags[index2].records[0].id ?? "[NO ID]"}' with  TNF '${_tags[index2].records[0].tnf}, type '${_tags[index2].records[0].type}', payload '${_tags[index2].records[0].payload}' and data '${_tags[index2].records[0].data}' and language code '${_tags[index2].records[0].languageCode}''");
              print("Record '${_tags[index2].records[1].id ?? "[NO ID]"}' with  TNF '${_tags[index2].records[1].tnf}, type '${_tags[index2].records[1].type}', payload '${_tags[index2].records[1].payload}' and data '${_tags[index2].records[1].data}' and language code '${_tags[index2].records[1].languageCode}''");
              print("Record '${_tags[index2].records[2].id ?? "[NO ID]"}' with  TNF '${_tags[index2].records[2].tnf}, type '${_tags[index2].records[2].type}', payload '${_tags[index2].records[2].payload}' and data '${_tags[index2].records[2].data}' and language code '${_tags[index2].records[2].languageCode}''");
              print("Record '${_tags[index2].records[3].id ?? "[NO ID]"}' with  TNF '${_tags[index2].records[3].tnf}, type '${_tags[index2].records[3].type}', payload '${_tags[index2].records[3].payload}' and data '${_tags[index2].records[3].data}' and language code '${_tags[index2].records[3].languageCode}''");
              print("Record '${_tags[index2].records[4].id ?? "[NO ID]"}' with  TNF '${_tags[index2].records[4].tnf}, type '${_tags[index2].records[4].type}', payload '${_tags[index2].records[4].payload}' and data '${_tags[index2].records[4].data}' and language code '${_tags[index2].records[4].languageCode}''");
              print("Record '${_tags[index2].records[5].id ?? "[NO ID]"}' with  TNF '${_tags[index2].records[5].tnf}, type '${_tags[index2].records[5].type}', payload '${_tags[index2].records[5].payload}' and data '${_tags[index2].records[5].data}' and language code '${_tags[index2].records[5].languageCode}''");

              var record1 = jsonDecode(_tags[index2].records[0].payload);
              var record2 = jsonDecode(_tags[index2].records[1].payload);
              var record3 = jsonDecode(_tags[index2].records[2].payload);
              var record4 = jsonDecode(_tags[index2].records[3].payload);
              var record5 = jsonDecode(_tags[index2].records[4].payload);
              var record6 = jsonDecode(_tags[index2].records[5].payload);

              chipNumberPayload = record1["Chip number"];
              print(chipNumberPayload);
              IDPayload = record1["ID number"];
              RFIDPayload = record1["RFID number"];

              if(record2["Number"] == null){
                numberPayload = 0;
              }else{
                numberPayload = int.parse(record2["Number"]);
              }

              namePayload = record2["Name"];
              commonNamePayload = record2["Common name"];
              dobPayload = record2["Day of birth"];
              if(record2["Year of birth"] == "null"){
                yobPayload = 0;
              }else{
                yobPayload = int.parse(record2["Year of birth"]);
              }


              sirPayload = record3["Sir"];
              damPayload = record3["Dam"];

              sexPayload = record4["Sex"];
              breedPayload = record4["Breed"];
              colourPayload = record4["Colour"];
              descriptionPayload = record4["Description"];

              if(record5["Tape measure"] == null){
                tapeMeasurePayload = 0;
              }else{
                tapeMeasurePayload = int.parse(record5["Tape measure"]);
              }

              if(record5["Stick measure"] == null){
                stickMeasurePayload= 0;
              } else{
                stickMeasurePayload = int.parse(record5["Stick measure"]);
              }

              if(record5["Breast girth"] == null){
                breastGirthPayload = 0;
              } else{
                breastGirthPayload = int.parse(record5["Breast girth"]);
              }

              if(record5["Cannon girth"] == null){
                cannonGirthPayload = 0;
              } else{
                cannonGirthPayload = double.parse(record5["Cannon girth"]);
              }

              if(record5["Weight"] == null){
                weightPayload = 0;
              } else{
                weightPayload = int.parse(record5["Weight"]);
              }

              ownerPayload = record6["Owner"];

              Horse horseFromTag = new Horse(widget.customer.id, chipNumberPayload, IDPayload, namePayload, commonNamePayload, sirPayload, damPayload, sexPayload, breedPayload, colourPayload, dobPayload, descriptionPayload, tapeMeasurePayload, stickMeasurePayload, breastGirthPayload, weightPayload, numberPayload, yobPayload, cannonGirthPayload, RFIDPayload, ownerPayload);

              if(chipNumberPayload == null){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomerProfile(customer: widget.customer,)
                    )
                );
                _showDialog("Wrong chip");
              }else{
                List<Horse> horses = myHorses.where((chip) => chip.chipNumber == chipNumberPayload).toList();

                if(horses.isNotEmpty){
                  Horse horse = horses[0];
                  print(horse.name);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FindHorse(customer: widget.customer, horseTAG: horseFromTag, horseDB: horse,)
                    )
                );
                } else{
                  _showDialog("You don't own this horse");
                  print("nemam horsa z db");
                }
              }
            });
          },
          onDone: (){
            setState(() {
              _streamSubscription = null;
            });
          },
          onError: (exp){
            setState(() {
              _streamSubscription = null;
            });
          });
      setState(() {
        _streamSubscription = subscription;
      });
    }
    catch (error){
      print("error: $error");
    }
  }

  void _deleteHorse(int idH) async{
    await dbProvider.deleteHorse(idH);
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

  void _navigateToLogin(){
    print("tlacim");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()
        )
    );
  }

}