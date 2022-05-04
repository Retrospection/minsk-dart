import 'package:quiver/strings.dart';
import 'SyntaxKind.dart';
import 'Token.dart';

class Lexer {
  final String _buffer;
  final List<String> _diagnostics = List.empty(growable: true);
  int _position = 0;

  Lexer(this._buffer);

  List<String> get diagnostics => _diagnostics;

  Token lex() {
    if (_current == null) {
      return Token(SyntaxKind.eofToken, _position, null, '');
    }

    if (isDigit(_currentRunes!.first)) {
      var start = _position;
      while (_currentRunes != null && isDigit(_currentRunes!.first)) {
        _advance();
      }
      var text = _buffer.substring(start, _position);
      return Token(SyntaxKind.numberToken, start, int.parse(text), text);
    }

    if (isWhitespace(_currentRunes!.first)) {
      var start = _position;
      while (_currentRunes != null && isWhitespace(_currentRunes!.first)) {
        _advance();
      }
      var text = _buffer.substring(start, _position);
      return Token(SyntaxKind.whitespaceToken, start, null, text);
    }

    if (_current == '+'){
      return Token(SyntaxKind.plusToken, _position++, null, '+');
    } else if (_current == '-') {
      return Token(SyntaxKind.minusToken, _position++, null, '-');
    } else if (_current == '*') {
      return Token(SyntaxKind.starToken, _position++, null, '*');
    } else if (_current == '/') {
      return Token(SyntaxKind.slashToken, _position++, null, '/');
    }
    
    _diagnostics.add('ERROR: bad character input: ${_current!}');
    return Token(SyntaxKind.badToken, _position++, null, '');
  }

  void _advance() {
    _position++;
  }

  String? get _current {
    final length = _buffer.length;
    if (_position >= length) {
      return null;
    }
    return _buffer[_position];
  }

  Runes? get _currentRunes {
    if (_current == null) {
      return null;
    }
    return Runes(_current!);
  }

}