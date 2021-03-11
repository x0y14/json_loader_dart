enum PathType {
  FILE,
  DIR,
  NOTFOUND
}

enum TokenType {
  // SYMBOL,// ?!@#$#$$%
  NUMBER,// 1234
  DOT,// .
  COMMA,// ,
  COLON,// :
  SLASH,// /
  HYPHEN,// -
  LETTER,// abcあいう
  LC_BRACKET,// {
  RC_BRACKET,// }
  LS_BRACKET, // [
  RS_BRACKET, // ]
  D_QUOTATION,// "
  S_QUOTATION,// '
  NEWLINE,// \n
  TAB,// \t
  WHITESPACE,// " "
}

class Token {
  final TokenType type;
  final String data;
  const Token(this.type, this.data);
}