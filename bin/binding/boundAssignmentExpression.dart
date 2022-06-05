

import '../code_analysis/VariableSymbol.dart';
import 'boundExpression.dart';
import 'boundNodeKind.dart';

class BoundAssignmentExpression extends BoundExpression {
  final VariableSymbol _symbol;
  final BoundExpression _expr;

  BoundAssignmentExpression(this._symbol, this._expr);

  VariableSymbol get symbol => _symbol;
  BoundExpression get expr => _expr;

  @override
  BoundNodeKind get kind => BoundNodeKind.assignmentExpression;

  @override
  Type get type => expr.type;
}