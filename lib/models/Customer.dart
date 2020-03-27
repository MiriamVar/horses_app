class Customer{
  int _id;
  String _name, _email;

  Customer(this._name,this._email);

  Customer.withID(this._id, this._name, this._email);

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'email': _email,
    };
  }

  Customer.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._name = map['name'];
    this._email = map['email'];

  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  get email => _email;

  set email(value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }


}