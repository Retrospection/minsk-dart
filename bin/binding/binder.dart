

import '../code_analysis/BinaryExpressionSyntax.dart';
import '../code_analysis/ExpressionSyntax.dart';
import '../code_analysis/LiteralExpressionSyntax.dart';
import '../code_analysis/SyntaxKind.dart';
import '../code_analysis/UnaryExpressionSyntax.dart';
import 'boundBinaryExpression.dart';
import 'boundBinaryOperator.dart';
import 'boundExpression.dart';
import 'boundLiteralExpression.dart';
import 'boundUnaryExpression.dart';
import 'boundUnaryOperator.dart';

class Binder {
  final List<String> _diagnostics = List.empty(growable: true);

  Iterator<String> get diagnostics => _diagnostics.iterator;

  BoundExpression bindExpression(ExpressionSyntax syntax) {
    switch (syntax.kind)
    {
      case SyntaxKind.literalExpressionSyntax:
        return bindLiteralExpression(syntax as LiteralExpressionSyntax);
      case SyntaxKind.unaryExpressionSyntax:
        return bindUnaryExpression(syntax as UnaryExpressionSyntax);
      case SyntaxKind.binaryExpressionSyntax:
        return bindBinaryExpression(syntax as BinaryExpressionSyntax);
      default:
        throw Exception("Unexpected syntax ${syntax.kind}");
    }
  }

  BoundLiteralExpression bindLiteralExpression(LiteralExpressionSyntax syntax) {
    return BoundLiteralExpression(syntax.value);
  }

  BoundUnaryExpression bindUnaryExpression(UnaryExpressionSyntax syntax) {
    var operator = BoundUnaryOperator.bind(syntax.kind, syntax.operand.runtimeType);
    if (operator == null) {
      _diagnostics.add('ERROR: Unsupported unary operator kind: ${syntax.kind}, operand type: ${syntax.operand.runtimeType}');
    }
    var operand = bindExpression(syntax);
    return BoundUnaryExpression(operator!, operand);
  }

  BoundBinaryExpression bindBinaryExpression(BinaryExpressionSyntax syntax) {
    var left = bindExpression(syntax.left);
    var right = bindExpression(syntax.right);
    var operator = BoundBinaryOperator.bind(syntax.operator.kind, left.type, right.type);

    if (operator == null) {
      _diagnostics.add('ERROR: Unsupported binary operator ${syntax.kind} with type ${left.type} and type ${right.type}');
    }

    return BoundBinaryExpression(left, operator!, right);
  }
}
























