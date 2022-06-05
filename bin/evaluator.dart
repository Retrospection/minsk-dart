

import 'dart:collection';

import 'binding/BoundNode.dart';
import 'binding/boundAssignmentExpression.dart';
import 'binding/boundBinaryExpression.dart';
import 'binding/boundBinaryOperatorKind.dart';
import 'binding/boundExpression.dart';
import 'binding/boundLiteralExpression.dart';
import 'binding/boundParenthesisedExpression.dart';
import 'code_analysis/VariableSymbol.dart';

class Evaluator {
  final BoundNode _root;
  final HashMap<VariableSymbol, Object?> _symbols;

  Evaluator(this._root, this._symbols);

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

    if (node is BoundParenthesisExpression) {
      return _evaluateExpression(node.expression);
    }

    if (node is BoundAssignmentExpression) {
      var value = _evaluateExpression(node.expr);
      _symbols[node.symbol] = value;
      return value;
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
      case BoundBinaryOperatorKind.logicalAnd:
        return (left as bool) && (right as bool);
      case BoundBinaryOperatorKind.logicalOr:
        return (left as bool) || (right as bool);
      default:
        throw Exception("Unexpected binary operator ${node.kind}");
    }
  }


}