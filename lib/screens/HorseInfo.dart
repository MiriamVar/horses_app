import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horsesapp/database.dart';
import 'package:sqflite/sqflite.dart';
import '../models/Horse.dart';


class HorseInfo extends StatefulWidget {
  HorseInfo({Key key, this.number, this.customerID}) : super(key: key);

  final int number, customerID;

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


  @override
  void initState() {
    sort = false;
    selectedHorse = [];
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    if(horses == null){
      horses= List<Horse>();
      updateListView(widget.customerID);
    }
    horse1 = horses[widget.number];
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
      ),
      body: SingleChildScrollView(
        child: Column(
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

  void updateListView(int idC) {
    final Future<Database> dbFuture = dbProvider.initDB();
    dbFuture.then((database){
      Future<List<Horse>> horsesListFuture = dbProvider.getMyHorsesList(idC);
      horsesListFuture.then((horses){
        setState(() {
          this.horses = horses;
          this.count = horses.length;
        });
      });
    });
  }

}
