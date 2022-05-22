
import '../common/textSpan.dart';
import 'SyntaxKind.dart';
import 'SyntaxNode.dart';

class Token extends SyntaxNode {
  final SyntaxKind _kind;
  final int _position;
  final Object? _value;
  final String _text;

  Token(this._kind, this._position, this._value, this._text);

  @override
  String toString() {
    return "SyntaxKind: ${_kind.name} Text: $_text";
  }

  @override
  SyntaxKind get kind => _kind;

  String get text => _text;
  int get position => _position;
  Object? get value => _value;

  TextSpan get span => TextSpan(_position, _text.length);
}