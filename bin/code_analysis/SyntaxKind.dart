
enum SyntaxKind  {
  badToken,
  eofToken,
  whitespaceToken,

  numberToken,
  plusToken,
  minusToken,
  starToken,
  slashToken,
  openParenthesisToken,
  closeParenthesisToken,

  literalExpressionSyntax,
  unaryExpressionSyntax,
  binaryExpressionSyntax,
}

extension OperatorPriority on SyntaxKind {
  int getUnaryOperatorPriority() {
    switch (this) {
      case SyntaxKind.plusToken:
      case SyntaxKind.minusToken:
        return 3;
      default:
        return 0;
    }
  }

  int getBinaryOperatorPriority() {
    switch (this) {
      case SyntaxKind.starToken:
      case SyntaxKind.slashToken:
        return 2;
      case SyntaxKind.plusToken:
      case SyntaxKind.minusToken:
        return 1;
      default:
        return 0;
    }
  }
}



