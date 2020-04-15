import 'dart:async';
import 'package:horsesapp/models/Customer.dart';
import 'package:horsesapp/models/Horse.dart';
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
        return await openDatabase(path, version: 2,  onCreate: _createDb);
    }

    Customer vet = new Customer("Vet", "vet1@vet.com","vet123");
    Customer customer1 = new Customer("Kubo", "kubo@gmail.com","kubo123");
    Customer customer2 = new Customer("Miro", "miro@gmail.com","miro123");

    Horse horse1 = new Horse(2,"UID1","703001262600197","Nonius XX (N XIII-1) Jonatán","Nonius XX","703001082600407","703001082600711","žrebec","nonius","Hnedák","05-03-1997","viď grafický popis",170,161,190,0,3606,1997,21.6,"RFID1", "Kubo");
    Horse horse2 = new Horse(2,"UID2","703001082600407","Nonius XIII (N XLIV-78)","Nonius XIII ","703002073322615","25000113007583X","žrebec","nonius","Tm. hnedák","1979-08-30","ľ.z.sp.,p.z.sp.b;",180,169,198,0,3291,1979,23.0,"RFID2","Kubo");
    Horse horse3 = new Horse(2,"UID3","703001082600711","Nonius I-20","Nonius I","703002763125814","703001763100800","kobyla","nonius","Hnedák","	1981-12-18","b.ch.na c;l.z.v sp.a kor.nepr.b.,kop.pruh.b;",174,165,199,0,334,1981,20.6,"RFID3","Kubo");

    void _createDb(Database db, int newVersion) async{
      print("create customer");
        await db.execute("CREATE TABLE Customer("
            "id INTEGER PRIMARY KEY autoincrement,"
            "name TEXT,"
            "email TEXT,"
            "password TEXT"
            ")");
        print("create  customer done");
        print('create horse');
        await db.execute("CREATE TABLE Horse("
            "id INTEGER PRIMARY KEY autoincrement,"
            "customerID INTEGER,"
            "chipNumber TEXT not null,"
            "RFIDNumber TEXT,"
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
            "owner TEXT,"
            "FOREIGN KEY (customerID) REFERENCES Customer(id)"
            ")");
        print("create horse done");

      await db.insert('Customer', vet.toMap());
      print("create  customer1 done");
      await db.insert('Customer', customer1.toMap());
      print("create  customer2 done");
      await db.insert('Customer', customer2.toMap());
      print("create  customer3 done");

      print("create horse1");
      await db.insert('Horse', horse1.toMap());
      print("creating horse1 done");
      print("create horse2");
      await db.insert('Horse', horse2.toMap());
      print("creating horse2 done");
      print("create horse3");
      await db.insert('Horse', horse3.toMap());
      print("creating horse3 done");
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


    //INSERT INTO ...
    Future<int> insertCustomer(Customer customer) async{
      Database db = await this.database;
      return await db.insert('Customer', customer.toMap());
    }

    Future<int> insertHorse(Horse horse) async{
      Database db = await this.database;
      return await db.insert('Horse', horse.toMap());
    }


    //overenie customera
    Future<Customer> loginCustomer(String name, String password) async {
      Database dbs = await this.database;
      List<Map<String, dynamic>> result = await dbs.rawQuery('SELECT * FROM Customer WHERE name = ? AND password = ?', [name,password]);
      print("printim result");
      result.forEach((row) => print(row));
      if (result.length == 0) return null;

      return Customer.fromMapObject(result.first);
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

    //DELETE
    Future<int> deleteCustomer(int id) async{
      var db = await this.database;
      return await db.rawDelete('DELETE FROM Customer WHERE id = $id');
    }


    Future<int> deleteHorse(int idH) async{
      var db = await this.database;
      return await db.rawDelete('DELETE FROM Horse WHERE id = $idH');
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

