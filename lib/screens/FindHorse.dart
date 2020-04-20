import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:horsesapp/database.dart';
import 'package:horsesapp/models/Customer.dart';
import 'package:horsesapp/models/Horse.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

import 'customerProfile.dart';
import 'login.dart';

class FindHorse extends StatefulWidget {
  FindHorse({Key key, @required this.customer, @required this.horseTAG, @required this.horseDB}) : super(key: key);

  final Customer customer;
  final Horse horseTAG;
  final Horse horseDB;

  @override
  _FindHorseState createState() => _FindHorseState();
}

class _FindHorseState extends State<FindHorse>{

  Horse horseT;
  Horse horseD;

  bool connected = false;
  bool _hasClosedWriteDialog = false;
  StreamSubscription<NDEFMessage> _streamSubscription;
  DBProvider dbProvider = DBProvider();
  int count;
  String num, yob, tape, stick, breast, cannon, wei;

  bool ID_ch = false;
  bool name_ch = false;
  bool commonMane_ch = false;
  bool sir_ch= false;
  bool dam_ch= false;
  bool sex_ch= false;
  bool breed_ch= false;
  bool colour_ch = false;
  bool dob_ch = false;
  bool description_ch = false;
  bool tapeMeasure_ch =false;
  bool stichMeasure_ch= false;
  bool breastGirth_ch =false;
  bool weight_ch = false;
  bool number_ch= false;
  bool yob_ch= false;
  bool cannonGirth_ch = false;
  bool owner_ch = false;

  Map<String, String> ids = new Map();
  Map<String, String> basic = new Map();
  Map<String, String> pedigree= new Map();
  Map<String, String> description = new Map();
  Map<String, String> measurements = new Map();
  Map<String, String> owner = new Map();

  @override
  Widget build(BuildContext context) {
    horseT = widget.horseTAG;
    horseD = widget.horseDB;
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
                                      Text(horseD.chipNumber),
                                      Container(
                                        child: TextFormField(
                                          onChanged: (payload){
                                            setValue("RFID number", payload);
                                          },
                                          controller: TextEditingController(
                                              text: horseD.RFIDNumber
                                          ),
                                        ),
                                        width: 200,
                                      ),
                                      Container(
                                        child: TextFormField(
                                          onChanged: (payload){
                                            setValue("ID number", payload);
                                          },
                                          controller: TextEditingController(
                                              text: horseD.IDNumber
                                          ),
                                        ),
                                        width: 200,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: Text("Basic data"),
                            children: <Widget>[
                              _field("Number", horseD.number, number_ch),
                              _field("Name", horseD.name, name_ch),
                              _field("Common name", horseD.commonName, commonMane_ch),
                              _field("Day of birth", horseD.dob, dob_ch),
                              _field("Year of birth", horseD.yob, yob_ch),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: Text("Pedigree"),
                            children: <Widget>[
                              _field("Sir", horseD.sir, sir_ch),
                              _field("Dam", horseD.dam, dam_ch),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: Text("Description"),
                            children: <Widget>[
                              _field("Sex", horseD.sex, sex_ch),
                              _field("Breed", horseD.breed, breed_ch),
                              _field("Colour", horseD.colour, colour_ch),
                              _field("Description", horseD.description, description_ch),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: Text("Measurements"),
                            children: <Widget>[
                              _field("Tape measure", horseD.tapeMeasure, tapeMeasure_ch),
                              _field("Stick measure", horseD.stickMeasure, stichMeasure_ch),
                              _field("Breast girth", horseD.breastGirth, breastGirth_ch),
                              _field("Cannon girth", horseD.cannonGirth, cannonGirth_ch),
                              _field("Weight", horseD.weight, weight_ch),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          ),
                          ExpansionTile(
                            title: Text("Owner"),
                            children: <Widget>[
                              _field("Owner", horseD.owner, owner_ch),
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
//                      }
                }
                //ked nie som connectnuty
                else{
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
                            ExpansionTile(
                                title: Text("IDs"),
                                children:<Widget> [
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
                                          Text(horseT.chipNumber),
                                          Container(
                                            child: TextFormField(
                                              onChanged: (payload){
                                                setValue("RFID number", payload);
                                              },
                                              controller: TextEditingController(
                                                  text: horseT.RFIDNumber
                                              ),
                                            ),
                                            width: 200,
                                          ),
                                          Container(
                                            child: TextFormField(
                                              onChanged: (payload){
                                                setValue("ID number", payload);
                                              },
                                              controller: TextEditingController(
                                                  text: horseT.IDNumber
                                              ),
                                            ),
                                            width: 200,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ]
                            ),
                            ExpansionTile(
                              title: Text("Basic data"),
                              children: <Widget>[
                                _field("Number", horseT.number, number_ch),
                                _field("Name", horseT.name, name_ch),
                                _field("Common name", horseT.commonName, commonMane_ch),
                                _field("Day of birth", horseT.dob, dob_ch),
                                _field("Year of birth", horseT.yob, yob_ch),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Pedigree"),
                              children: <Widget>[
                                _field("Sir", horseT.sir, sir_ch),
                                _field("Dam", horseT.dam, dam_ch),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Description"),
                              children: <Widget>[
                                _field("Sex", horseT.sex, sex_ch),
                                _field("Breed", horseT.breed, breed_ch),
                                _field("Colour", horseT.colour, colour_ch),
                                _field("Description", horseT.description, description_ch),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Measurements"),
                              children: <Widget>[
                                _field("Tape measure", horseT.tapeMeasure, tapeMeasure_ch),
                                _field("Stick measure", horseT.stickMeasure, stichMeasure_ch),
                                _field("Breast girth", horseT.breastGirth, breastGirth_ch),
                                _field("Cannon girth", horseT.cannonGirth, cannonGirth_ch),
                                _field("Weight", horseT.weight, weight_ch),
                                SizedBox(
                                  height: 10.0,
                                ),
                              ],
                            ),
                            ExpansionTile(
                              title: Text("Owner"),
                              children: <Widget>[
                                _field("Owner", horseT.owner, owner_ch),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                        if(LoginPage.currentUser.name == "Vet") _saveToTAG(),
                      ],
                    );
                }
              },
              builder: (context){
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _field(String key, var payload, bool checked){
    return Row(
      children: <Widget>[
        Checkbox(
          value: checked,
          onChanged: (checked){
            setState(() {
              setChecked(key, checked);
            });
          },
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
      case "RFID number": {
        horseT.RFIDNumber = value;
        horseD.RFIDNumber = value;
      }break;

      case "ID number": {
        horseD.IDNumber = value;
        horseT.IDNumber = value;
      }break;

      case "Number": {
        num = value;
        horseD.number = int.parse(num);
        horseT.number = int.parse(num);
      }break;

      case "Name": {
        horseD.name= value;
        horseT.name= value;
      }break;

      case "Common name": {
        horseD.commonName = value;
        horseT.commonName = value;
      }break;

      case "Sir": {
        horseD.sir = value;
        horseT.sir = value;
      }break;

      case "Dam": {
        horseD.dam= value;
        horseT.dam= value;
      }break;

      case "Day of birth": {
        horseD.dob= value;
        horseT.dob= value;
      }break;

      case "Year of birth": {
        yob = value;
        horseD.yob= int.parse(yob);
        horseT.yob= int.parse(yob);
      }break;

      case "Sex": {
        horseD.sex = value;
        horseT.sex = value;
      }break;

      case "Breed": {
        horseD.breed= value;
        horseT.breed= value;
      }break;

      case "Colour": {
        horseD.colour = value;
        horseT.colour = value;
      }break;

      case "Description": {
        horseD.description = value;
        horseT.description = value;
      }break;

      case "Tape measure": {
        tape = value;
        horseD.tapeMeasure = int.parse(tape);
        horseT.tapeMeasure = int.parse(tape);
      }break;

      case "Stick measure": {
        stick = value;
        horseD.stickMeasure= int.parse(stick);
        horseT.stickMeasure= int.parse(stick);
      }break;

      case "Breast girth": {
        breast =value;
        horseD.breastGirth = int.parse(breast);
        horseT.breastGirth = int.parse(breast);
      }break;

      case "Cannon girth": {
        cannon = value;
        horseD.cannonGirth = double.parse(cannon);
        horseT.cannonGirth = double.parse(cannon);

      }break;

      case "Weight": {
        wei = value;
        horseD.weight = int.parse(wei);
        horseT.weight = int.parse(wei);
      }break;

      case "Owner": {
        horseD.owner = value;
        horseT.owner = value;
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

    switch(keyValue) {
      case "Number": {
        basic[keyValue] = horseT.toString();
      }break;

      case "Name": {
        basic[keyValue] = horseT.name;
      }break;

      case "Common name": {
        basic[keyValue] = horseT.commonName;
      }break;

      case "Sir": {
        pedigree[keyValue] = horseT.sir;
      }break;

      case "Dam": {
        pedigree[keyValue] = horseT.dam;
      }break;

      case "Day of birth": {
        basic[keyValue] = horseT.dob;
      }break;

      case "Year of birth": {
        basic[keyValue] = horseT.yob.toString();
      }break;

      case "Sex": {
        description[keyValue] = horseT.sex;
      }break;

      case "Breed": {
        description[keyValue] = horseT.breed;
      }break;

      case "Colour": {
        description[keyValue] = horseT.colour;
      }break;

      case "Description": {
        description[keyValue] = horseT.description;
      }break;

      case "Tape measure": {
        measurements[keyValue] = horseT.tapeMeasure.toString();
      }break;

      case "Stick measure": {
        measurements[keyValue] = horseT.stickMeasure.toString();
      }break;

      case "Breast girth": {
        measurements[keyValue] = horseT.breastGirth.toString();
      }break;

      case "Cannon girth": {
        measurements[keyValue] = horseT.cannonGirth.toString();
      }break;

      case "Weight": {
        measurements[keyValue] = horseT.weight.toString();
      }break;

      case "Owner": {
        owner[keyValue] = horseT.owner;
      }break;
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
        child: Text("SAVE ON TAG"),
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


  void _saveOnTAGFun() async{
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

    ids["Chip number"] = horseT.chipNumber;
    ids["ID number"] = horseT.IDNumber;
    ids["RFID number"] = horseT.RFIDNumber;

    String jsonIDs = jsonEncode(ids);
    String jsonBasic = jsonEncode(basic);
    String jsonPedigree = jsonEncode(pedigree);
    String jsonDesc = jsonEncode(description);
    String jsonMeasure = jsonEncode(measurements);
    String jsonOwner = jsonEncode(owner);

    records.add(NDEFRecord.type("text/json", jsonIDs));
    records.add(NDEFRecord.type("text/json", jsonBasic));
    records.add(NDEFRecord.type("text/json", jsonPedigree));
    records.add(NDEFRecord.type("text/json", jsonDesc));
    records.add(NDEFRecord.type("text/json", jsonMeasure));
    records.add(NDEFRecord.type("text/json", jsonOwner));

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

  void _saveOnDBandTAGFun() async{
    print("saving do db a na tag");

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

    ids["Chip number"] = horseT.chipNumber;
    ids["ID number"] = horseT.IDNumber;
    ids["RFID number"] = horseT.RFIDNumber;

    String jsonIDs = jsonEncode(ids);
    String jsonBasic = jsonEncode(basic);
    String jsonPedigree = jsonEncode(pedigree);
    String jsonDesc = jsonEncode(description);
    String jsonMeasure = jsonEncode(measurements);
    String jsonOwner = jsonEncode(owner);

    records.add(NDEFRecord.type("text/json", jsonIDs));
    records.add(NDEFRecord.type("text/json", jsonBasic));
    records.add(NDEFRecord.type("text/json", jsonPedigree));
    records.add(NDEFRecord.type("text/json", jsonDesc));
    records.add(NDEFRecord.type("text/json", jsonMeasure));
    records.add(NDEFRecord.type("text/json", jsonOwner));


    //update kona do db
    Horse newHorse = horseD;
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
      _showDialog("New horse was saved");
    }
  }


  void _saveOnDBFun(){
    //update kona do db
    Horse newHorse = horseD;
    _updateHorseFun(newHorse);
    Navigator.of(context).pop();
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
            content: Text(mess),
          );
        }
    );
  }


}