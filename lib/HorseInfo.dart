import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Horse.dart';
import 'AllHorses.dart';


class HorseInfo extends StatefulWidget {
  HorseInfo({Key key, this.number}) : super(key: key);

  final int number;

  @override
  _HorseInfoState createState() => _HorseInfoState();
}

class _HorseInfoState extends State<HorseInfo> {
  AllHorses allHorses = new AllHorses();
  List<Horse> horses;
  Horse horse1;
  List<Horse> selectedHorse;
  bool sort;


  @override
  void initState() {
    sort = false;
    selectedHorse = [];
    horses = allHorses.getHorses();
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
    horse1 = horses[widget.number];
    print(horse1);
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
//      appBar: AppBar(
//        title: Text("Horse Info"),
////        actions: <Widget>[
////          Builder(
////            builder: (context){
////              if(!_supportsNFC){
////                return FlatButton(
////                  child: Text("NFC unsupported"),
////                  onPressed: null,
////                );
////              }
////              return
////                FlatButton(
////                  child:
////                  Text(_streamSubscription == null ? "Start reading": "Stop reading"),
////                  onPressed: (){
////                    if(_streamSubscription == null){
////                      _startScannig(context);
////                    } else{
////                      _stopScanning();
////                    }
////                  },
////                );
////            },
////          )
////        ],
//      ),
      body: Form(
        child: SingleChildScrollView(
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
                          "Zakladne udaje",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  _field("chip number", horse1.chipNumber),
                  _field("ID number", horse1.ID),
                  _field("number", horse1.number),
                  _field("name", horse1.name),
                  _field("common name", horse1.commonName),
                  _field("sir", horse1.sir),
                  _field("dam", horse1.dam),
                  _field("day of birth", horse1.dob),
                  _field("year of birth", horse1.yob),
                  _field("sex", horse1.sex),
                  _field("breed", horse1.breed),
                  _field("colour", horse1.colour),
                  _field("description", horse1.description)
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
                        "Miery",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  _field("tape measure", horse1.tapeMeasure),
                  _field("stick measure", horse1.stickMeasure),
                  _field("breast girth", horse1.breastGirth),
                  _field("cannon girth", horse1.cannonGirth),
                  _field("weight", horse1.weight),
                ],
              ),
                _sendBtn(),
            ],
          ),
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
//            onChanged: (payload){
//              print("new value of name $payload");
//            },
            controller: TextEditingController(
                text: "$payload"
            ),
          ),
          width: 200,
        ),
      ],
    );
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
}
