

import '../code_analysis/SyntaxKind.dart';
import 'boundUnaryOperatorKind.dart';

class BoundUnaryOperator {
  final SyntaxKind _syntaxKind;
  final BoundUnaryOperatorKind _kind;
  final Type _operandType;
  final Type _type;

  BoundUnaryOperator(this._syntaxKind, this._kind, this._operandType, this._type);

  SyntaxKind get syntaxKind => _syntaxKind;
  BoundUnaryOperatorKind get kind => _kind;
  Type get operandType => _operandType;
  Type get type => _type;

  static BoundUnaryOperator? bind(SyntaxKind kind, Type operandType) {
    for (var op in _unaryOperators) {
      if (op.operandType == operandType && op.syntaxKind == kind) {
        return op;
      }
    }

    return null;
  }

  static final List<BoundUnaryOperator> _unaryOperators = [
    BoundUnaryOperator(SyntaxKind.plusToken, BoundUnaryOperatorKind.identity, int, int),
    BoundUnaryOperator(SyntaxKind.minusToken, BoundUnaryOperatorKind.negation, int, int),
    BoundUnaryOperator(SyntaxKind.bangToken, BoundUnaryOperatorKind.logicalNegation, int, int),
  ];
}