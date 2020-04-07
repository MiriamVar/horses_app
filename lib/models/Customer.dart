class Customer{
  int _id;
  String _name;
  String _email;
  String _password;

  Customer(this._name,this._email, this._password);

  Customer.withID(this._id, this._name, this._email, this._password);

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'email': _email,
      'password': _password,
    };
  }

  Customer.fromMapObject(dynamic map){
    if(map['id'] == null){
      this._id = 0;
      this._name = map['name'];
      this._email = map['email'];
      this._password = map['password'];
    } else{
      this._id = int.parse(map['id']);
      this._name = map['name'];
      this._email = map['email'];
      this._password = map['password'];
    }

  }

  int get id => _id;
  String get email => _email;
  String get name => _name;
  String get password => _password;


}