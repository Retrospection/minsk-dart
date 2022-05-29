

import 'package:quiver/strings.dart';
import '../common/textSpan.dart';
import 'SyntaxKind.dart';
import 'Token.dart';
import '../common/diagnostics.dart';

bool isLetter(int codeUnit) =>
    (codeUnit >= 65 && codeUnit <= 90) || (codeUnit >= 97 && codeUnit <= 122);

class Lexer {
  final String _buffer;
  final DiagnosticBag _diagnosticBag = DiagnosticBag();
  int _position = 0;
  String _text = '';
  Object? _value = null;
  SyntaxKind _kind = SyntaxKind.badToken;

  Lexer(this._buffer);

  Iterable<Diagnostic> get diagnostics => _diagnosticBag.diagnostics;

  Token lex() {

    var start = _position;

    if (start == _buffer.length) {
      _kind = SyntaxKind.eofToken;
    } else if (isDigit(_currentRunes!.first)) {
      while (_currentRunes != null && isDigit(_currentRunes!.first)) {
        _advance();
      }
      _text = _buffer.substring(start, _position);
      _value = int.parse(_text);
      _kind = SyntaxKind.numberToken;
    } else if (isWhitespace(_currentRunes!.first)) {
      while (_currentRunes != null && isWhitespace(_currentRunes!.first)) {
        _advance();
      }
      _text = _buffer.substring(start, _position);
      _kind = SyntaxKind.whitespaceToken;
    } else if (isLetter(_current!.codeUnitAt(0))) {
      while (_current != null && isLetter(_current!.codeUnitAt(0))) {
        _advance();
      }
      var text = _buffer.substring(start, _position);
      if (text == 'true') {
        _kind = SyntaxKind.trueKeyword;
        _text = 'true';
      } else if (text == 'false') {
        _kind = SyntaxKind.falseKeyword;
        _text = 'false';
      } else {
        _kind = SyntaxKind.identifierToken;
        _text = text;
      }
    } else if (_current == '+') {
      _kind = SyntaxKind.plusToken;
      _text = '+';
      _advance();
    } else if (_current == '-') {
      _kind = SyntaxKind.minusToken;
      _text = '-';
      _advance();
    } else if (_current == '*') {
      _kind = SyntaxKind.starToken;
      _text = '*';
      _advance();
    } else if (_current == '/') {
      _kind = SyntaxKind.slashToken;
      _text = '/';
      _advance();
    } else if (_current == '(') {
      _kind = SyntaxKind.openParenthesisToken;
      _text = '(';
      _advance();
    } else if (_current == ')') {
      _kind = SyntaxKind.closeParenthesisToken;
      _text = ')';
      _advance();
    } else if (_current == '&') {
      if (_lookahead == '&') {
        _kind = SyntaxKind.ampersandAmpersandToken;
        _text = '&&';
        _position += 2;
      }
    } else if (_current == '|') {
      if (_lookahead == '|') {
        _kind = SyntaxKind.pipePipeToken;
        _text = '||';
        _position += 2;
      }
    } else if (_current == '!') {
      if (_lookahead == '=') {
        _kind = SyntaxKind.bangEqualsToken;
        _text = '!=';
        _position += 2;
      } else {
        _kind = SyntaxKind.bangToken;
        _text = '!';
        _advance();
      }
    } else if (_current == '=') {
      if (_lookahead == '=') {
        _kind = SyntaxKind.equalsEqualsToken;
        _text = '==';
        _position += 2;
      } else {
        _kind = SyntaxKind.equalsToken;
        _text = '=';
        _advance();
      }
    } else {
      _diagnosticBag.reportBadCharacter(TextSpan(_position, 1), _current);
    }
    return Token(_kind, start, _value, _text);
  }

  void _advance() {
    _position++;
  }

  String? get _current {
    return _peek(0);
  }

  String? get _lookahead {
    return _peek(1);
  }

  Runes? get _currentRunes {
    if (_current == null) {
      return null;
    }
    return Runes(_current!);
  }

  String? _peek(int offset) {
    final length = _buffer.length + offset;
    if (_position >= length) {
      return null;
    }
    return _buffer[_position];
  }

}