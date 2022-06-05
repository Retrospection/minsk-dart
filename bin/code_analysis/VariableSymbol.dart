

class VariableSymbol {
  final String _name;
  final Type _type;

  VariableSymbol(this._name, this._type);

  String get name => _name;
  Type get type => _type;
}