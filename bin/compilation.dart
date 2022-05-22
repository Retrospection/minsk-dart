

import 'binding/binder.dart';
import 'code_analysis/ExpressionSyntax.dart';
import 'code_analysis/SyntaxTree.dart';
import 'common/diagnostics.dart';
import 'evaluator.dart';

class EvaluationResult {
  final Object _value;
  final DiagnosticBag _diagnostics;
  EvaluationResult(this._value, this._diagnostics);

  Object get value => _value;
  Iterable<Diagnostic> get diagnostic => _diagnostics.diagnostics;
}

class Compilation {
  final SyntaxTree _tree;

  Compilation(this._tree);

  EvaluationResult evaluate() {
    var binder = Binder();
    var boundedExpression = binder.bindExpression(_tree.root as ExpressionSyntax);
    var diagnostics = _tree.diagnostic.toList();
    diagnostics.addAll(binder.diagnostics);

    var evaluator = Evaluator(boundedExpression);
    var value = evaluator.evaluate();
    var diagnosticBag = DiagnosticBag();
    diagnosticBag.batchAdd(diagnostics);
    return EvaluationResult(value, diagnosticBag);
  }
}