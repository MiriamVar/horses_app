import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horsesapp/AllHorses.dart';
import 'package:horsesapp/HorseInfo.dart';
import 'package:horsesapp/allCustomers.dart';
import 'package:horsesapp/customerProfile.dart';
import 'package:horsesapp/newCustomer.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:horsesapp/login.dart';

import 'Horse.dart';

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
  List<Object> descriptions = [];
  int index2 = 0;
  bool _hasClosedWriteDialog = false;
  AllHorses allHorses = new AllHorses();

  String chipNumberPayload, IDPayload, namePayload, commonNamePayload, sirPayload, damPayload, sexPayload, breedPayload, colourPayload, dobPayload, descriptionPayload;
  int tapeMeasurePayload, stickMeasurePayload, breastGirthPayload, weightPayload, numberPayload, yobPayload;
  double cannonGirthPayload;
  var payload;



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

              descriptions.clear();
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
      Form(
        child: SingleChildScrollView(
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
                                            "Zakladne udaje",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                      _field("chip number", ""),
                                      _field("ID number", ""),
                                      _field("number", ""),
                                      _field("name", ""),
                                      _field("common name", ""),
                                      _field("sir", ""),
                                      _field("dam", ""),
                                      _field("day of birth", ""),
                                      _field("year of birth", ""),
                                      _field("sex", ""),
                                      _field("breed", ""),
                                      _field("colour", ""),
                                      _field("description", "")
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
                                            "Miery",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                      _field("tape measure", ""),
                                      _field("stick measure", ""),
                                      _field("breast girth", ""),
                                      _field("cannon girth", ""),
                                      _field("weight",""),
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
                                            "Zakladne udaje",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                      _field("chip number", chipNumberPayload),
                                      _field("ID number", IDPayload),
                                      _field("number", numberPayload),
                                      _field("name", namePayload),
                                      _field("common name", commonNamePayload),
                                      _field("sir", sirPayload),
                                      _field("dam", damPayload),
                                      _field("day of birth", dobPayload),
                                      _field("year of birth", yobPayload),
                                      _field("sex", sexPayload),
                                      _field("breed", breedPayload),
                                      _field("colour", colourPayload),
                                      _field("description", descriptionPayload)

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
                                            "Miery",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
                                      _field("tape measure", tapeMeasurePayload),
                                      _field("stick measure", stickMeasurePayload),
                                      _field("breast girth", breastGirthPayload),
                                      _field("cannon girth", commonNamePayload),
                                      _field("weight",weightPayload),
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
      ),
    );
  }


//  Widget _nameField(String payload){
//    bool nameVal = false;
//    //TODO - onChange function
//    return Row(
//      children: <Widget>[
//        Checkbox(
//          value: nameVal,
//        ),
//        Text("Name"),
//        Container(
//          padding: EdgeInsets.only(left: 20.0),
//          child: TextFormField(
//            onChanged: (payload){
//              namePayload =payload;
//              print("new value of name $namePayload");
//            },
//            controller: TextEditingController(
//              text: payload
//            ),
//          ),
//          width: 200,
//        ),
//      ],
//    );
//  }

//  Widget _heightField(String payload){
//    bool heightVal = false;
//    //TODO - onChange function
//    return Row(
//      children: <Widget>[
//        Checkbox(
//          value: heightVal,
//        ),
//        Text("Height"),
//        Container(
//          padding: EdgeInsets.only(left: 15.0),
//          child: TextFormField(
//            onChanged: (payload){
//              heightPayload =payload;
//              print("new value of name $heightPayload");
//            },
//            controller: TextEditingController(
//                text: payload
//            ),
//          ),
//          width: 200,
//        ),
//      ],
//    );
//
//  }

//  Widget _colorField(String payload){
//    bool colorVal = false;
//    //TODO - onChange function
//    return Row(
//      children: <Widget>[
//        Checkbox(
//          value: colorVal,
//        ),
//        Text("Color"),
//        Container(
//          padding: EdgeInsets.only(left: 20.0),
//          child: TextFormField(
//            onChanged: (payload){
//              colorPayload =payload;
//              print("new value of name $colorPayload");
//            },
//            controller: TextEditingController(
//                text: payload
//            ),
//          ),
//          width: 200,
//        ),
//      ],
//    );
//  }

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
              payload = payload2;
              print("new value of $payload");
            },
            controller: TextEditingController(
                text: "$payload2",
            ),
            onSubmitted: (payload){
              print("printim novy payload");
              print(payload);
              descriptions.add(payload);
            },
          ),
          width: 200,
        ),
      ],

    );

  }

  void setValue(payload){
    print("printim novy payload");
    print(payload);
    descriptions.add(payload);
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

    print("descriptions velkost");
    print(descriptions.length);
    print("dob z descritions");
    print(descriptions.elementAt(7));

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
//    print(newHorse.name+ "        jdflqjwefdqwojdflqekjw");

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

