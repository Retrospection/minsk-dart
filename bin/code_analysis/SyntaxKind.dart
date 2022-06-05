
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
  ampersandAmpersandToken,
  pipePipeToken,
  equalsEqualsToken,
  bangEqualsToken,
  equalsToken,
  bangToken,
  trueKeyword,
  falseKeyword,

  identifierToken,

  literalExpressionSyntax,
  unaryExpressionSyntax,
  binaryExpressionSyntax,
  parenthesisExpressionSyntax,
  assignmentExpressionSyntax,
}

extension OperatorPriority on SyntaxKind {
  int getUnaryOperatorPriority() {
    switch (this) {
      case SyntaxKind.plusToken:
      case SyntaxKind.minusToken:
      case SyntaxKind.bangToken:
        return 6;
      default:
        return 0;
    }
  }

  int getBinaryOperatorPriority() {
    switch (this) {
      case SyntaxKind.starToken:
      case SyntaxKind.slashToken:
        return 5;
      case SyntaxKind.plusToken:
      case SyntaxKind.minusToken:
        return 4;
      case SyntaxKind.equalsEqualsToken:
      case SyntaxKind.bangEqualsToken:
        return 3;
      case SyntaxKind.ampersandAmpersandToken:
        return 2;
      case SyntaxKind.pipePipeToken:
        return 1;
      default:
        return 0;
    }
  }
}



