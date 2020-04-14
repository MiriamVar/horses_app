import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:horsesapp/database.dart';
import 'package:horsesapp/models/Horse.dart';
import 'package:horsesapp/screens/HorseInfo.dart';
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
  String chipNumberPayload = "";
  int index3  = 0;

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
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Padding(
                   padding: EdgeInsets.only(top: 40),
                   child: Text(
                     "Profile",
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
                       Text(
                         '${widget.customer.name}',
                         style: TextStyle(
                           color: Color.fromRGBO(25, 85, 85, 1.0),
                           fontSize: 20
                         ),
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
                                   _addHorseBtn(),
                                 ],
                               )
                             ],
                           ),
                           Slidable(
                             actionPane: SlidableDrawerActionPane(),
                             actionExtentRatio: 0.25,
                             child: Column(
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
                                         );
                                       }
                                   ),
                                 ),
                               ],
                             ),
                             secondaryActions: <Widget>[
                               IconSlideAction(
                                 caption: 'Delete',
                                 color: Colors.red,
                                 icon: Icons.delete,
                                 onTap: () {
                                   _deleteHorse(myHorses[index3].id);
                                   SnackBar(
                                     content: Text("Horse was deleted"),
                                   );
                                 },
                               ),
                             ],
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
            // todo ... function to horse Info page with exactly horse
            // todo ... scan function
            // todo ... by tagID find out the horse
            // todo ... open Horse info with horse (info from db)
          }
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
          showDialog(
              context: context,
            builder: (BuildContext context){
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
              String idTag = _tags[index2].records[0].data;
              chipNumberPayload = idTag.substring(idTag.indexOf(RegExp(r'(?<=:)')));
              print("printim upravene chipNumber");
              print(chipNumberPayload);

              if(chipNumberPayload == null){
                  //todo .... if on tag is not ID of tag
              }else{
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(customer: widget.customer, tagID:  chipNumberPayload,)
                    )
                );
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
}