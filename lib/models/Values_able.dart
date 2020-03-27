class Values{
  int _idH;
  bool _chipNumber, _IDNumber, _name, _commonName, _sir, _dam, _sex, _breed, _colour, _dob, _description;
  bool _tapeMeasure, _stickMeasure, _breastGirth, _weight, _number, _yob;
  bool _cannonGirth;

  Values(this._idH, this._chipNumber, this._IDNumber, this._name, this._commonName,
      this._sir, this._dam, this._sex, this._breed, this._colour, this._dob,
      this._description, this._tapeMeasure, this._stickMeasure,
      this._breastGirth, this._weight, this._number, this._yob,
      this._cannonGirth);

  Map<String, dynamic> toMap() {
    return {
      'idH': _idH,
      'chipNumber': _chipNumber,
      'IDNumber': _IDNumber,
      'name': _name,
      'commonName': _commonName,
      'sir': _sir,
      'dam': _dam,
      'sex': _sex,
      'breed': _breed,
      'colour': _colour,
      'dob': _dob,
      'description': _description,
      'tapeMeasure': _tapeMeasure,
      'stickMeasure': _stickMeasure,
      'breastGirth': _breastGirth,
      'weight': _weight,
      'number': _number,
      'yob': _yob,
      'cannonGirth': _cannonGirth,
    };
  }

  Values.fromMapObject(Map<String, dynamic> map){
    this._idH= map['idH'];
    this._chipNumber = map['chipNumber'];
    this._IDNumber = map['IDNumber'];
    this._name = map['name'];
    this._commonName = map['commonName'];
    this._sir = map['sir'];
    this._dam = map['dam'];
    this._sex = map['sex'];
    this._breed = map['breed'];
    this._colour = map['colour'];
    this._dob = map['dob'];
    this._description = map['description'];
    this._tapeMeasure = map['tapeMeasure'];
    this._stickMeasure = map['stickMeasure'];
    this._breastGirth = map['breastGirth'];
    this._weight = map['weight'];
    this._number = map['number'];
    this._yob = map['yob'];
    this._cannonGirth = map['cannonGirth'];
  }

  bool get cannonGirth => _cannonGirth;

  set cannonGirth(bool value) {
    _cannonGirth = value;
  }

  get yob => _yob;

  set yob(value) {
    _yob = value;
  }

  get number => _number;

  set number(value) {
    _number = value;
  }

  get weight => _weight;

  set weight(value) {
    _weight = value;
  }

  get breastGirth => _breastGirth;

  set breastGirth(value) {
    _breastGirth = value;
  }

  get stickMeasure => _stickMeasure;

  set stickMeasure(value) {
    _stickMeasure = value;
  }

  bool get tapeMeasure => _tapeMeasure;

  set tapeMeasure(bool value) {
    _tapeMeasure = value;
  }

  get description => _description;

  set description(value) {
    _description = value;
  }

  get dob => _dob;

  set dob(value) {
    _dob = value;
  }

  get colour => _colour;

  set colour(value) {
    _colour = value;
  }

  get breed => _breed;

  set breed(value) {
    _breed = value;
  }

  get sex => _sex;

  set sex(value) {
    _sex = value;
  }

  get dam => _dam;

  set dam(value) {
    _dam = value;
  }

  get sir => _sir;

  set sir(value) {
    _sir = value;
  }

  get commonName => _commonName;

  set commonName(value) {
    _commonName = value;
  }

  get name => _name;

  set name(value) {
    _name = value;
  }

  get IDNumber => _IDNumber;

  set IDNumber(value) {
    _IDNumber = value;
  }

  bool get chipNumber => _chipNumber;

  set chipNumber(bool value) {
    _chipNumber = value;
  }

  int get idH => _idH;

  set idH(int value) {
    _idH = value;
  }


}