import 'dart:core';

import 'package:json_loader/src/type.dart';

class Lexer {
  int offset = 0;
  String original = '';

  void _moveForward() {
    offset++;
  }

  String _get() {
    var r = original.runes.elementAt(offset);
    var s = String.fromCharCodes([r]);
    return s;
  }

  bool _isEof() {
    return original.length <= offset;
  }

  // void set_data(String origin) {
  //   original = origin;
  // }

  List<Token> lex(String origin) {
    List<Token> tokens = [];

    original = origin;
    while (!_isEof()) {
      var char = _get();

      // NUMBER
      if ('1234567890'.contains(char)) {
        tokens.add(Token(TokenType.NUMBER, char));
      }
      // DOT
      else if ('.' == char) {
        tokens.add(Token(TokenType.DOT, char));
      }
      // COMMA
      else if (',' == char) {
        tokens.add(Token(TokenType.COMMA, char));
      }
      // COLON
      else if (':' == char) {
        tokens.add(Token(TokenType.COLON, char));
      }
      // SLASH
      else if ('/' == char) {
        tokens.add(Token(TokenType.SLASH, char));
      }
      // HYPHEN
      else if ('-' == char) {
        tokens.add(Token(TokenType.HYPHEN, char));
      }
      // LC_BRACKET {
      else if ('{' == char) {
        tokens.add(Token(TokenType.LC_BRACKET, char));
      }
      // RC_BRACKET }
      else if ('}' == char) {
        tokens.add(Token(TokenType.RC_BRACKET, char));
      }
      // LS_BRACKET [
      else if ('[' == char) {
        tokens.add(Token(TokenType.LS_BRACKET, char));
      }
      // RS_BRACKET ]
      else if (']' == char) {
        tokens.add(Token(TokenType.RS_BRACKET, char));
      }
      // D_QUOTATION "
      else if ('\"' == char) {
        tokens.add(Token(TokenType.D_QUOTATION, char));
      }
      // S_QUOTATION '
      else if ('\'' == char) {
        tokens.add(Token(TokenType.S_QUOTATION, char));
      }
      // NEWLINE
      else if ('\n' == char) {
        tokens.add(Token(TokenType.NEWLINE, char));
      }
      // TAB
      else if ('\t' == char) {
        tokens.add(Token(TokenType.TAB, char));
      }
      // WHITESPACE
      else if (' ' == char) {
        tokens.add(Token(TokenType.WHITESPACE, char));
      }

      // LETTER
      else {
        tokens.add(Token(TokenType.LETTER, char));
      }

      _moveForward();

    }
    return tokens;

  }
}