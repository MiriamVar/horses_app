import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horsesapp/database.dart';
import 'package:horsesapp/models/Customer.dart';
import 'package:horsesapp/screens/customerProfile.dart';
import 'package:horsesapp/screens/login.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:sqflite/sqflite.dart';
import '../models/Horse.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:percent_indicator/percent_indicator.dart';


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

  String chipNumberPayload, RFIDPayload, IDPayload, namePayload, commonNamePayload, sirPayload, damPayload, sexPayload, breedPayload, colourPayload, dobPayload, descriptionPayload;
  int tapeMeasurePayload, stickMeasurePayload, breastGirthPayload, weightPayload, numberPayload, yobPayload;
  double cannonGirthPayload;
  String ownerPayload;

  bool ID_ch = true;
  bool name_ch = true;
  bool commonMane_ch = true;
  bool sir_ch= true;
  bool dam_ch= true;
  bool sex_ch= true;
  bool breed_ch= true;
  bool colour_ch = true;
  bool dob_ch = true;
  bool description_ch = true;
  bool tapeMeasure_ch =true;
  bool stichMeasure_ch= true;
  bool breastGirth_ch =true;
  bool weight_ch = true;
  bool number_ch= true;
  bool yob_ch= true;
  bool cannonGirth_ch = true;
  bool owner_ch = true;

  Map<String, String> ids = new Map();
  Map<String, String> basic = new Map();
  Map<String, String> pedigree= new Map();
  Map<String, String> description = new Map();
  Map<String, String> measurements = new Map();
  Map<String, String> owner = new Map();

  double progressValue;
  double progressValue2;


  @override
  void initState() {
    progressValue = 0.0;
    progressValue2 = 0.0;
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
              var record1 = jsonDecode(_tags[index2].records[0].payload);
              var record2 = jsonDecode(_tags[index2].records[1].payload);
              var record3 = jsonDecode(_tags[index2].records[2].payload);
              var record4 = jsonDecode(_tags[index2].records[3].payload);
              var record5 = jsonDecode(_tags[index2].records[4].payload);
              var record6 = jsonDecode(_tags[index2].records[5].payload);

              chipNumberPayload = record1["Chip number"];
//              print(chipNumberPayload);
              IDPayload = record1["ID number"];
              RFIDPayload = record1["RFID number"];

              generateFirstValues(chipNumberPayload);
              generateFirstValues(IDPayload);
              generateFirstValues(RFIDPayload);

              if(record2["Number"] == "null"){
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

              if(record5["Tape measure"] == "null"){
                tapeMeasurePayload = 0;
              }else{
                tapeMeasurePayload = int.parse(record5["Tape measure"]);
              }

              if(record5["Stick measure"] == "null"){
                stickMeasurePayload= 0;
              } else{
                stickMeasurePayload = int.parse(record5["Stick measure"]);
              }

              if(record5["Breast girth"] == "null"){
                breastGirthPayload = 0;
              } else{
                breastGirthPayload = int.parse(record5["Breast girth"]);
              }

              if(record5["Cannon girth"] == "null"){
                cannonGirthPayload = 0;
              } else{
                cannonGirthPayload = double.parse(record5["Cannon girth"]);
              }

              if(record5["Weight"] == "null"){
                weightPayload = 0;
              } else{
                weightPayload = int.parse(record5["Weight"]);
              }

              ownerPayload = record6["Owner"];
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
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Info about horse',
                    style: TextStyle(
                        fontSize: 15.0
                    ),
                  )
              )
            ],
          ),
        ),
        actions: <Widget>[
          CircularPercentIndicator(
            radius: 40.0,
            lineWidth: 4.0,
            percent: progressValue,
            center: Text(progressValue.toString()+"%", style: TextStyle(color: Colors.white),),
            progressColor: Colors.white,
          ),
          OfflineBuilder(
            connectivityBuilder: (BuildContext context, ConnectivityResult connectivity, Widget child) {
              connected = connectivity != ConnectivityResult.none;
              if (!connected) {
                return FlatButton(
                  padding: EdgeInsets.all(0.0),
                  child:
                  Text(_streamSubscription == null
                      ? "Start scan"
                      : "Stop scan"),
                  onPressed: () {
                    if (_streamSubscription == null) {
                      _startScannig(context);
                    } else {
                      _stopScanning();
                    }
                  },
                );
              } else {
                return Container();
              }
            },
              builder: (context){
                return Container();
              }
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
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Information is from the database."),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              children: <Widget>[
                                ExpansionTile(
                                  title: Text("IDs"),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 45.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Text("Chip number"),
                                              Padding(
                                                padding: const EdgeInsets.only(top:33.0, bottom: 33.0),
                                                child: Text("RFID number"),
                                              ),
                                              Text("ID number"),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 33.0),
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Text(horseFromDB.chipNumber),
                                              Container(
                                                child: TextField(
                                                  onChanged: (payload){
                                                    setValue("RFID number", payload);
                                                  },
                                                  controller: TextEditingController(
                                                      text: horseFromDB.RFIDNumber
                                                  ),
                                                  decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.only(bottom: -30)
                                                  ),
                                                ),
                                                width: 200,
                                              ),
                                              Container(
                                                child: TextField(
                                                  onChanged: (payload){
                                                    setValue("ID number", payload);
                                                  },
                                                  controller: TextEditingController(
                                                      text: horseFromDB.IDNumber
                                                  ),
                                                  decoration: InputDecoration(
                                                      contentPadding: EdgeInsets.only(bottom: -30)
                                                  ),
                                                ),
                                                width: 200,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                      SizedBox(
                                    height: 10.0,
                                      ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text("Basic data"),
                                  children: <Widget>[
                                    _field("Number", horseFromDB.number, number_ch),
                                    _field("Name", horseFromDB.name, name_ch),
                                    _field("Common name", horseFromDB.commonName, commonMane_ch),
                                    _field("Day of birth", horseFromDB.dob, dob_ch),
                                    _field("Year of birth", horseFromDB.yob, yob_ch),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text("Pedigree"),
                                  children: <Widget>[
                                    _field("Sir", horseFromDB.sir, sir_ch),
                                    _field("Dam", horseFromDB.dam, dam_ch),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text("Description"),
                                  children: <Widget>[
                                    _field("Sex", horseFromDB.sex, sex_ch),
                                    _field("Breed", horseFromDB.breed, breed_ch),
                                    _field("Colour", horseFromDB.colour, colour_ch),
                                    _field("Description", horseFromDB.description, description_ch),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text("Measurements"),
                                  children: <Widget>[
                                    _field("Tape measure", horseFromDB.tapeMeasure, tapeMeasure_ch),
                                    _field("Stick measure", horseFromDB.stickMeasure, stichMeasure_ch),
                                    _field("Breast girth", horseFromDB.breastGirth, breastGirth_ch),
                                    _field("Cannon girth", horseFromDB.cannonGirth, cannonGirth_ch),
                                    _field("Weight", horseFromDB.weight, weight_ch),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  title: Text("Owner"),
                                  children: <Widget>[
                                    _field("Owner", horseFromDB.owner, owner_ch),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                               if(LoginPage.currentUser.name == "Vet") _saveToDB(),
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                ),
                                if(LoginPage.currentUser.name == "Vet")_saveToTAGandDB()
                              ],
                            )
                          ],
                        );
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
                                Text(
                                    "You are in OFFLINE mode.",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(73, 130, 129, 1.0)
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text("Any information because of missing info about implant."),
                                    Text("Please scan your implant."),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ExpansionTile(
                              title: Text("IDs"),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 45.0),
                                  child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text("Chip number"),
                                        Padding(
                                          padding: const EdgeInsets.only(top:33.0, bottom: 33.0),
                                          child: Text("RFID number"),
                                        ),
                                        Text("ID number"),
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(right: 31.0)
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text(""),
                                        Container(
                                          child: TextField(
                                            onChanged: (payload){
                                              setValue("RFID number", payload);
                                            },
                                            controller: TextEditingController(
                                                text: ""
                                            ),
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(bottom: -30)
                                            ),
                                          ),
                                          width: 200,
                                        ),
                                        Container(
                                          child: TextField(
                                            onChanged: (payload){
                                              setValue("ID number", payload);
                                            },
                                            controller: TextEditingController(
                                                text: ""
                                            ),
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(bottom: -30)
                                            ),
                                          ),
                                          width: 200,
                                        ),
                                      ],
                                    )
                                  ],
                              ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                )
                              ]
                            ),
                            ExpansionTile(
                              title: Text("Basic data"),
                              children: <Widget>[
                                _field("Number", "", number_ch),
                                _field("Name","", name_ch),
                                _field("Common name", "", commonMane_ch),
                                _field("Day of birth", "", dob_ch),
                                _field("Year of birth", "", yob_ch),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Pedigree"),
                              children: <Widget>[
                                _field("Sir", "", sir_ch),
                                _field("Dam", "", dam_ch),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Description"),
                              children: <Widget>[
                                _field("Sex", "", sex_ch),
                                _field("Breed", "", breed_ch),
                                _field("Colour", "", colour_ch),
                                _field("Description", "", description_ch),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Measurements"),
                              children: <Widget>[
                                _field("Tape measure", "", tapeMeasure_ch),
                                _field("Stick measure", "", stichMeasure_ch),
                                _field("Breast girth", "", breastGirth_ch),
                                _field("Cannon girth", "", cannonGirth_ch),
                                _field("Weight", "", weight_ch),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Owner"),
                              children: <Widget>[
                                _field("Owner", "", owner_ch),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                            if(LoginPage.currentUser.name == "Vet") _saveToTAG(),
                          ],
                        );
                      } else{
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    "You are in OFFLINE mode.",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(73, 130, 129, 1.0)
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Information is from the implant."),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            ExpansionTile(
                              title: Text("IDs"),
                              children:<Widget> [
                                Padding(
                                  padding: const EdgeInsets.only(left: 45.0),
                                  child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text("Chip number"),
                                        Padding(
                                          padding: const EdgeInsets.only(top:33.0, bottom: 33.0),
                                          child: Text("RFID number"),
                                        ),
                                        Text("ID number"),
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(right: 31.0)
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        Text(chipNumberPayload),
                                        Container(
                                          child: TextField(
                                            onChanged: (payload){
                                              setValue("RFID number", payload);
                                            },
                                            controller: TextEditingController(
                                                text: RFIDPayload
                                            ),
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(bottom: -30)
                                            ),
                                          ),
                                          width: 200,
                                        ),
                                        Container(
                                          child: TextField(
                                            onChanged: (payload){
                                              setValue("ID number", payload);
                                            },
                                            controller: TextEditingController(
                                                text: IDPayload
                                            ),
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(bottom: -30)
                                            ),
                                          ),
                                          width: 200,
                                        ),
                                      ],
                                    )
                                  ],
                              ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                )
                              ]
                            ),
                            ExpansionTile(
                              title: Text("Basic data"),
                              children: <Widget>[
                                _field("Number", numberPayload, number_ch),
                                _field("Name", namePayload, name_ch),
                                _field("Common name", commonNamePayload, commonMane_ch),
                                _field("Day of birth", dobPayload, dob_ch),
                                _field("Year of birth", yobPayload, yob_ch),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Pedigree"),
                              children: <Widget>[
                                _field("Sir", sirPayload, sir_ch),
                                _field("Dam", damPayload, dam_ch),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Description"),
                              children: <Widget>[
                                _field("Sex", sexPayload, sex_ch),
                                _field("Breed", breedPayload, breed_ch),
                                _field("Colour", colourPayload, colour_ch),
                                _field("Description", descriptionPayload, description_ch),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Measurements"),
                              children: <Widget>[
                                _field("Tape measure", tapeMeasurePayload, tapeMeasure_ch),
                                _field("Stick measure", stickMeasurePayload, stichMeasure_ch),
                                _field("Breast girth", breastGirthPayload, breastGirth_ch),
                                _field("Cannon girth", cannonGirthPayload, cannonGirth_ch),
                                _field("Weight", weightPayload, weight_ch),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Owner"),
                              children: <Widget>[
                                _field("Owner", ownerPayload, owner_ch),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                            if(LoginPage.currentUser.name == "Vet") _saveToTAG(),
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

  Widget _field(String key, var payload, bool checked){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Checkbox(
          value: checked,
          onChanged: (checked){
            setState(() {
              setChecked(key, checked);
            });
            if(checked){
              String hodnota = payload.toString();
              int bytes = hodnota.length * 4;
              // /100 tam bolo
              double percentage =((bytes * 100) / 512) / 100;
              print(percentage);
              double rounded = double.parse((percentage).toStringAsFixed(2));
              print(rounded);
              progressValue2 += rounded;
              progressValue = double.parse((progressValue2).toStringAsFixed(2));
              print(progressValue);
            } else{
              String hodnota = payload.toString();
              int bytes = hodnota.length * 4;
              double percentage =((bytes * 100) / 512) / 100;
              print(percentage);
              double rounded = double.parse(percentage.toStringAsFixed(2));
              print(rounded);
              progressValue2 -= rounded;
              progressValue = double.parse((progressValue2).toStringAsFixed(2));
              print(progressValue);
            }
          },
        ),
        Text(key),
        Spacer(),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextField(
                onChanged: (payload){
                  setValue(key, payload);
                },
                controller: TextEditingController(
                    text: "$payload"
                ),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: -20)
                ),
              ),
            ],
          ),
          width: 200,
        ),
      ],
    );
  }

  void generateFirstValues(var payload){
    String hodnota = payload.toString();
    int bytes = hodnota.length * 4;
    double percentage =((bytes * 100) / 512) / 100;
    print(percentage);
    double rounded = double.parse(percentage.toStringAsFixed(2));
    print(rounded);
    progressValue2 += rounded;
    progressValue = double.parse((progressValue2).toStringAsFixed(2));
    print(progressValue);
  }

  void setValue(String key, var value){
    String keyValue = key;
    print("keyValue");
    print(keyValue);

      switch(keyValue) {
        case "RFID number": {
          horseFromDB.RFIDNumber = value;
          print(horseFromDB.RFIDNumber);
          RFIDPayload = value;
        }break;

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
          tapeMeasurePayload =int.parse(tape);
        }break;

        case "Stick measure": {
          stick = value;
          horseFromDB.stickMeasure= int.parse(stick);
          print(horseFromDB.stickMeasure);
          stickMeasurePayload = int.parse(stick);
        }break;

        case "Breast girth": {
          breast =value;
          horseFromDB.breastGirth = int.parse(breast);
          print(horseFromDB.breastGirth);
          breastGirthPayload = int.parse(breast);
        }break;

        case "Cannon girth": {
          cannon = value;
          horseFromDB.cannonGirth = double.parse(cannon);
          print(horseFromDB.cannonGirth);
          cannonGirthPayload = double.parse(cannon);
        }break;

        case "Weight": {
          wei = value;
          horseFromDB.weight = int.parse(wei);
          print(horseFromDB.weight);
          weightPayload = int.parse(wei);
        }break;

        case "Owner": {
          horseFromDB.owner = value;
          print(horseFromDB.owner);
          ownerPayload = value;
        }break;
    }

  }

  void setChecked(String key, bool value){
    String keyValue = key;
    print("keyValue");
    print(keyValue);

    switch(keyValue) {
      case "Number": {
        number_ch = value;
        print(number_ch);
      }break;

      case "Name": {
        name_ch= value;
        print(name_ch);
      }break;

      case "Common name": {
        commonMane_ch = value;
        print(commonMane_ch);
      }break;

      case "Sir": {
        sir_ch = value;
        print(sir_ch);
      }break;

      case "Dam": {
        dam_ch = value;
        print(dam_ch);
      }break;

      case "Day of birth": {
        dob_ch = value;
        print(dob_ch);
      }break;

      case "Year of birth": {
        yob_ch = value;
        print(yob_ch);
      }break;

      case "Sex": {
        sex_ch = value;
        print(sex_ch);
      }break;

      case "Breed": {
        breed_ch = value;
        print(breed_ch);
      }break;

      case "Colour": {
        colour_ch = value;
        print(colour_ch);
      }break;

      case "Description": {
        description_ch = value;
        print(description_ch);
      }break;

      case "Tape measure": {
        tapeMeasure_ch = value;
        print(tapeMeasure_ch);
      }break;

      case "Stick measure": {
        stichMeasure_ch = value;
        print(stichMeasure_ch);
      }break;

      case "Breast girth": {
        breastGirth_ch =value;
        print(breastGirth_ch);
      }break;

      case "Cannon girth": {
        cannonGirth_ch = value;
        print(cannonGirth_ch);
      }break;

      case "Weight": {
        weight_ch = value;
        print(weight_ch);
      }break;

      case "Owner":{
        owner_ch = value;
        print(owner_ch);
      }
    }
  }

  void isChecked(String key, bool value){
    String keyValue = key;
    print("keyValue");
    print(keyValue);

    if(!value){
      return;
    }
    if(connected){
      switch(keyValue) {
        case "Number": {
          basic[keyValue] = horseFromDB.number.toString();
        }break;

        case "Name": {
          basic[keyValue] = horseFromDB.name;
        }break;

        case "Common name": {
          basic[keyValue] = horseFromDB.commonName;
        }break;

        case "Sir": {
          pedigree[keyValue] = horseFromDB.sir;
        }break;

        case "Dam": {
          pedigree[keyValue] = horseFromDB.dam;
        }break;

        case "Day of birth": {
          basic[keyValue] = horseFromDB.dob;
        }break;

        case "Year of birth": {
          basic[keyValue] = horseFromDB.yob.toString();
        }break;

        case "Sex": {
          description[keyValue] = horseFromDB.sex;
        }break;

        case "Breed": {
          description[keyValue] = horseFromDB.breed;
        }break;

        case "Colour": {
          description[keyValue] = horseFromDB.colour;
        }break;

        case "Description": {
          description[keyValue] = horseFromDB.description;
        }break;

        case "Tape measure": {
          measurements[keyValue] = horseFromDB.tapeMeasure.toString();
        }break;

        case "Stick measure": {
          measurements[keyValue] = horseFromDB.stickMeasure.toString();
        }break;

        case "Breast girth": {
          measurements[keyValue] = horseFromDB.breastGirth.toString();
        }break;

        case "Cannon girth": {
          measurements[keyValue] = horseFromDB.cannonGirth.toString();
        }break;

        case "Weight": {
          measurements[keyValue] = horseFromDB.weight.toString();
        }break;

        case "Owner": {
          owner[keyValue] = horseFromDB.owner;
        }break;
      }
    }else{
      switch(keyValue) {
        case "Number": {
          basic[keyValue] = numberPayload.toString();
        }break;

        case "Name": {
          basic[keyValue] = namePayload;
        }break;

        case "Common name": {
          basic[keyValue] = commonNamePayload;
        }break;

        case "Sir": {
          pedigree[keyValue] = sirPayload;
        }break;

        case "Dam": {
          pedigree[keyValue] = damPayload;
        }break;

        case "Day of birth": {
          basic[keyValue] = dobPayload;
        }break;

        case "Year of birth": {
          basic[keyValue] = yobPayload.toString();
        }break;

        case "Sex": {
          description[keyValue] = sexPayload;
        }break;

        case "Breed": {
          description[keyValue] = breedPayload;
        }break;

        case "Colour": {
          description[keyValue] = colourPayload;
        }break;

        case "Description": {
          description[keyValue] = descriptionPayload;
        }break;

        case "Tape measure": {
          measurements[keyValue] = tapeMeasurePayload.toString();
        }break;

        case "Stick measure": {
          measurements[keyValue] = stickMeasurePayload.toString();
        }break;

        case "Breast girth": {
          measurements[keyValue] = breastGirthPayload.toString();
        }break;

        case "Cannon girth": {
          measurements[keyValue] = cannonGirthPayload.toString();
        }break;

        case "Weight": {
          measurements[keyValue] = weightPayload.toString();
        }break;

        case "Owner": {
          owner[keyValue] = ownerPayload;
        }break;
      }
    }

  }

  Widget _saveToTAG(){
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        color: Color.fromRGBO(0,44,44, 1.0),
        textColor: Colors.white,
        onPressed: (){
          _saveOnTAGFun();
        },
        child: Text("SAVE ON IMPLANT"),
      ),
    );
  }

  Widget _saveToTAGandDB(){
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        color: Color.fromRGBO(0,44,44, 1.0),
        textColor: Colors.white,
        onPressed: (){
         _saveOnDBandTAGFun();
        },
        child: Text("SAVE ON IMPLANT"),
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

  void _saveOnTAGFun() async{
    progressValue = 0.0;

    var checkedValues = new Map();
    checkedValues['Number']= number_ch;
    checkedValues['Name']= name_ch;
    checkedValues['Common name']= commonMane_ch;
    checkedValues['Sir']= sir_ch;
    checkedValues['Dam']= dam_ch;
    checkedValues['Day of birth']= dob_ch;
    checkedValues['Year of birth']= yob_ch;
    checkedValues['Sex']= sex_ch;
    checkedValues['Breed']= breed_ch;
    checkedValues['Colour']= colour_ch;
    checkedValues['Description']= description_ch;
    checkedValues['Tape measure']= tapeMeasure_ch;
    checkedValues['Stick measure']= stichMeasure_ch;
    checkedValues['Breast girth']= breastGirth_ch;
    checkedValues['Cannon girth']= cannonGirth_ch;
    checkedValues['Weight']= weight_ch;
    checkedValues['Owner']= owner_ch;

    checkedValues.forEach((k, v) =>{
      isChecked(k,v)
    });

    List<NDEFRecord> records = new List<NDEFRecord>();

    ids["Chip number"] = chipNumberPayload;
    ids["ID number"] = IDPayload;
    ids["RFID number"] = RFIDPayload;

    String jsonIDs = jsonEncode(ids);
    String jsonBasic = jsonEncode(basic);
    String jsonPedigree = jsonEncode(pedigree);
    String jsonDesc = jsonEncode(description);
    String jsonMeasure = jsonEncode(measurements);
    String jsonOwner = jsonEncode(owner);

    records.add(NDEFRecord.type("text/json", jsonIDs));
    print("jsonID");
    List<int> bytes = utf8.encode(jsonIDs);
    print(bytes.length);
    records.add(NDEFRecord.type("text/json", jsonBasic));
    print("jsonBasic");
    List<int> bytes2 = utf8.encode(jsonBasic);
    print(bytes2.length);
    records.add(NDEFRecord.type("text/json", jsonPedigree));
    print("jsonPedigrees");
    List<int> bytes3 = utf8.encode(jsonPedigree);
    print(bytes3.length);
    records.add(NDEFRecord.type("text/json", jsonDesc));
    print("jsonDesc");
    List<int> bytes4 = utf8.encode(jsonDesc);
    print(bytes4.length);
    records.add(NDEFRecord.type("text/json", jsonMeasure));
    print("jsonMeasure");
    List<int> bytes5 = utf8.encode(jsonMeasure);
    print(bytes5.length);
    records.add(NDEFRecord.type("text/json", jsonOwner));
    print("jsonOwner");
    List<int> bytes6 = utf8.encode(jsonOwner);
    print(bytes6.length);

    NDEFMessage message = NDEFMessage.withRecords(records);

    //iOS zevraj ma svoj
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
              "Scan the implant you want to write to.",
            textAlign: TextAlign.center,
          ),
          content: Container(
              height: 100,
              child: Image.asset("assets/mircochip.jpg")
          ),
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
      _showDialog("Horse was updated on implant");
    }
  }

  void _saveOnDBFun(){
    //update kona do db
    Horse newHorse = horseFromDB;
    _updateHorseFun(newHorse);
    Navigator.of(context).pop();
    _showDialog("Horse was updated");
  }

  void _saveOnDBandTAGFun() async{
    print("saving do db a na tag");
    progressValue = 0.0;

    var checkedValues = new Map();
    checkedValues['Number']= number_ch;
    checkedValues['Name']= name_ch;
    checkedValues['Common name']= commonMane_ch;
    checkedValues['Sir']= sir_ch;
    checkedValues['Dam']= dam_ch;
    checkedValues['Day of birth']= dob_ch;
    checkedValues['Year of birth']= yob_ch;
    checkedValues['Sex']= sex_ch;
    checkedValues['Breed']= breed_ch;
    checkedValues['Colour']= colour_ch;
    checkedValues['Description']= description_ch;
    checkedValues['Tape measure']= tapeMeasure_ch;
    checkedValues['Stick measure']= stichMeasure_ch;
    checkedValues['Breast girth']= breastGirth_ch;
    checkedValues['Cannon girth']= cannonGirth_ch;
    checkedValues['Weight']= weight_ch;
    checkedValues['Owner']= owner_ch;

    checkedValues.forEach((k, v) =>{
      isChecked(k,v)
    });

    List<NDEFRecord> records = new List<NDEFRecord>();

    ids["Chip number"] = horseFromDB.chipNumber;
    ids["ID number"] = horseFromDB.IDNumber;
    ids["RFID number"] = horseFromDB.RFIDNumber;

    String jsonIDs = jsonEncode(ids);
    String jsonBasic = jsonEncode(basic);
    String jsonPedigree = jsonEncode(pedigree);
    String jsonDesc = jsonEncode(description);
    String jsonMeasure = jsonEncode(measurements);
    String jsonOwner = jsonEncode(owner);


    records.add(NDEFRecord.type("text/json", jsonIDs));
    print("jsonID");
    print(records.length);
    records.add(NDEFRecord.type("text/json", jsonBasic));
    print("jsonBasic");
    print(records.length);
    records.add(NDEFRecord.type("text/json", jsonPedigree));
    print("jsonPedigrees");
    print(records.length);
    records.add(NDEFRecord.type("text/json", jsonDesc));
    print("jsonDesc");
    print(records.length);
    records.add(NDEFRecord.type("text/json", jsonMeasure));
    print("jsonMeasure");
    print(records.length);
    records.add(NDEFRecord.type("text/json", jsonOwner));
    print("jsonOwner");
    print(records.length);

    //update kona do db
    Horse newHorse = horseFromDB;
    _updateHorseFun(newHorse);

    NDEFMessage message = NDEFMessage.withRecords(records);

    //iOS zevraj ma svoj
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
              "Scan the implant you want to write to.",
            textAlign: TextAlign.center,
          ),
          content: Container(
              height: 100,
              child: Image.asset("assets/mircochip.jpg")
          ),
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
      _showDialog("Horse updated on implant");
    }

  }

  void _updateHorseFun(Horse horse) async{
    await dbProvider.updateHorse(horse);
    print("horse was updated");
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
