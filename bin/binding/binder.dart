

import 'dart:collection';

import '../code_analysis/AssignmentExpressionSyntax.dart';
import '../code_analysis/BinaryExpressionSyntax.dart';
import '../code_analysis/ExpressionSyntax.dart';
import '../code_analysis/LiteralExpressionSyntax.dart';
import '../code_analysis/ParenthesisedExpressionSyntax.dart';
import '../code_analysis/SyntaxKind.dart';
import '../code_analysis/UnaryExpressionSyntax.dart';
import '../code_analysis/VariableSymbol.dart';
import '../common/diagnostics.dart';
import 'boundAssignmentExpression.dart';
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

  final HashMap<VariableSymbol, Object?> _symbols;

  Binder(this._symbols);

  BoundExpression bindExpression(ExpressionSyntax syntax) {
    switch (syntax.kind)
    {
      case SyntaxKind.assignmentExpressionSyntax:
        return bindAssignmentExpression(syntax as AssignmentExpressionSyntax);
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


  BoundExpression bindAssignmentExpression(AssignmentExpressionSyntax syntax) {
    var name = syntax.identifier.text;
    var boundExpression = bindExpression(syntax.expr);
    var currentSymbolMaybeSameName = _symbols.keys.where((el) => el.name == name);
    if (currentSymbolMaybeSameName.isNotEmpty) {
      _symbols.remove(currentSymbolMaybeSameName.first);
    }

    var variable = VariableSymbol(name, syntax.expr.runtimeType);
    _symbols[variable] = null;
    return BoundAssignmentExpression(variable, boundExpression);

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

























