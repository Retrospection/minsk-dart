import 'dart:io';
import 'package:colorize/colorize.dart';
import 'binding/binder.dart';
import 'code_analysis/SyntaxNode.dart';
import 'code_analysis/Token.dart';
import 'code_analysis/parser.dart';
import 'evaluator.dart';



void main(List<String> arguments) {

  while (true) {
    stdout.write('> ');
    var input = stdin.readLineSync();
    if (input == null) {
      continue;
    }

    var parser = Parser(input);
    var tree = parser.parse();
    var binder = Binder();
    var boundedExpression = binder.bindExpression(tree);
    var evaluator = Evaluator(boundedExpression);
    if (parser.diagnostics.isEmpty) {
      prettyPrint(tree);
    } else {
      for (var diagnostic in parser.diagnostics) {
        printRed(diagnostic);
      }
    }
    print(evaluator.evaluate());
  }
}

void prettyPrint(SyntaxNode node, {String indent = "", bool isLast = true}) {
  var marker = isLast ? "└──" : "├──";

  printDarkGray(indent);
  printDarkGray(marker);
  printDarkGray(node.kind);

  
  if (node is Token && node.value != null) {
    printDarkGray(' ');
    assert(node.value != null);
    printDarkGray(node.value!);
  }

  stdout.writeln();

  indent += isLast ? "   " : "│   ";

  var lastChild = node.getChildren().isEmpty ? null : node.getChildren().last;

  for (var child in node.getChildren()) {
    prettyPrint(child, indent: indent, isLast: child == lastChild);
  }
}

void printDarkGray(Object obj) {
  stdout.write(Colorize(obj.toString()).darkGray());
}

void printRed(Object obj) {
  stdout.write(Colorize(obj.toString()).red());
}
