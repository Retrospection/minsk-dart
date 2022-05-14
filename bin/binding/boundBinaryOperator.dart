

import '../code_analysis/SyntaxKind.dart';
import 'boundBinaryOperatorKind.dart';

class BoundBinaryOperator {
  final Type _leftType;
  final Type _rightType;
  final Type _type;
  final SyntaxKind _syntaxKind;
  final BoundBinaryOperatorKind _kind;

  BoundBinaryOperator(this._leftType, this._rightType, this._type, this._syntaxKind, this._kind);

  BoundBinaryOperator.common(SyntaxKind syntaxKind, BoundBinaryOperatorKind kind, Type type)
    :this(type, type, type, syntaxKind, kind);

  Type get leftType => _leftType;
  Type get rightType => _rightType;
  Type get type => _type;
  SyntaxKind get syntaxKind => _syntaxKind;
  BoundBinaryOperatorKind get kind => _kind;

  static BoundBinaryOperator? bind(SyntaxKind kind, Type leftType, Type rightType) {
    for (var op in _binaryOperators) {
      if (kind == op.syntaxKind && op.leftType == leftType && op.rightType == rightType) {
        return op;
      }
    }

    return null;
  }

  static final List<BoundBinaryOperator> _binaryOperators = [
    BoundBinaryOperator.common(SyntaxKind.plusToken, BoundBinaryOperatorKind.addition, int),
    BoundBinaryOperator.common(SyntaxKind.minusToken, BoundBinaryOperatorKind.subtraction, int),
    BoundBinaryOperator.common(SyntaxKind.starToken, BoundBinaryOperatorKind.multiplication, int),
    BoundBinaryOperator.common(SyntaxKind.slashToken, BoundBinaryOperatorKind.division, int),
    BoundBinaryOperator.common(SyntaxKind.ampersandAmpersandToken, BoundBinaryOperatorKind.logicalAnd, bool),
    BoundBinaryOperator.common(SyntaxKind.pipePipeToken, BoundBinaryOperatorKind.logicalOr, bool),
  ];
}