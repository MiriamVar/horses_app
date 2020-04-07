import 'dart:async';
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
        '/': (context) => LoginPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
      },
//      home: MyHomePage(title: 'Horses'),
//    home: LoginPage(),
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
  MyHomePage({Key key, this.customer}) : super(key: key);

  final Customer customer;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<NDEFMessage> _streamSubscription;
  bool _supportsNFC = false;
  List<NDEFMessage> _tags = [];
  int index2 = 0;
  bool _hasClosedWriteDialog = false;
  DBProvider dbProvider = DBProvider();

  String chipNumberPayload, IDPayload, namePayload, commonNamePayload, sirPayload, damPayload, sexPayload, breedPayload, colourPayload, dobPayload, descriptionPayload;
  int tapeMeasurePayload, stickMeasurePayload, breastGirthPayload, weightPayload, numberPayload, yobPayload;
  double cannonGirthPayload;

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
  bool chipNumber_ch= true;


  List<NDEFRecord> records = new List<NDEFRecord>();



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
              chipNumberPayload = _tags[index2].records[0].data;

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
        title: Text("Horse"),
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
                          if (chipNumberPayload == "") {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text("Scan tag on horse first")
                                  ],
                                )
                              ],
                            );
                          } else {
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
                                    _field("Chip number", chipNumberPayload,chipNumber_ch),
                                    _field("ID number", IDPayload, ID_ch),
                                    _field("Number", numberPayload, number_ch),
                                    _field("Name", namePayload, name_ch),
                                    _field("Common name", commonNamePayload, commonMane_ch),
                                    _field("Sir", sirPayload, sir_ch),
                                    _field("Dam", damPayload, dam_ch),
                                    _field("Day of birth", dobPayload, dob_ch),
                                    _field("Year of birth", yobPayload, yob_ch),
                                    _field("Sex", sexPayload, sex_ch),
                                    _field("Breed", breedPayload, breed_ch),
                                    _field("Colour", colourPayload, colour_ch),
                                    _field("Description", descriptionPayload, description_ch)
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
                                    _field("Tape measure", tapeMeasurePayload, tapeMeasure_ch),
                                    _field("Stick measure", stickMeasurePayload, stichMeasure_ch),
                                    _field("Breast girth", breastGirthPayload, breed_ch),
                                    _field("Cannon girth", cannonGirthPayload,cannonGirth_ch ),
                                    _field("Weight", weightPayload, weight_ch),
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

  void setChecked(String key, bool value){
    String keyValue = key;
    print("keyValue");
    print(keyValue);

    switch(keyValue) {
      case "Chip number": {
        chipNumber_ch = true;
        print("is chceck ID?");
        print(chipNumber_ch);
      }break;
      case "ID number": {
        ID_ch = value;
        print("is chceck ID?");
        print(ID_ch);
      }break;
      case "ID number": {
        ID_ch = value;
        print("is chceck ID?");
        print(ID_ch);
      }break;

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
    }
  }

  void isChecked(String key, bool value){
    String keyValue = key;
    print("keyValue");
    print(keyValue);

    switch(keyValue) {
      case "Chip number": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Chip number:"+chipNumberPayload));
        }
        print(ID_ch);
      }break;
      case "ID number": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "ID number:"+IDPayload));
        }
        print(ID_ch);
      }break;

      case "Number": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Number:"+numberPayload.toString()));
        }
        print(number_ch);
      }break;

      case "Name": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "name:"+namePayload));
        }
        print(name_ch);
      }break;

      case "Common name": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Common name:"+commonNamePayload));
        }
        print(commonMane_ch);
      }break;

      case "Sir": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Sir:"+sirPayload));
        }
        print(sir_ch);
      }break;

      case "Dam": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Dam:"+damPayload));
        }
        print(dam_ch);
      }break;

      case "Day of birth": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Day of birth:"+dobPayload));
        }
        print(dob_ch);
      }break;

      case "Year of birth": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Year of birth:"+yobPayload.toString()));
        }
        print(yob_ch);
      }break;

      case "Sex": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Sex:"+sexPayload));
        }
        print(sex_ch);
      }break;

      case "Breed": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Breed:"+breedPayload));
        }
        print(breed_ch);
      }break;

      case "Colour": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Colour:"+colourPayload));
        }
        print(colour_ch);
      }break;

      case "Description": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Description:"+descriptionPayload));
        }
        print(description_ch);
      }break;

      case "Tape measure": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Tape measure:"+tapeMeasurePayload.toString()));
        }
        print(tapeMeasure_ch);
      }break;

      case "Stick measure": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Stick measure:"+stickMeasurePayload.toString()));
        }
        print(stichMeasure_ch);
      }break;

      case "Breast girth": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Breast girth:"+breastGirthPayload.toString()));
        }
        print(breastGirth_ch);
      }break;

      case "Cannon girth": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Cannon girth:"+cannonGirthPayload.toString()));
        }
        print(cannonGirth_ch);
      }break;

      case "Weight": {
        if(value){
          records.add(NDEFRecord.type("text/plain", "Weight:"+weightPayload.toString()));
        }
        print(weight_ch);
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
        child: Text("SAVE DATA"),
      ),
    );
  }


  void _submitForm() async{
    print("submit form");

    var checkedValues = new Map();
    checkedValues['Chip number']= chipNumber_ch;
    checkedValues['ID number']= ID_ch;
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
    
    checkedValues.forEach((k, v) =>{
      isChecked(k,v)
    });

    print("pocet zaskrtnutych policok");
    print(records.length);

//    // prvych 5 veci sa zapise na Tag
//    records.add(NDEFRecord.type("text/plain", chipNumberPayload));
//    records.add(NDEFRecord.type("text/plain", IDPayload));
//    records.add(NDEFRecord.type("text/plain", numberPayload.toString()));
//    records.add(NDEFRecord.type("text/plain", namePayload));
//    records.add(NDEFRecord.type("text/plain", commonNamePayload));
//    records.add(NDEFRecord.type("text/plain", sirPayload));
//    records.add(NDEFRecord.type("text/plain", damPayload));
//    records.add(NDEFRecord.type("text/plain", dobPayload));
//    records.add(NDEFRecord.type("text/plain", yobPayload.toString()));
//    records.add(NDEFRecord.type("text/plain", sexPayload));
//    records.add(NDEFRecord.type("text/plain", breedPayload));
//    records.add(NDEFRecord.type("text/plain", colourPayload));
//    records.add(NDEFRecord.type("text/plain", descriptionPayload));

//    records.add(NDEFRecord.type("text/plain", tapeMeasurePayload.toString()));
//    records.add(NDEFRecord.type("text/plain", stickMeasurePayload.toString()));
//    records.add(NDEFRecord.type("text/plain", breastGirthPayload.toString()));
//    records.add(NDEFRecord.type("text/plain", cannonGirthPayload.toString()));
//    records.add(NDEFRecord.type("text/plain", weightPayload.toString()));


    //zapis noveho kona do db
//    Horse newHorse = Horse(widget.customer.id, chipNumberPayload, IDPayload,namePayload,commonNamePayload,sirPayload,damPayload,sexPayload,breedPayload,colourPayload,dobPayload,descriptionPayload, tapeMeasurePayload, stickMeasurePayload, breastGirthPayload, weightPayload, numberPayload, yobPayload, cannonGirthPayload);
//    _saveHorseFun(newHorse);


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

  void _saveHorseFun(Horse horse) async{
    await dbProvider.insertHorse(horse);
    print("new horse was saved");
  }


}

