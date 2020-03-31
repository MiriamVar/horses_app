import 'dart:async';
import 'package:horsesapp/models/Customer.dart';
import 'package:horsesapp/models/Horse.dart';
import 'package:horsesapp/models/Values.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class DBProvider{

    static DBProvider _dbProvider;
    Database _database;

    DBProvider._instance();

    factory DBProvider(){
        if(_dbProvider ==null){
            _dbProvider = DBProvider._instance();
        }
        return _dbProvider;
    }

    Future<Database> get database async{
        if(_database == null){
            _database = await initDB();
        }
        return _database;
    }

    Future<Database> initDB() async{
        Directory docDirectory = await getApplicationDocumentsDirectory();
        String path = docDirectory.path +"horses.db";
        print(path);
        return await openDatabase(path, version: 1,  onCreate: _createDb);
    }

    void _createDb(Database db, int newVersion) async{
      print("create customer");
        await db.execute("CREATE TABLE Customer("
            "id INTEGER PRIMARY KEY autoincrement,"
            "name TEXT,"
            "email TEXT"
            ")");
        print("create  customer done");
        print('create horse');
        await db.execute("CREATE TABLE Horse("
            "id INTEGER PRIMARY KEY autoincrement,"
            "customerID INTEGER,"
            "chipNumber TEXT not null,"
            "IDNumber TEXT,"
            "name TEXT,"
            "commonName TEXT,"
            "sir TEXT,"
            "dam TEXT,"
            "sex TEXT,"
            "breed TEXT,"
            "colour TEXT,"
            "dob TEXT,"
            "description TEXT,"
            "tapeMeasure INTEGER,"
            "stickMeasure INTEGER,"
            "breastGirth INTEGER,"
            "weight INTEGER,"
            "number INTEGER,"
            "yob INTEGER,"
            "cannonGirth REAL,"
            "FOREIGN KEY (customerID) REFERENCES Customer(id)"
            ")");
        print("create horse done");
        print("create values");
        await db.execute("CREATE TABLE Values ("
            "idH INTEGER PRIMARY KEY,"
            "chipNumber INTEGER,"
            "IDNumber INTEGER,"
            "name INTEGER,"
            "commonName INTEGER,"
            "sir INTEGER,"
            "dam INTEGER,"
            "sex INTEGER,"
            "breed INTEGER,"
            "colour INTEGER,"
            "dob INTEGER,"
            "description INTEGER,"
            "tapeMeasure INTEGER,"
            "stickMeasure INTEGER,"
            "breastGirth INTEGER,"
            "weight INTEGER,"
            "number INTEGER,"
            "yob INTEGER,"
            "cannonGirth INTEGER,"
            "FOREIGN KEY (idH) REFERENCES Horse(id)"
            ")");
        print("create values done");

    }

    //SELECT * FROM ....
    Future<List<Map<String,dynamic>>> getCustomersMapList() async{
        Database db = await this.database;
        return await db.query('Customer');
    }

    Future<List<Map<String,dynamic>>> getMyHorsesMapList(int idC) async{
      Database db = await this.database;
      return await db.rawQuery('SELECT * FROM Horse WHERE customerID = $idC');
    }

    Future<List<Map<String,dynamic>>> getMyHorseMapList(String UID) async{
      Database db = await this.database;
      return await db.rawQuery('SELECT * FROM Horse WHERE uid = $UID');
    }

    Future<List<Map<String,dynamic>>> getMyHorseValuesMapList(int idH) async{
      Database db = await this.database;
      return await db.rawQuery('SELECT * FROM Values WHERE idH = $idH');
    }

    Future<List<Map<String,dynamic>>> getValuesMapList() async{
        Database db = await this.database;
        return await db.query('Values');
    }

    //INSERT INTO ...
    Future<int> insertCustomer(Customer customer) async{
      Database db = await this.database;
      return await db.insert('Customer', customer.toMap());
    }

    Future<int> insertHorse(Horse horse) async{
      Database db = await this.database;
      return await db.insert('Horse', horse.toMap());
    }

    Future<int> insertValues(Values values) async{
      Database db = await this.database;
      return await db.insert('Customer', values.toMap());
    }

    //UPDATE ..
    Future<int> updateCustomer(Customer customer) async{
      var db = await this.database;
      return await db.update('Customer', customer.toMap(), where: 'id = ?', whereArgs: [customer.id]);
    }

    Future<int> updateHorse(Horse horse) async{
      var db = await this.database;
      return await db.update('Horse', horse.toMap(), where: 'id = ?', whereArgs: [horse.id]);
    }

    Future<int> updateValues(Values values) async{
      var db = await this.database;
      return await db.update('Values', values.toMap(), where: 'idH = ?', whereArgs: [values.idH]);
    }

    //DELETE
    Future<int> deteleCustomer(int id) async{
      var db = await this.database;
      return await db.rawDelete('DELETE FROM Customer WHERE id = $id');
    }

    Future<List<Customer>> getCustomersList()async{
      var customersMapList = await getCustomersMapList();
      int count = customersMapList.length;

      List<Customer> customersList = List<Customer>();
      for(int i=0; i< count; i++){
        customersList.add(Customer.fromMapObject(customersMapList[i]));
      }
      return customersList;
    }

    Future<List<Horse>> getMyHorsesList(int idC)async{
      var myHorsesMapList = await getMyHorsesMapList(idC);
      int count = myHorsesMapList.length;

      List<Horse> myHorsesList = List<Horse>();
      for(int i=0; i< count; i++){
        myHorsesList.add(Horse.fromMapObject(myHorsesMapList[i]));
      }
      return myHorsesList;
    }

    Future<List<Horse>> getMyHorseList(String UID)async{
      var myHorseMapList = await getMyHorseMapList(UID);
      int count = myHorseMapList.length;

      List<Horse> myHorseList = List<Horse>();
      for(int i=0; i< count; i++){
        myHorseList.add(Horse.fromMapObject(myHorseMapList[i]));
      }
      return myHorseList;
    }











}

