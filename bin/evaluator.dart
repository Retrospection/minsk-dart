

import 'binding/BoundNode.dart';
import 'binding/boundBinaryExpression.dart';
import 'binding/boundBinaryOperatorKind.dart';
import 'binding/boundExpression.dart';
import 'binding/boundLiteralExpression.dart';

class Evaluator {
  final BoundNode _root;

  Evaluator(this._root);

  BoundNode get root => _root;

  Object evaluate() {
    return _evaluateExpression(_root as BoundExpression);
  }

  Object _evaluateExpression(BoundExpression node) {
    if (node is BoundBinaryExpression) {
      return _evaluateBinaryExpressionExpression(node);
    }

    if (node is BoundLiteralExpression) {
      return node.value;
    }

    throw Exception('Unexpected node ${node.kind}');
  }

  Object _evaluateBinaryExpressionExpression(BoundBinaryExpression node) {
    var left = _evaluateExpression(node.left);
    var right = _evaluateExpression(node.right);

    switch (node.operator.kind) {
      case BoundBinaryOperatorKind.addition:
        return (left as int) + (right as int);
      case BoundBinaryOperatorKind.subtraction:
        return (left as int) - (right as int);
      case BoundBinaryOperatorKind.multiplication:
        return (left as int) * (right as int);
      case BoundBinaryOperatorKind.division:
        return (left as int) / (right as int);
      default:
        throw Exception("Unexpected binary operator ${node.kind}");
    }
  }


}