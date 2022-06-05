

import 'ExpressionSyntax.dart';
import 'SyntaxKind.dart';
import 'SyntaxNode.dart';
import 'Token.dart';

class AssignmentExpressionSyntax extends ExpressionSyntax {
  final Token _identifier;
  final Token _equalsToken;
  final ExpressionSyntax _expr;

  AssignmentExpressionSyntax(this._identifier, this._equalsToken, this._expr);

  @override
  SyntaxKind get kind => SyntaxKind.assignmentExpressionSyntax;
  Token get identifier => _identifier;
  Token get equalsToken => _equalsToken;
  ExpressionSyntax get expr => _expr;

  @override
  Iterable<SyntaxNode> getChildren() sync* {
    yield _identifier;
    yield _equalsToken;
    yield _expr;
  }
}