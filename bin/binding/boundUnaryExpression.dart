import 'boundExpression.dart';
import 'boundNodeKind.dart';
import 'boundUnaryOperator.dart';


class BoundUnaryExpression extends BoundExpression {
  final BoundUnaryOperator _operator;
  final BoundExpression _expression;

  BoundUnaryExpression(this._operator, this._expression);

  @override
  BoundNodeKind get kind => BoundNodeKind.unaryExpression;
  @override
  Type get type => _operator.type;
  BoundUnaryOperator get operator => _operator;
  BoundExpression get expression => _expression;
}