

import '../code_analysis/BinaryExpressionSyntax.dart';
import '../code_analysis/ExpressionSyntax.dart';
import '../code_analysis/LiteralExpressionSyntax.dart';
import '../code_analysis/ParenthesisedExpressionSyntax.dart';
import '../code_analysis/SyntaxKind.dart';
import '../code_analysis/UnaryExpressionSyntax.dart';
import '../common/diagnostics.dart';
import 'boundBinaryExpression.dart';
import 'boundBinaryOperator.dart';
import 'boundExpression.dart';
import 'boundLiteralExpression.dart';
import 'boundUnaryExpression.dart';
import 'boundUnaryOperator.dart';
import 'boundParenthesisedExpression.dart';

class Binder {
  final DiagnosticBag _diagnostics = DiagnosticBag();

  Iterable<Diagnostic> get diagnostics => _diagnostics.diagnostics;

  BoundExpression bindExpression(ExpressionSyntax syntax) {
    switch (syntax.kind)
    {
      case SyntaxKind.literalExpressionSyntax:
        return bindLiteralExpression(syntax as LiteralExpressionSyntax);
      case SyntaxKind.unaryExpressionSyntax:
        return bindUnaryExpression(syntax as UnaryExpressionSyntax);
      case SyntaxKind.binaryExpressionSyntax:
        return bindBinaryExpression(syntax as BinaryExpressionSyntax);
      case SyntaxKind.parenthesisExpressionSyntax:
        return bindParenthesisExpression(syntax as ParenthesisedExpressionSyntax);
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
      _diagnostics.reportUndefinedUnaryOperator(syntax.operator.span, syntax.operator.text, syntax.operand.runtimeType);
    }
    var operand = bindExpression(syntax);
    return BoundUnaryExpression(operator!, operand);
  }

  BoundBinaryExpression bindBinaryExpression(BinaryExpressionSyntax syntax) {
    var left = bindExpression(syntax.left);
    var right = bindExpression(syntax.right);
    var operator = BoundBinaryOperator.bind(syntax.operator.kind, left.type, right.type);

    if (operator == null) {
      _diagnostics.reportUndefinedBinaryOperator(syntax.operator.span, syntax.operator.text, syntax.left.runtimeType, syntax.right.runtimeType);
    }

    return BoundBinaryExpression(left, operator!, right);
  }

  BoundParenthesisExpression bindParenthesisExpression(ParenthesisedExpressionSyntax syntax) {
    var expression = bindExpression(syntax.expression);
    return BoundParenthesisExpression(expression);
  }
}

























