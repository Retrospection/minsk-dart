

import 'ExpressionSyntax.dart';
import 'SyntaxKind.dart';
import 'Token.dart';

class UnaryExpressionSyntax extends ExpressionSyntax {
  final Token _operator;
  final ExpressionSyntax _operand;

  UnaryExpressionSyntax(this._operator, this._operand);

  @override
  SyntaxKind get kind => SyntaxKind.unaryExpressionSyntax;
  Token get operator => _operator;
  ExpressionSyntax get operand => _operand;
}