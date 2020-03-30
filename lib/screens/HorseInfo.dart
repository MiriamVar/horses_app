import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horsesapp/database.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:sqflite/sqflite.dart';
import '../models/Horse.dart';


class HorseInfo extends StatefulWidget {

  @override
  _HorseInfoState createState() => _HorseInfoState();
}

class _HorseInfoState extends State<HorseInfo> {
  List<Horse> horses;
  Horse horse1;
  List<Horse> selectedHorse;
  bool sort;
  String num, yob, tape, stick, breast, cannon, wei;
  DBProvider dbProvider = DBProvider();
  int count;
  StreamSubscription<NDEFMessage> _streamSubscription;
  bool _supportsNFC = false;
  List<NDEFMessage> _tags = [];
  int index2 = 0;

  String chipNumberPayload, IDPayload, namePayload, commonNamePayload, sirPayload, damPayload, sexPayload, breedPayload, colourPayload, dobPayload, descriptionPayload;
  int tapeMeasurePayload, stickMeasurePayload, breastGirthPayload, weightPayload, numberPayload, yobPayload;
  double cannonGirthPayload;

  String UID_tag= "";



  @override
  void initState() {
    sort = false;
    selectedHorse = [];
    super.initState();
    NFC.isNDEFSupported.then((supported) {
      setState(() {
        _supportsNFC = true;
      });
    });
  }

  onSelected(bool selected, Horse horse) async{
    setState(() {
      if(selected){
        selectedHorse.add(horse);
      } else{
        selectedHorse.remove(horse);
      }
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
//              print("Record '${_tags[index2].records[1].id ?? "[NO ID]"}' with  TNF '${_tags[index2].records[1].tnf}, type '${_tags[index2].records[1].type}', payload '${_tags[index2].records[1].payload}' and data '${_tags[index2].records[1].data}' and language code '${_tags[index2].records[1].languageCode}''");
//              print("Record '${_tags[index2].records[2].id ?? "[NO ID]"}' with  TNF '${_tags[index2].records[2].tnf}, type '${_tags[index2].records[2].type}', payload '${_tags[index2].records[2].payload}' and data '${_tags[index2].records[2].data}' and language code '${_tags[index2].records[2].languageCode}''");

              UID_tag = _tags[index2].records[0].data;
//
//              chipNumberPayload= _tags[index2].records[0].payload;
//              print("printim chipNumber");
//              print(chipNumberPayload);
//              IDPayload = _tags[index2].records[1].payload;
//              numberPayload = int.parse(_tags[index2].records[2].payload);
//              namePayload = _tags[index2].records[3].payload;
//              commonNamePayload = _tags[index2].records[4].payload;
//              sirPayload = _tags[index2].records[5].payload;
//              damPayload = _tags[index2].records[6].payload;
//              dobPayload = _tags[index2].records[7].payload;
//              print(dobPayload + "dob");
//              print(yobPayload);
//              yobPayload = int.parse(_tags[index2].records[8].payload);
//              sexPayload = _tags[index2].records[9].payload;
//              breedPayload = _tags[index2].records[10].payload;
//              colourPayload = _tags[index2].records[11].payload;
//              descriptionPayload = _tags[index2].records[12].payload;
//
//              tapeMeasurePayload = int.parse(_tags[index2].records[13].payload);
//              stickMeasurePayload = int.parse(_tags[index2].records[14].payload);
//              breastGirthPayload = int.parse(_tags[index2].records[15].payload);
//              cannonGirthPayload = double.parse(_tags[index2].records[16].payload);
//              weightPayload = int.parse(_tags[index2].records[17].payload);

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

  void _stopScanning() {
    _streamSubscription?.cancel();
    setState(() {
      _streamSubscription = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stopScanning();
  }

  @override
  Widget build(BuildContext context) {
    if(horses == null){
      horses= List<Horse>();
      if(UID_tag != null){
        updateListView(UID_tag);
      }
    }
    horse1 = horses[0];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_horse.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            Container(
                padding: const EdgeInsets.all(8.0), child: Text('Info about horse'))
          ],
        ),
        actions: <Widget>[
          Builder(
            builder: (context){
              if(!_supportsNFC){
                return FlatButton(
                  child: Text("NFC unsupported"),
                  onPressed: null,
                );
              }
              return
                FlatButton(
                  child:
                  Text(_streamSubscription == null ? "Start reading": "Stop reading"),
                  onPressed: (){
                    if(_streamSubscription == null){
                      _startScannig(context);
                    } else{
                      _stopScanning();
                    }
                  },
                );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Builder(
              builder: (context){
                if (UID_tag == null) {
                  return Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(left: 10.0)
                              ),
                              Text(
                                "Basic Data",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          _field("Chip number", ""),
                          _field("ID number", ""),
                          _field("Number", ""),
                          _field("Name",""),
                          _field("Common name", ""),
                          _field("Sir", ""),
                          _field("Dam", ""),
                          _field("Day of birth", ""),
                          _field("Year of birth", ""),
                          _field("Sex", ""),
                          _field("Breed", ""),
                          _field("Colour", ""),
                          _field("Description", "")
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(left: 10.0)
                              ),
                              Text(
                                "Measurements",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          _field("Tape measure", ""),
                          _field("Stick measure", ""),
                          _field("Breast girth", ""),
                          _field("Cannon girth", ""),
                          _field("Weight", ""),
                        ],
                      ),
                    ],
                  );
                } else{
                  return Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(left: 10.0)
                              ),
                              Text(
                                "Basic Data",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          _field("Chip number", horse1.chipNumber),
                          _field("ID number", horse1.IDNumber),
                          _field("Number", horse1.number),
                          _field("Name", horse1.name),
                          _field("Common name", horse1.commonName),
                          _field("Sir", horse1.sir),
                          _field("Dam", horse1.dam),
                          _field("Day of birth", horse1.dob),
                          _field("Year of birth", horse1.yob),
                          _field("Sex", horse1.sex),
                          _field("Breed", horse1.breed),
                          _field("Colour", horse1.colour),
                          _field("Description", horse1.description)
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(left: 10.0)
                              ),
                              Text(
                                "Measurements",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          _field("Tape measure", horse1.tapeMeasure),
                          _field("Stick measure", horse1.stickMeasure),
                          _field("Breast girth", horse1.breastGirth),
                          _field("Cannon girth", horse1.cannonGirth),
                          _field("Weight", horse1.weight),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
              _sendBtn(),
          ],
        ),
      ),
    );
  }

  Widget _field(String key, var payload){
    bool nameVal = false;
    //TODO - onChange function
    return Row(
      children: <Widget>[
        Checkbox(
          value: nameVal,
        ),
        Text(key),
        Spacer(),
        Container(
          child: TextFormField(
            onChanged: (payload){
              setValue(key, payload);
            },
            controller: TextEditingController(
                text: "$payload"
            ),
          ),
          width: 200,
        ),
      ],
    );
  }

  void setValue(String key, var value){
    String keyValue = key;
    print("keyValue");
    print(keyValue);
    switch(keyValue) {
      case "Chip number": {
        horse1.chipNumber = value;
        print(horse1.chipNumber);
      }break;

      case "ID number": {
        horse1.IDNumber = value;
        print(horse1.IDNumber);
      }break;

      case "Number": {
        num = value;
        horse1.number = int.parse(num);
        print(horse1.number);
      }break;

      case "Name": {
        horse1.name= value;
        print(horse1.name);
      }break;

      case "Common name": {
        horse1.commonName = value;
        print(horse1.commonName);
      }break;

      case "Sir": {
        horse1.sir = value;
        print(horse1.sir);
      }break;

      case "Dam": {
        horse1.dam= value;
        print(horse1.dam);
      }break;

      case "Day of birth": {
        horse1.dob= value;
        print(horse1.dob);
      }break;

      case "Year of birth": {
        yob = value;
        horse1.yob= int.parse(yob);
        print(horse1.yob);
      }break;

      case "Sex": {
        horse1.sex = value;
        print(horse1.sex);
      }break;

      case "Breed": {
        horse1.breed= value;
        print(horse1.breed);
      }break;

      case "Colour": {
        horse1.colour = value;
        print(horse1.colour);
      }break;

      case "Description": {
        horse1.description = value;
        print(horse1.description);
      }break;

      case "Tape measure": {
        tape = value;
        horse1.tapeMeasure = int.parse(tape);
        print(horse1.tapeMeasure);
      }break;

      case "Stick measure": {
        stick = value;
        horse1.stickMeasure= int.parse(stick);
        print(horse1.stickMeasure);
      }break;

      case "Breast girth": {
        breast =value;
        horse1.breastGirth = int.parse(breast);
        print(horse1.breastGirth);
      }break;

      case "Cannon girth": {
        cannon = value;
        horse1.cannonGirth = double.parse(cannon);
        print(horse1.cannonGirth);
      }break;

      case "Weight": {
        wei = value;
        horse1.weight = int.parse(wei);
        print(horse1.weight);
      }break;
    }
  }

  Widget _sendBtn(){
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        color: Color.fromRGBO(0,44,44, 1.0),
        textColor: Colors.white,
        onPressed: (){
         //todo
        },
        child: Text("SEND"),
      ),
    );
  }

  void updateListView(String uid) {
    final Future<Database> dbFuture = dbProvider.initDB();
    dbFuture.then((database){
      Future<List<Horse>> horseListFuture = dbProvider.getMyHorseList(uid);
      horseListFuture.then((horses){
        setState(() {
          this.horses = horses;
          this.count = horses.length;
        });
      });
    });
  }

}
