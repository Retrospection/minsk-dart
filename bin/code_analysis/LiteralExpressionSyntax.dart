

import 'ExpressionSyntax.dart';
import 'SyntaxKind.dart';
import 'SyntaxNode.dart';
import 'Token.dart';

class LiteralExpressionSyntax extends ExpressionSyntax {
  final Object _value;
  final Token _token;

  LiteralExpressionSyntax(this._value, this._token);

  @override
  SyntaxKind get kind => SyntaxKind.literalExpressionSyntax;
  Object get value => _value;
  Token get token => _token;

  @override
  Iterable<SyntaxNode> getChildren() sync* {
    yield _token;
  }
}