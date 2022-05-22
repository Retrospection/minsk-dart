

import '../common/diagnostics.dart';
import 'SyntaxNode.dart';
import 'Token.dart';
import 'parser.dart';

class SyntaxTree {
  SyntaxNode _root;
  final Iterable<Diagnostic> _diagnostics;
  Token _eofToken;


  SyntaxTree(this._diagnostics, this._root, this._eofToken);

  Iterable<Diagnostic> get diagnostic => _diagnostics;
  SyntaxNode get root => _root;
  Token get eofToken => _eofToken;

  static SyntaxTree parse(String text) {
    var parser = new Parser(text);
    return parser.parse();
  }
}