import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horsesapp/screens/HorseInfo.dart';
import 'package:horsesapp/screens/allCustomersList.dart';
import 'package:horsesapp/screens/customerProfile.dart';
import 'package:horsesapp/screens/newCustomer.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:horsesapp/screens/login.dart';

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
//      home: MyHomePage(title: 'Horses'),
    home: LoginPage(),
//      home: CustomerProfile(),
//      home: AllCustomers()
//    home: NewCustomer(),
//    home: HorseInfo(number: 1,),
    );
  }
}

Map<int, Color> color = {
  50:Color.fromRGBO(25,85,85, .1),
//  50:Color.fromRGBO(224, 150, 112, .1),
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

//MaterialColor colorBrown = MaterialColor(0xFFE09670, color);
MaterialColor colorBrown = MaterialColor(0xff185555, color);

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<NDEFMessage> _streamSubscription;
  bool _supportsNFC = false;
  List<NDEFMessage> _tags = [];
  int index2 = 0;
  bool _hasClosedWriteDialog = false;
//  AllHorses allHorses = new AllHorses();

  String chipNumberPayload, IDPayload, namePayload, commonNamePayload, sirPayload, damPayload, sexPayload, breedPayload, colourPayload, dobPayload, descriptionPayload;
  int tapeMeasurePayload, stickMeasurePayload, breastGirthPayload, weightPayload, numberPayload, yobPayload;
  double cannonGirthPayload;

  String num, yob, tape, stick, breast, wei, cannon;



  void _startScannig(BuildContext context){
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

              chipNumberPayload= _tags[index2].records[0].payload;
              print("printim chipNumber");
              print(chipNumberPayload);
              IDPayload = _tags[index2].records[1].payload;
              numberPayload = int.parse(_tags[index2].records[2].payload);
              namePayload = _tags[index2].records[3].payload;
              commonNamePayload = _tags[index2].records[4].payload;
              sirPayload = _tags[index2].records[5].payload;
              damPayload = _tags[index2].records[6].payload;
              dobPayload = _tags[index2].records[7].payload;
              print(dobPayload + "dob");
              print(yobPayload);
              yobPayload = int.parse(_tags[index2].records[8].payload);
              sexPayload = _tags[index2].records[9].payload;
              breedPayload = _tags[index2].records[10].payload;
              colourPayload = _tags[index2].records[11].payload;
              descriptionPayload = _tags[index2].records[12].payload;

              tapeMeasurePayload = int.parse(_tags[index2].records[13].payload);
              stickMeasurePayload = int.parse(_tags[index2].records[14].payload);
              breastGirthPayload = int.parse(_tags[index2].records[15].payload);
              cannonGirthPayload = double.parse(_tags[index2].records[16].payload);
              weightPayload = int.parse(_tags[index2].records[17].payload);

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
  void initState() {
    super.initState();
    NFC.isNDEFSupported.then((supported) {
      setState(() {
        _supportsNFC = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
      body:
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Tab(icon: new Image.asset("assets/icon_horse.png"),),
                Text("Info about a horse"),
              ],
            ),
            Column(
                  children: <Widget>[
                    Builder(
                        builder: (context) {
                          if (_tags.isEmpty) {
                            return Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.0)
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
                                    _field("Name", ""),
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
                                            padding: EdgeInsets.only(
                                                left: 10.0)
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
                                    _field("Weight",""),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return  Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 10.0)
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
                                    _field("Chip number", chipNumberPayload),
                                    _field("ID number", IDPayload),
                                    _field("Number", numberPayload),
                                    _field("Name", namePayload),
                                    _field("Common name", commonNamePayload),
                                    _field("Sir", sirPayload),
                                    _field("Dam", damPayload),
                                    _field("Day of birth", dobPayload),
                                    _field("Year of birth", yobPayload),
                                    _field("Sex", sexPayload),
                                    _field("Breed", breedPayload),
                                    _field("Colour", colourPayload),
                                    _field("Description", descriptionPayload)

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
                                            padding: EdgeInsets.only(
                                                left: 10.0)
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
                                    _field("Tape measure", tapeMeasurePayload),
                                    _field("Stick measure", stickMeasurePayload),
                                    _field("Breast girth", breastGirthPayload),
                                    _field("Cannon girth", commonNamePayload),
                                    _field("Weight",weightPayload),
                                  ],
                                ),
                              ],
                            );
                          }
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


  Widget _field(String key, var payload2){
    bool val = false;
    //TODO - onChange function
     return Row(
      children: <Widget>[
        Checkbox(
          value: val,
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
        chipNumberPayload = value;
        print(chipNumberPayload);
      }break;

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
        child: Text("SEND"),
      ),
    );
  }


  void _submitForm() async{
    print("submit form");
    List<NDEFRecord> records = new List<NDEFRecord>();

    records.add(NDEFRecord.type("text/plain", chipNumberPayload));
    records.add(NDEFRecord.type("text/plain", IDPayload));
    records.add(NDEFRecord.type("text/plain", numberPayload.toString()));
    records.add(NDEFRecord.type("text/plain", namePayload));
    records.add(NDEFRecord.type("text/plain", commonNamePayload));
    records.add(NDEFRecord.type("text/plain", sirPayload));
    records.add(NDEFRecord.type("text/plain", damPayload));
    records.add(NDEFRecord.type("text/plain", dobPayload));
    records.add(NDEFRecord.type("text/plain", yobPayload.toString()));
    records.add(NDEFRecord.type("text/plain", sexPayload));
    records.add(NDEFRecord.type("text/plain", breedPayload));
    records.add(NDEFRecord.type("text/plain", colourPayload));
    records.add(NDEFRecord.type("text/plain", descriptionPayload));

    records.add(NDEFRecord.type("text/plain", tapeMeasurePayload.toString()));
    records.add(NDEFRecord.type("text/plain", stickMeasurePayload.toString()));
    records.add(NDEFRecord.type("text/plain", breastGirthPayload.toString()));
    records.add(NDEFRecord.type("text/plain", cannonGirthPayload.toString()));
    records.add(NDEFRecord.type("text/plain", weightPayload.toString()));

//    Horse newHorse = Horse(chipNumberPayload, IDPayload,namePayload,commonNamePayload,sirPayload,damPayload,sexPayload,breedPayload,colourPayload,dobPayload,descriptionPayload, tapeMeasurePayload, stickMeasurePayload, breastGirthPayload, weightPayload, numberPayload, yobPayload, cannonGirthPayload);
//    allHorses.addHorse(newHorse);

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
      Navigator.pop(context);
    }
  }

}

