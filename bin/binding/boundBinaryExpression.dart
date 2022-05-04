

import 'boundBinaryOperator.dart';
import 'boundNodeKind.dart';
import 'boundExpression.dart';


class BoundBinaryExpression extends BoundExpression {

  final BoundExpression _left;
  final BoundBinaryOperator _operator;
  final BoundExpression _right;

  BoundBinaryExpression(this._left, this._operator, this._right);

  @override
  BoundNodeKind get kind => BoundNodeKind.binaryExpression;

  @override
  Type get type => _operator.type;

  BoundExpression get left => _left;
  BoundBinaryOperator get operator => _operator;
  BoundExpression get right => _right;

}