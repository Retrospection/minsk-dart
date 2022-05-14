


import 'boundNodeKind.dart';
import 'boundExpression.dart';


class BoundParenthesisExpression extends BoundExpression {

  final BoundExpression _expression;

  BoundParenthesisExpression(this._expression);

  @override
  BoundNodeKind get kind => BoundNodeKind.binaryExpression;

  @override
  Type get type => _expression.type;

  BoundExpression get expression => _expression;
}