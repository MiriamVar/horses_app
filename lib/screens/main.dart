import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horsesapp/database.dart';
import 'package:horsesapp/models/Customer.dart';
import 'package:horsesapp/screens/HorseInfo.dart';
import 'package:horsesapp/screens/allCustomersList.dart';
import 'package:horsesapp/screens/customerProfile.dart';
import 'package:horsesapp/screens/newCustomer.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:horsesapp/screens/login.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../models/Horse.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: colorBrown,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => new LoginPage(),
        '/allCustomers': (context) => new AllCustomersList(),
        '/logout': (context) => new LoginPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
      },
    );
  }
}

Map<int, Color> color = {
  50:Color.fromRGBO(25,85,85, .1),
  100:Color.fromRGBO(25,85,85, .2),
  200:Color.fromRGBO(25,85,85, .3),
  300:Color.fromRGBO(25,85,85, .4),
  400:Color.fromRGBO(25,85,85, .5),
  500:Color.fromRGBO(25,85,85, .6),
  600:Color.fromRGBO(25,85,85, .7),
  700:Color.fromRGBO(25,85,85, .8),
  800:Color.fromRGBO(25,85,85, .9),
  900:Color.fromRGBO(25,85,85, 1),
};

MaterialColor colorBrown = MaterialColor(0xff185555, color);

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.customer, this.tagID}) : super(key: key);

  final Customer customer;
  final String tagID;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<NDEFMessage> _streamSubscription;
  int index2 = 0;
  bool _hasClosedWriteDialog = false;
  DBProvider dbProvider = DBProvider();

  String chipNumberPayload, namePayload, commonNamePayload, sirPayload, damPayload, sexPayload, breedPayload, colourPayload, dobPayload, descriptionPayload;
  int tapeMeasurePayload, stickMeasurePayload, breastGirthPayload, weightPayload, numberPayload, yobPayload;
  double cannonGirthPayload;
  String IDPayload, RFIDPayload, ownerPayload;

  String num, yob, tape, stick, breast, wei, cannon;

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

  double progressValue = 0.0;
  double progressValue2 = 0.0;
  int togetherBytes = 0;

  @override
  Widget build(BuildContext context) {
    chipNumberPayload = widget.tagID;
    return Scaffold(
      appBar: AppBar(
        title: Text("Horse"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Tab(icon: new Image.asset("assets/icon_horse.png"),),
                Text("Add info about a new horse"),
              ],
            ),
            Column(
                  children: <Widget>[
                    Builder(
                        builder: (context) {
                            return Column(
                              children: <Widget>[
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
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  Text("Chip number:"),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top:33.0, bottom: 33.0),
                                                    child: Text("RFID number:"),
                                                  ),
                                                  Text("ID number:"),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(right: 33.0)
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    Text(chipNumberPayload),
                                                    Container(
                                                      child: TextField(
                                                        onChanged: (RFIDpayload){
                                                          setValue("RFID number", RFIDpayload);
                                                        },
                                                        controller: TextEditingController(
                                                            text: "$RFIDPayload"
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
                                                            text: "$IDPayload"
                                                        ),
                                                        decoration: InputDecoration(
                                                            contentPadding: EdgeInsets.only(bottom: -30)
                                                        ),
                                                      ),
                                                      width: 200,
                                                    )
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
                                        _field("Cannon girth", cannonGirthPayload,cannonGirth_ch ),
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
                                  ],
                                ),
                              ],
                            );
                        }
                    ),
                    _sendBtn(),
                  ],
                ),
          ],
        ),
      ),
    );
  }


  Widget _field(String key, var payload2, bool checked){
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
          child: TextField(
            onChanged: (payload2){
              setValue(key, payload2);
            },
            controller: TextEditingController(
                text: "$payload2",
            ),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: -30)
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
      case "ID number": {
        IDPayload = value;
        print(IDPayload);
      }break;

      case "RFID number": {
        RFIDPayload = value;
        print(RFIDPayload);
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
        yobPayload = int.parse(yob);
        print(yobPayload);
      }break;

      case "Sex": {
        sexPayload = value;
        print(sexPayload);
      }break;

      case "Breed": {
        breedPayload = value;
        print(breedPayload);
      }break;

      case "Colour": {
        colourPayload = value;
        print(colourPayload);
      }break;

      case "Description": {
        descriptionPayload = value;
        print(descriptionPayload);
      }break;

      case "Tape measure": {
        tape = value;
        tapeMeasurePayload = int.parse(tape);
        print(tapeMeasurePayload);
      }break;

      case "Stick measure": {
        stick = value;
        stickMeasurePayload = int.parse(stick);
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

      case "Owner":{
        ownerPayload = value;
        print(ownerPayload);
      }
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

  Widget _sendBtn(){
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        color: Color.fromRGBO(0,44,44, 1.0),
        textColor: Colors.white,
        onPressed: (){
          _submitForm();
        },
        child: Text("SAVE ON IMPLANT AND TO DATABASE"),
      ),
    );
  }


  void _submitForm() async{
    print("submit form");

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

    // iba 5 recordov
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
    print(jsonIDs);
    int bytes = jsonIDs.length + 12;
    print(bytes);

    records.add(NDEFRecord.type("text/json", jsonBasic));
    print("jsonBasic");
    print(jsonBasic);
    int bytes2 = jsonBasic.length + 12;
    print(bytes2);

    records.add(NDEFRecord.type("text/json", jsonPedigree));
    print("jsonPedigrees");
    print(jsonPedigree);
    int bytes3 = jsonPedigree.length + 12;
    print(bytes3);

    records.add(NDEFRecord.type("text/json", jsonDesc));
    print("jsonDesc");
    print(jsonDesc);
    int bytes4 = jsonDesc.length + 12;
    print(bytes4);

    records.add(NDEFRecord.type("text/json", jsonMeasure));
    print("jsonMeasure");
    print(jsonMeasure);
    int bytes5 = jsonMeasure.length + 12;
    print(bytes5);

    records.add(NDEFRecord.type("text/json", jsonOwner));
    print("jsonOwner");
    print(jsonOwner);
    int bytes6 = jsonOwner.length + 12;
    print(bytes6);

    togetherBytes = bytes + bytes2 + bytes3 + bytes4 + bytes5 + bytes6;

    double percentage =((togetherBytes * 100) / 512) / 100;
    print("prve percenta");
    print(percentage);

    double rounded = double.parse((percentage).toStringAsFixed(3));
    print("Zaokruhlenie na 4 miesta");
    print(rounded);

    progressValue2 = rounded;
    progressValue = double.parse((progressValue2).toStringAsFixed(2));
    print(progressValue);


    //zapis noveho kona do db
    Horse newHorse = Horse(widget.customer.id, chipNumberPayload, IDPayload,namePayload,commonNamePayload,sirPayload,damPayload,sexPayload,breedPayload,colourPayload,dobPayload,descriptionPayload, tapeMeasurePayload, stickMeasurePayload, breastGirthPayload, weightPayload, numberPayload, yobPayload, cannonGirthPayload, RFIDPayload, ownerPayload);
    _saveHorseFun(newHorse);

    NDEFMessage message = NDEFMessage.withRecords(records);



    //iOS zevraj ma svoj
    if (Platform.isAndroid) {
      _hasClosedWriteDialog =false;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Scan the implnat you want to write to."),
          content: Container(
            height: 160,
            child: Column(
              children: <Widget>[
                Container(
                    height: 110,
                    child: Image.asset("assets/mircochip.jpg")
                ),
                progressValue < 100
                    ? Container(
                  height: 60,
                  child: Column(
                    children: <Widget>[
                      Text("Filling the implant on:"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: LinearPercentIndicator(
                          lineHeight: 20.0,
                          percent: progressValue,
                          center: Text((progressValue * 100).toString()+"%", style: TextStyle(color: Colors.white),),
                          progressColor: Colors.black,
                          linearStrokeCap: LinearStrokeCap.roundAll,
                        ),
                      ),
                    ],
                  ),
                )
                    : Text("You choose more data as you can."),
              ],
            ),
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
      _showDialog("New horse was saved");
    }
  }

  void _saveHorseFun(Horse horse) async{
    await dbProvider.insertHorse(horse);
    print("new horse was saved");
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

