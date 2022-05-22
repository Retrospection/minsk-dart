

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

  Lexer(this._buffer);

  Iterable<Diagnostic> get diagnostics => _diagnosticBag.diagnostics;

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

    if (isLetter(_current!.codeUnitAt(0))) {
      var start = _position;
      while (_current != null && isLetter(_current!.codeUnitAt(0))) {
        _advance();
      }
      var text = _buffer.substring(start, _position);
      if (text == 'true') {
        return Token(SyntaxKind.trueKeyword, start, null, 'true');
      } else if (text == 'false') {
        return Token(SyntaxKind.falseKeyword, start, null, 'false');
      } else {
        return Token(SyntaxKind.identifierToken, start, null, text);
      }
    }

    if (_current == '+'){
      return Token(SyntaxKind.plusToken, _position++, null, '+');
    } else if (_current == '-') {
      return Token(SyntaxKind.minusToken, _position++, null, '-');
    } else if (_current == '*') {
      return Token(SyntaxKind.starToken, _position++, null, '*');
    } else if (_current == '/') {
      return Token(SyntaxKind.slashToken, _position++, null, '/');
    } else if (_current == '(') {
      return Token(SyntaxKind.openParenthesisToken, _position++, null, '(');
    } else if (_current == ')') {
      return Token(SyntaxKind.closeParenthesisToken, _position++, null, ')');
    } else if (_current == '&') {
      if (_lookahead == '&') {
        var position = _position;
        _position += 2;
        return Token(SyntaxKind.ampersandAmpersandToken, position, null, '&&');
      }
    } else if (_current == '|') {
      if (_lookahead == '|') {
        var position = _position;
        _position += 2;
        return Token(SyntaxKind.pipePipeToken, position, null, '||');
      }
    } else if (_current == '!') {
      if (_lookahead == '=') {
        var position = _position;
        _position += 2;
        return Token(SyntaxKind.bangEqualsToken, position, null, '!=');
      } else {
        return Token(SyntaxKind.bangToken, _position++, null, '!');
      }
    } else if (_current == '=') {
      if (_lookahead == '=') {
        var position = _position;
        _position += 2;
        return Token(SyntaxKind.equalsEqualsToken, position, null, '==');
      } else {
        return Token(SyntaxKind.equalsToken, _position++, null, '=');
      }
    } 
    
    _diagnosticBag.reportBadCharacter(TextSpan(_position, 1), _current);
    return Token(SyntaxKind.badToken, _position++, null, '');
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