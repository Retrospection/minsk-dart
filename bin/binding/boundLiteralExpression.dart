

import 'boundNodeKind.dart';
import 'boundExpression.dart';

class BoundLiteralExpression extends BoundExpression {
  final Object _value;

  BoundLiteralExpression(this._value);

  @override
  BoundNodeKind get kind => BoundNodeKind.literalExpression;
  @override
  Type get type => _value.runtimeType;
  Object get value => _value;
}