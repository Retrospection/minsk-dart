import 'BinaryExpressionSyntax.dart';
import 'ExpressionSyntax.dart';
import 'LiteralExpressionSyntax.dart';
import 'SyntaxKind.dart';
import 'Token.dart';
import 'UnaryExpressionSyntax.dart';
import 'lexer.dart';

class Parser {
  late List<Token> _tokens;
  final List<String> _diagnostics = List.empty(growable: true);
  int _position = 0;

  Parser(String text) {
    var lexer = Lexer(text);

    List<Token> tokens = List.empty(growable: true);
    Token token = lexer.lex();
    while (token.kind != SyntaxKind.eofToken) {
      if (token.kind != SyntaxKind.badToken && token.kind != SyntaxKind.whitespaceToken) {
        tokens.add(token);
      }
      token = lexer.lex();
    }

    _tokens = tokens;
    _diagnostics.addAll(lexer.diagnostics);
  }

  List<String> get diagnostics => _diagnostics;

  ExpressionSyntax parse() {
    var expression = parseExpression();
    return expression;
  }

  ExpressionSyntax parseExpression({int priority = 0}) {
    ExpressionSyntax left;

    var unaryOperatorPriority = _current.kind.getUnaryOperatorPriority();
    if (unaryOperatorPriority != 0 && unaryOperatorPriority >= priority) {
      var operatorToken = getCurrentAndAdvance();
      var operand = parseExpression(priority: unaryOperatorPriority);
      left = UnaryExpressionSyntax(operatorToken, operand);
    } else {
      left = parsePrimaryExpression();
    }

    while(true) {
      var binaryOperatorPriority = _current.kind.getBinaryOperatorPriority();

      if (binaryOperatorPriority == 0 || binaryOperatorPriority <= priority) {
        break;
      }

      var operatorToken = getCurrentAndAdvance();
      var right = parseExpression(priority: binaryOperatorPriority);
      left = BinaryExpressionSyntax(left, operatorToken, right);
    }

    return left;
  }

  ExpressionSyntax parsePrimaryExpression() {
    switch (_current.kind) {
      default:
        var numberToken = matchToken(SyntaxKind.numberToken);
        return LiteralExpressionSyntax(numberToken.value!, numberToken);
    }
  }

  Token getCurrentAndAdvance() {
    var current = _current;
    _position++;
    return current;
  }

  Token matchToken(SyntaxKind kind) {
    if (kind == _current.kind) {
      return getCurrentAndAdvance();
    }

    _diagnostics.add('ERROR: Unexpected token <${_current.kind}>, expected <$kind>');
    return Token(kind, _current.position, null, '');
  }

  Token get _current => _peek(0);

  Token _peek(int offset) {
    int position = _position + offset;
    if (position >= _tokens.length) {
      return _tokens.last;
    }

    return _tokens[position];
  }



}