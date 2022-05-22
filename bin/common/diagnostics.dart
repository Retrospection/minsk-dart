import '../code_analysis/SyntaxKind.dart';
import './textSpan.dart';


class Diagnostic {
  TextSpan _textSpan;
  String _message;

  Diagnostic(this._textSpan, this._message);

  @override
  String toString() {
    return _message;
  }

  TextSpan get textSpan => _textSpan;
  String get message => _message;
}

class DiagnosticBag {
  List<Diagnostic> _diagnostics = List.empty(growable: true);

  Iterable<Diagnostic> get diagnostics => _diagnostics;

  void batchAdd(Iterable<Diagnostic> diagnostics) {
    _diagnostics.addAll(diagnostics);
  }

  // 词法分析错误
  void reportBadCharacter(TextSpan span, String? ch) {
    var message = 'ERROR: bad character input: ${ch!}';
    report(span, message);
  }

  // 语法分析错误
  void reportUnexpectedToken(TextSpan span, SyntaxKind actual, SyntaxKind expected) {
    var message = "Unexpected token <${actual}>, expected <${expected}>.";
    report(span, message);
  }

  // 单目运算符类型错误
  void reportUndefinedUnaryOperator(TextSpan span, String operatorText, Type operandType) {
    var message = "Unary operator '${operatorText}' is not defined for type ${operandType}.";
    report(span, message);
  }

  void reportUndefinedBinaryOperator(TextSpan span, String operatorText, Type leftType, Type rightType) {
    var message = "Binary operator '${operatorText}' is not defined for types ${leftType} and ${rightType}.";
    report(span, message);
  }


  void report(TextSpan span, String message) {
    _diagnostics.add(Diagnostic(span, message));
  }
}