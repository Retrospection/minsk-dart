

import 'ExpressionSyntax.dart';
import 'SyntaxKind.dart';
import 'SyntaxNode.dart';
import 'Token.dart';

class ParenthesisedExpressionSyntax extends ExpressionSyntax {
  final Token _openParenthesis;
  final ExpressionSyntax _expression;
  final Token _closeParenthesis;

  ParenthesisedExpressionSyntax(this._openParenthesis, this._expression, this._closeParenthesis);

  @override
  SyntaxKind get kind => SyntaxKind.parenthesisExpressionSyntax;
  Token get openParenthesis => _openParenthesis;
  ExpressionSyntax get expression => _expression;
  Token get closeParenthesis => _closeParenthesis;

  @override
  Iterable<SyntaxNode> getChildren() sync* {
    yield _openParenthesis;
    yield _expression;
    yield _closeParenthesis;
  }
}