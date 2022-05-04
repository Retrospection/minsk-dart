


import 'ExpressionSyntax.dart';
import 'SyntaxKind.dart';
import 'SyntaxNode.dart';
import 'Token.dart';

class BinaryExpressionSyntax extends ExpressionSyntax {
  final ExpressionSyntax _left;
  final Token _operator;
  final ExpressionSyntax _right;

  BinaryExpressionSyntax(this._left, this._operator, this._right);

  @override
  SyntaxKind get kind => SyntaxKind.binaryExpressionSyntax;
  ExpressionSyntax get left => _left;
  Token get operator => _operator;
  ExpressionSyntax get right => _right;

  @override
  Iterable<SyntaxNode> getChildren() sync* {
    yield _left;
    yield _operator;
    yield _right;
  }
}