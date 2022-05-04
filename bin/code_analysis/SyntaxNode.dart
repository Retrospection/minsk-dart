

import 'SyntaxKind.dart';

abstract class SyntaxNode {
  SyntaxKind get kind;

  Iterable<SyntaxNode> getChildren() {
    return Iterable.empty();
  }
}