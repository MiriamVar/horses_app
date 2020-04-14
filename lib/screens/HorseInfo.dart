import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horsesapp/database.dart';
import 'package:horsesapp/models/Customer.dart';
import 'package:horsesapp/screens/customerProfile.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:sqflite/sqflite.dart';
import '../models/Horse.dart';
import 'package:flutter_offline/flutter_offline.dart';


class HorseInfo extends StatefulWidget {
  HorseInfo({Key key, @required this.customer, @required this.horsik}) : super(key: key);

  final Customer customer;
  final Horse horsik;

  @override
  _HorseInfoState createState() => _HorseInfoState();
}

class _HorseInfoState extends State<HorseInfo> {
  Horse horseFromDB;
  List<Horse> selectedHorse;
  bool sort;
  String num, yob, tape, stick, breast, cannon, wei;
  DBProvider dbProvider = DBProvider();
  int count;
  StreamSubscription<NDEFMessage> _streamSubscription;
  bool _supportsNFC = false;
  List<NDEFMessage> _tags = [];
  int index2 = 0;
  bool connected=false;
  bool _hasClosedWriteDialog = false;

  String chipNumberPayload, IDPayload, namePayload, commonNamePayload, sirPayload, damPayload, sexPayload, breedPayload, colourPayload, dobPayload, descriptionPayload;
  int tapeMeasurePayload, stickMeasurePayload, breastGirthPayload, weightPayload, numberPayload, yobPayload;
  double cannonGirthPayload;

  List<String> whatIsOnTag = [];



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

              int lenght = _tags[index2].records.length;
              chipNumberPayload = _tags[index2].records[0].data;

              for(int i = 1; i <lenght; i++){
                String dataFromTag = _tags[index2].records[i].data;
                whatIsOnTag.add(dataFromTag);
                dataFromTag = "";
              }

              print("kolko je dat na tagu");
              print(whatIsOnTag.length);

              for(int i=0; i<whatIsOnTag.length; i++){

                String valueWithKey = whatIsOnTag[i];
                String key = valueWithKey.substring(0,valueWithKey.indexOf(RegExp(r':')));
                String valeu = valueWithKey.substring(valueWithKey.indexOf(RegExp(r':')));

                setValueFromTag(key, valeu);

                valueWithKey = "";
                key = "";
                valeu = "";
              }


//              IDPayload = _tags[index2].records[1].data;
//              if(IDPayload == null){
//                IDPayload = null;
//                numberPayload = null;
//                namePayload = null;
//                commonNamePayload = null;
//              }else {
//                numberPayload = int.parse(_tags[index2].records[2].data);
//                namePayload =_tags[index2].records[3].data;
//                commonNamePayload =_tags[index2].records[4].data;
//              }

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
//    if(horses == null){
//      horses= List<Horse>();
//      if(chipNumberPayload!= null){
//        updateListView(chipNumberPayload);
//      }
//    } else{
//      //su data z db sa doplnia + treba dorobit values
//      horseFromDB =
//      print("mam kona");
//      print(horseFromDB.name);
//    }
    horseFromDB = widget.horsik;
    print("mam kona");
    print(horseFromDB.name);
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo_horse.png',
                fit: BoxFit.contain,
                height: 22,
              ),
              Container(
                  padding: const EdgeInsets.all(5.0), child: Text('Info about horse', style: TextStyle(fontSize: 15.0),))
            ],
          ),
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
                OfflineBuilder(
                  connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child){
                    connected = connectivity!= ConnectivityResult.none;
                    //ak sme pripojeny na internet
                    if(connected == true){
//                      if (chipNumberPayload == null) {
//                         return Column(
//                          children: <Widget>[
//                            child,
//                            Column(
//                              children: <Widget>[
//                              ExpansionTile(
//                                title: Text("IDs"),
//                                children: <Widget>[
//                                  Row(
//                                    mainAxisSize: MainAxisSize.max,
//                                    mainAxisAlignment: MainAxisAlignment.center,
//                                    children: <Widget>[
//                                      Column(
//                                        mainAxisAlignment: MainAxisAlignment.end,
//                                        crossAxisAlignment: CrossAxisAlignment.end,
//                                        mainAxisSize: MainAxisSize.max,
//                                        children: <Widget>[
//                                          Text("Chip number:"),
//                                          Text("RFID number:"),
//                                          Text("ID number:"),
//                                        ],
//                                      ),
//                                      Padding(
//                                          padding: EdgeInsets.only(right: 10.0)
//                                      ),
//                                      Column(
//                                        mainAxisAlignment: MainAxisAlignment.start,
//                                        crossAxisAlignment: CrossAxisAlignment.start,
//                                        mainAxisSize: MainAxisSize.max,
//                                        children: <Widget>[
//                                          Text(""),
//                                          Text(""),
//                                          Text("")
//                                        ],
//                                      )
//                                    ],
//                                  ),
//                                ],
//                              ),
//                                ExpansionTile(
//                                  title: Text("Basic data"),
//                                  children: <Widget>[
//                                    _field("Number", ""),
//                                    _field("Name",""),
//                                    _field("Common name", ""),
//                                    _field("Day of birth", ""),
//                                    _field("Year of birth", ""),
//                                    SizedBox(
//                                      height: 10.0,
//                                    ),
//                                  ],
//                                ),
//                                ExpansionTile(
//                                  title: Text("Pedigree"),
//                                  children: <Widget>[
//                                    _field("Sir", ""),
//                                    _field("Dam", ""),
//                                    SizedBox(
//                                      height: 10.0,
//                                    ),
//                                  ],
//                                ),
//                                ExpansionTile(
//                                  title: Text("Description"),
//                                  children: <Widget>[
//                                    _field("Sex", ""),
//                                    _field("Breed", ""),
//                                    _field("Colour", ""),
//                                    _field("Description", ""),
//                                    SizedBox(
//                                      height: 10.0,
//                                    ),
//                                  ],
//                                ),
//                                ExpansionTile(
//                                  title: Text("Measurements"),
//                                  children: <Widget>[
//                                    _field("Tape measure", ""),
//                                    _field("Stick measure", ""),
//                                    _field("Breast girth", ""),
//                                    _field("Cannon girth", ""),
//                                    _field("Weight", ""),
//                                    SizedBox(
//                                      height: 20.0,
//                                    ),
//                                  ],
//                                )
//                              ],
//                            ),
//                            Row(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                _saveToDB(),
//                                Padding(
//                                  padding: EdgeInsets.only(right: 10.0),
//                                ),
//                                _saveToTAGandDB(),
//                              ],
//                            )
//                          ],
//                        );
//                      } else{
                        return Column(
                          children: <Widget>[
                            child,
                            Column(
                              children: <Widget>[
                                ExpansionTile(
                                  title: Text("IDs"),
                                  children: <Widget>[
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Text("Chip number:"),
                                            Text("RFID number:"),
                                            Text("ID number:"),
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(right: 10.0)
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            Text(horseFromDB.chipNumber),
                                            Text("3264982334"),
                                            Text(horseFromDB.IDNumber)
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text("Basic data"),
                                  children: <Widget>[
                                    _field("Number", horseFromDB.number),
                                    _field("Name", horseFromDB.name),
                                    _field("Common name", horseFromDB.commonName),
                                    _field("Day of birth", horseFromDB.dob),
                                    _field("Year of birth", horseFromDB.yob),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text("Pedigree"),
                                  children: <Widget>[
                                    _field("Sir", horseFromDB.sir),
                                    _field("Dam", horseFromDB.dam),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text("Description"),
                                  children: <Widget>[
                                    _field("Sex", horseFromDB.sex),
                                    _field("Breed", horseFromDB.breed),
                                    _field("Colour", horseFromDB.colour),
                                    _field("Description", horseFromDB.description),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text("Measurements"),
                                  children: <Widget>[
                                    _field("Tape measure", horseFromDB.tapeMeasure),
                                    _field("Stick measure", horseFromDB.stickMeasure),
                                    _field("Breast girth", horseFromDB.breastGirth),
                                    _field("Cannon girth", horseFromDB.cannonGirth),
                                    _field("Weight", horseFromDB.weight),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _saveToDB(),
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                ),
                                _saveToTAGandDB()
                              ],
                            )
                          ],
                        );
//                      }
                    }
                    //ked nie som connectnuty
                    else{
                      if (chipNumberPayload == null) {
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("You are in OFFLINE mode."),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text("Chip number:"),
                                        Text("RFID number:"),
                                        Text("ID number:"),
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(right: 10.0)
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text(""),
                                        Text(""),
                                        Text("")
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Basic data"),
                              children: <Widget>[
                                _field("Number", ""),
                                _field("Name",""),
                                _field("Common name", ""),
                                _field("Day of birth", ""),
                                _field("Year of birth", ""),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Pedigree"),
                              children: <Widget>[
                                _field("Sir", ""),
                                _field("Dam", ""),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Description"),
                              children: <Widget>[
                                _field("Sex", ""),
                                _field("Breed", ""),
                                _field("Colour", ""),
                                _field("Description", ""),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Measurements"),
                              children: <Widget>[
                                _field("Tape measure", ""),
                                _field("Stick measure", ""),
                                _field("Breast girth", ""),
                                _field("Cannon girth", ""),
                                _field("Weight", ""),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
//                            _saveToTAG(),
                          ],
                        );
                      } else{
                        return Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text("Chip number:"),
                                        Text("RFID number:"),
                                        Text("ID number:"),
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(right: 10.0)
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text(chipNumberPayload),
                                        Text("32649823345"),
                                        Text("87450234")
                                      ],
                                    )
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text("Basic data"),
                                  children: <Widget>[
                                    _field("Number", numberPayload),
                                    _field("Name", namePayload),
                                    _field("Common name", commonNamePayload),
                                    _field("Day of birth", dobPayload),
                                    _field("Year of birth", yobPayload),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text("Pedigree"),
                                  children: <Widget>[
                                    _field("Sir", sirPayload),
                                    _field("Dam", damPayload),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text("Description"),
                                  children: <Widget>[
                                    _field("Sex", sexPayload),
                                    _field("Breed", breedPayload),
                                    _field("Colour", colourPayload),
                                    _field("Description", descriptionPayload),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text("Measurements"),
                                  children: <Widget>[
                                    _field("Tape measure", tapeMeasurePayload),
                                    _field("Stick measure", stickMeasurePayload),
                                    _field("Breast girth", breastGirthPayload),
                                    _field("Cannon girth", cannonGirthPayload),
                                    _field("Weight", weightPayload),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
//                            _saveToTAG(),
                          ],
                        );
                      }
                    }
                  },
                  builder: (context){
                    return Container(
                      height: 0.5,
                    );
                  },
                )
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

    if(connected){
      switch(keyValue) {
        case "ID number": {
          horseFromDB.IDNumber = value;
          print(horseFromDB.IDNumber);
          IDPayload = value;
        }break;

        case "Number": {
          num = value;
          horseFromDB.number = int.parse(num);
          print(horseFromDB.number);
          numberPayload = int.parse(num);
        }break;

        case "Name": {
          horseFromDB.name= value;
          print(horseFromDB.name);
          namePayload = value;
        }break;

        case "Common name": {
          horseFromDB.commonName = value;
          print(horseFromDB.commonName);
          commonNamePayload = value;
        }break;

        case "Sir": {
          horseFromDB.sir = value;
          print(horseFromDB.sir);
          sirPayload = value;
        }break;

        case "Dam": {
          horseFromDB.dam= value;
          print(horseFromDB.dam);
          damPayload = value;
        }break;

        case "Day of birth": {
          horseFromDB.dob= value;
          print(horseFromDB.dob);
          dobPayload = value;
        }break;

        case "Year of birth": {
          yob = value;
          horseFromDB.yob= int.parse(yob);
          print(horseFromDB.yob);
          yobPayload = int.parse(yob);
        }break;

        case "Sex": {
          horseFromDB.sex = value;
          print(horseFromDB.sex);
          sexPayload = value;
        }break;

        case "Breed": {
          horseFromDB.breed= value;
          print(horseFromDB.breed);
          breedPayload = value;
        }break;

        case "Colour": {
          horseFromDB.colour = value;
          print(horseFromDB.colour);
          colourPayload = value;
        }break;

        case "Description": {
          horseFromDB.description = value;
          print(horseFromDB.description);
          descriptionPayload = value;
        }break;

        case "Tape measure": {
          tape = value;
          horseFromDB.tapeMeasure = int.parse(tape);
          print(horseFromDB.tapeMeasure);
          tapeMeasurePayload =value;
        }break;

        case "Stick measure": {
          stick = value;
          horseFromDB.stickMeasure= int.parse(stick);
          print(horseFromDB.stickMeasure);
          stickMeasurePayload = value;
        }break;

        case "Breast girth": {
          breast =value;
          horseFromDB.breastGirth = int.parse(breast);
          print(horseFromDB.breastGirth);
        }break;

        case "Cannon girth": {
          cannon = value;
          horseFromDB.cannonGirth = double.parse(cannon);
          print(horseFromDB.cannonGirth);
          cannonGirthPayload = value;
        }break;

        case "Weight": {
          wei = value;
          horseFromDB.weight = int.parse(wei);
          print(horseFromDB.weight);
          weightPayload = value;
        }break;
      }
    }

  }

  void setValueFromTag(String key, var value){
    String keyValue = key;
    print("keyValue");
    print(keyValue);

      switch(keyValue) {
        case "ID number": {
          IDPayload = value;
          print(IDPayload);
        }break;

        case "Number": {
          num = value;
          numberPayload = int.parse(num);
          print(numberPayload);
        }break;

        case "Name": {
          namePayload = value;
          print(namePayload);
        }break;

        case "Common name": {
          commonNamePayload = value;
          print(commonNamePayload);
        }break;

        case "Sir": {
          sirPayload = value;
          print(sirPayload);
        }break;

        case "Dam": {
          damPayload = value;
          print(damPayload);
        }break;

        case "Day of birth": {
          dobPayload = value;
          print(dobPayload);
        }break;

        case "Year of birth": {
          yob = value;
          yobPayload= int.parse(yob);
          print(yobPayload);
        }break;

        case "Sex": {
          sexPayload= value;
          print(sexPayload);
        }break;

        case "Breed": {
          breedPayload= value;
          print(breedPayload);
        }break;

        case "Colour": {
          colourPayload = value;
          print(colourPayload);
        }break;

        case "Description": {
          descriptionPayload= value;
          print(descriptionPayload);
        }break;

        case "Tape measure": {
          tape = value;
          tapeMeasurePayload = int.parse(tape);
          print(tapeMeasurePayload);
        }break;

        case "Stick measure": {
          stick = value;
          stickMeasurePayload= int.parse(stick);
          print(stickMeasurePayload);
        }break;

        case "Breast girth": {
          breast =value;
          breastGirthPayload = int.parse(breast);
          print(breastGirthPayload);
        }break;

        case "Cannon girth": {
          cannon = value;
          cannonGirthPayload = double.parse(cannon);
          print(cannonGirthPayload);
        }break;

        case "Weight": {
          wei = value;
          weightPayload = int.parse(wei);
          print(weightPayload);
        }break;
    }

  }

  //plus widget na save on tag iba...

  Widget _saveToTAGandDB(){
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        color: Color.fromRGBO(0,44,44, 1.0),
        textColor: Colors.white,
        onPressed: (){
         _saveOnDBandTAGFun();
        },
        child: Text("SAVE ON TAG"),
      ),
    );
  }

  Widget _saveToDB(){
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        color: Color.fromRGBO(0,44,44, 1.0),
        textColor: Colors.white,
        onPressed: (){
         _saveOnDBFun();
        },
        child: Text("SAVE TO DATABASE"),
      ),
    );
  }

//  void updateListView(String uid) {
//    final Future<Database> dbFuture = dbProvider.initDB();
//    dbFuture.then((database){
//      Future<List<Horse>> horseListFuture = dbProvider.getMyHorseList(uid);
//      horseListFuture.then((horses){
//        setState(() {
//          this.horses = horses;
//          this.count = horses.length;
//        });
//      });
//    });
//  }

  void _saveOnDBFun(){
    //update kona do db
    Horse newHorse = horseFromDB;
    _updateHorseFun(newHorse);
    Navigator.of(context).pop();
  }

  void _saveOnDBandTAGFun() async{
    print("saving do db a na tag");
    List<NDEFRecord> records = new List<NDEFRecord>();

    // prvych 5 veci sa zapise na Tag
    records.add(NDEFRecord.type("text/plain", chipNumberPayload));
    records.add(NDEFRecord.type("text/plain", horseFromDB.IDNumber));
    records.add(NDEFRecord.type("text/plain", horseFromDB.number.toString()));
    records.add(NDEFRecord.type("text/plain", horseFromDB.name));
    records.add(NDEFRecord.type("text/plain", horseFromDB.commonName));

    //update kona do db
    Horse newHorse = horseFromDB;
    _updateHorseFun(newHorse);

    NDEFMessage message = NDEFMessage.withRecords(records);

    //iOS zevraj ma svoj
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Scan the tag you want to write to"),
          actions: <Widget>[
            FlatButton(
              child: const Text("Cancel"),
              onPressed: () {
                _hasClosedWriteDialog = true;
                _streamSubscription?.cancel();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }

    await NFC.writeNDEF(message).first;
    if(!_hasClosedWriteDialog){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomerProfile(customer: widget.customer,)
          )
      );
    }
  }

  void _updateHorseFun(Horse horse) async{
    await dbProvider.updateHorse(horse);
    print("horse was updated");
  }

}
