import 'AssignmentExpressionSyntax.dart';
import 'BinaryExpressionSyntax.dart';
import 'ExpressionSyntax.dart';
import 'LiteralExpressionSyntax.dart';
import 'ParenthesisedExpressionSyntax.dart';
import 'SyntaxKind.dart';
import 'SyntaxTree.dart';
import 'Token.dart';
import 'UnaryExpressionSyntax.dart';
import 'lexer.dart';
import '../common/diagnostics.dart';

class Parser {
  late List<Token> _tokens;
  final DiagnosticBag _diagnostics = DiagnosticBag();
  int _position = 0;

  Parser(String text) {
    var lexer = Lexer(text);

    List<Token> tokens = List.empty(growable: true);
    Token token;
    do {
      token = lexer.lex();
      if (token.kind != SyntaxKind.badToken && token.kind != SyntaxKind.whitespaceToken) {
        tokens.add(token);
      }
    } while (token.kind != SyntaxKind.eofToken);

    _tokens = tokens;
    _diagnostics.batchAdd(lexer.diagnostics);
  }

  Iterable<Diagnostic> get diagnostics => _diagnostics.diagnostics;

  SyntaxTree parse() {
    var expression = parseExpression();
    var eofToken = matchToken(SyntaxKind.eofToken);
    return SyntaxTree(_diagnostics.diagnostics, expression, eofToken);
  }

  ExpressionSyntax parseExpression() {
    if (_current.kind == SyntaxKind.identifierToken && _lookahead.kind == SyntaxKind.equalsToken) {
      return parseAssignmentExpression();
    } else {
      return parseBinaryExpression();
    }
  }

  ExpressionSyntax parseAssignmentExpression() {
    var identifier = matchToken(SyntaxKind.identifierToken);
    var equalsToken = matchToken(SyntaxKind.equalsToken);
    var expression = parseExpression();
    return AssignmentExpressionSyntax(identifier, equalsToken, expression);
  }

  ExpressionSyntax parseBinaryExpression({int priority = 0}) {
    ExpressionSyntax left;

    var unaryOperatorPriority = _current.kind.getUnaryOperatorPriority();
    if (unaryOperatorPriority != 0 && unaryOperatorPriority >= priority) {
      var operatorToken = getCurrentAndAdvance();
      var operand = parseBinaryExpression(priority: unaryOperatorPriority);
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
      var right = parseBinaryExpression(priority: binaryOperatorPriority);
      left = BinaryExpressionSyntax(left, operatorToken, right);
    }

    return left;
  }

  ExpressionSyntax parsePrimaryExpression() {
    switch (_current.kind) {
      case SyntaxKind.openParenthesisToken:
        var openParenthesisToken = matchToken(SyntaxKind.openParenthesisToken);
        var expression = parseExpression();
        var closeParenthesisToken = matchToken(SyntaxKind.closeParenthesisToken);
        return ParenthesisedExpressionSyntax(openParenthesisToken, expression, closeParenthesisToken);
      case SyntaxKind.trueKeyword:
      case SyntaxKind.falseKeyword:
        var keyword = getCurrentAndAdvance();
        var value = keyword.kind == SyntaxKind.trueKeyword;
        return LiteralExpressionSyntax(value, keyword);
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

    _diagnostics.reportUnexpectedToken(_current.span, _current.kind, kind);
    return Token(kind, _current.position, null, '');
  }

  Token get _current => _peek(0);
  Token get _lookahead => _peek(1);

  Token _peek(int offset) {
    int position = _position + offset;
    if (position >= _tokens.length) {
      return _tokens.last;
    }

    return _tokens[position];
  }





}