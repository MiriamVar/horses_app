import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horsesapp/HorseInfo.dart';
import 'package:horsesapp/main.dart';

class CustomerProfile extends StatefulWidget{

  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     body: Stack(
       children: <Widget>[
         Container(
           height: 180,
           decoration: BoxDecoration(
             gradient: LinearGradient(
               colors: [Color.fromRGBO(73, 130, 129, 1.0), Color.fromRGBO(0, 44, 44, 1.0)]
             )
           ),
         ),
         Positioned(
           top: 10,
           right: 0,
           left: 0,
           child: Container(
             height: 80,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Padding(
                   padding: EdgeInsets.only(top: 40),
                   child: Text(
                     "Profile",
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 20,
                     ),
                   ),
                 )
               ],
             ),
           ),
         ),
         Container(
           child: ListView(
             children: <Widget>[
               Container(
                 margin: EdgeInsets.only(
                   top: 90,
                   right: 20,
                   left: 20
                 ),
                 height: 500,
                 width: 400,
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius:  BorderRadius.all(Radius.circular(10)),
                   boxShadow: [
                     BoxShadow(
                       color: Color.fromRGBO(25, 85, 85, .1),
                       blurRadius: 20,
                       spreadRadius: 10
                     )
                   ]
                 ),
                 child: Column(
                   children: <Widget>[
                     SizedBox(
                       height: 20,
                     ),
                     Text(
                       'Customers name',
                       style: TextStyle(
                         color: Color.fromRGBO(25, 85, 85, 1.0),
                         fontSize: 20
                       ),
                     ),
                     Container(
                       margin: EdgeInsets.only(top: 30),
                       padding: EdgeInsets.only(left: 20, right: 20, top: 8),
                       width: 320,
                       height: 65,
                       decoration: BoxDecoration(
                           color: Colors.white,
                           boxShadow: [
                             BoxShadow(
                                 color: Colors.black.withOpacity(.1),
                                 blurRadius: 30,
                                 spreadRadius: 5)
                           ],
                           borderRadius: BorderRadius.circular(10)),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: <Widget>[
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: <Widget>[
                                   Text(
                                     'email',
                                     style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 18,
                                     ),
                                   ),
                                   SizedBox(
                                     height: 3,
                                   ),
                                   Text(
                                     'vet@gmail.com',
                                     style: TextStyle(
                                       color: Color.fromRGBO(73, 130, 129, 1.0)
                                     ),
                                   )
                                 ],
                               ),
                             ],
                           ),
                         ],
                       ) ,
                     ),
                     Column(
                       children: <Widget>[
                         SizedBox(
                           height: 30,
                         ),
                         SizedBox(
                           width: 300,
                           child: Divider(
                             height: 1,
                             color: Color.fromRGBO(25, 85, 85, .3),
                           ),
                         ),
                         SizedBox(
                           height: 10,
                         ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: <Widget>[
                             Row(
                               children: <Widget>[
                                 Material(
                                   borderRadius: BorderRadius.all(Radius.circular(100)),
                                   child: InkWell(
                                     borderRadius: BorderRadius.all(Radius.circular(100)),
                                     onTap: (){},
                                     child: Padding(
                                       padding: const EdgeInsets.all(12),
                                       child:  Tab(
                                         icon: new Image.asset("assets/icon_horse.png"),
                                       ),
                                     ),
                                   ),
                                 ),
                                 Text(
                                   "Horses",
                                   style: TextStyle(
                                       color: Colors.black,
                                       fontSize: 22
                                   ),
                                 ),
                               ],
                             ),
                             Row(
                               children: <Widget>[
                                 _addHorseBtn(),
                               ],
                             )
                           ],
                         ),
                         Column(
                           children: <Widget>[
                             Container(
                               width: 350,
                               child: ListView.builder(
                                   scrollDirection: Axis.vertical,
                                   shrinkWrap: true,
                                   itemCount: 2,
                                   itemBuilder: (context, index){
                                     return Card(
                                       elevation: 8.0,
                                       shape: RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(32.0),
                                       ),
                                       margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 6.0),
                                       child: Container(
                                         decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(32.0),
                                           color: Color.fromRGBO(73, 130, 129, .2),
                                         ),
                                         child: ListTile(
                                           contentPadding: EdgeInsets.symmetric(
                                               horizontal: 20.0,
                                               vertical: 3.0
                                           ),
                                           title: Text(
                                             "Horse ${index+1}",
                                             style: TextStyle(
                                                 color: Color.fromRGBO(0, 44, 44, 1.0),
                                                 fontWeight: FontWeight.bold
                                             ),
                                           ),
                                           trailing: IconButton(
                                             icon: Icon(
                                               Icons.keyboard_arrow_right,
                                               color: Color.fromRGBO(0, 44, 44, 1.0),
                                               size: 30.0,
                                             ),
                                             onPressed: (){
                                               if(index == 0){
                                                 Navigator.push(
                                                     context,
                                                     MaterialPageRoute(
                                                         builder: (context) => HorseInfo(number: 0,)
                                                     )
                                                 );
                                               }
                                               if(index == 1){
                                                 Navigator.push(
                                                     context,
                                                     MaterialPageRoute(
                                                         builder: (context) => HorseInfo(number: 1,)
                                                     )
                                                 );
                                               }

                                             },
                                           ),
                                         ),
                                       ),
                                     );
                                   }
                               ),
                             ),
                             SizedBox(
                               width: 14,
                             )
                           ],
                         )
                       ],
                     )
                   ],
                 ),
               ),
               SizedBox(
                 height: 200,
               )
             ],
           ),
         )
       ],
     ),
    );
  }

  Widget _addHorseBtn(){
    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: RaisedButton(
        padding: EdgeInsets.all(0),
        color: Color.fromRGBO(25, 85,85, 1.0),
        textColor: Colors.white,
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(title: "Horses",)
              )
          );
        },
        child: Text("Add horse"),
      ),
    );
  }
}