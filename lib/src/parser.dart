import 'package:json_loader/src/type.dart';
import 'package:string2int/string2int.dart';

class Parser {
  int offset = 0;
  List<Token> tokens = [];

  void _moveForward() {
    offset++;
  }

  Token _get() {
    var t = tokens.elementAt(offset);
    return t;
  }

  bool _isEof() {
    return tokens.length <= offset;
  }

  void cleanWhiteSpace() {
    while (!_isEof()) {
      var c = _get();
      if (c.type == TokenType.WHITESPACE||
          c.type == TokenType.TAB||
          c.type == TokenType.NEWLINE) {
        _moveForward();
      }

      else {
        break;
      }
    }
    return;
  }

  num consumeNumbers() {
    var raw = '';
    var allows = [TokenType.NUMBER, TokenType.HYPHEN, TokenType.DOT];

    while (!_isEof()) {
      var c = _get();
      if (allows.contains(c.type)) {
        raw += c.data;
        _moveForward();
      }
      else {
        break;
      }
    }
    return String2Int(raw).calc();
  }

  List<dynamic> _analyzeList() {
    // [
    _moveForward();
    var result = [];

    while (!_isEof()) {
      // 終わり
      cleanWhiteSpace();
      if (_get().type == TokenType.RS_BRACKET) {
        // ]
        _moveForward();
        break;
      }
      result.add(_analyzeValue());
      cleanWhiteSpace();
      if (_get().type == TokenType.COMMA) {
        // ,
        _moveForward();
        continue;
      }
    }

    return result;
  }

  dynamic _analyzeKeyword() {
    var b = '';
    while (!_isEof()) {
      var c = _get();
      if (c.type == TokenType.LETTER) {
        b += c.data;
        _moveForward();
      }
      else {
        break;
      }
    }

    switch (b) {
      case 'true': {
        return true;
      }
      case 'false': {
        return false;
      }
      case 'null': {
        return null;
      }
      default: {
        throw Exception('Unknown Keyword');
      }

    }


  }

  dynamic _analyzeValue() {
    // var value = '';

    while (!_isEof()) {
      cleanWhiteSpace();
      var c = _get();
      // 数値
      if (c.type == TokenType.NUMBER || c.type == TokenType.HYPHEN){
        return consumeNumbers();
      }
      // 文字列
      else if (c.type == TokenType.S_QUOTATION || c.type == TokenType.D_QUOTATION) {
        return _analyzeKey();
      }
      // 辞書in辞書
      else if (c.type == TokenType.LC_BRACKET) {
        return parse();
      }
      // true, false, null
      else if ('tfn'.contains(c.data)) {
        return _analyzeKeyword();
      }
      // List
      else if (c.type == TokenType.LS_BRACKET) {
        return _analyzeList();
      }

    }

    return {};
  }

  String _analyzeKey() {
    bool single_q;

    var char = _get();
    assert(char.type == TokenType.S_QUOTATION || char.type == TokenType.D_QUOTATION);
    if (char.type == TokenType.S_QUOTATION) {
      single_q = true;
    }
    else {
      single_q = false;
    }
    _moveForward();

    var key = '';

    while (!_isEof()) {
      var c = _get();
      if (c.type == TokenType.S_QUOTATION) {
        if (single_q == true) {
          _moveForward();
          return key;
        }
        else {
          key += c.data;
        }
      }
      else if (c.type == TokenType.D_QUOTATION) {
        if (single_q == false) {
          _moveForward();
          return key;
        }
        else {
          key += c.data;
        }
      }
      else {
        key += c.data;
      }
      _moveForward();
    }

    return key;
  }

  void set(List<Token> tks) {
    tokens = tks;
  }

  Map parse() {
    var result = {};

    while (!_isEof()) {
      cleanWhiteSpace();
      // print('${_get().type}');


      // {
      if (_get().type == TokenType.LC_BRACKET) {
        _moveForward();
      }
      cleanWhiteSpace();
      // }
      if (_get().type == TokenType.RC_BRACKET) {
        _moveForward();
        break;
      }
      // {       "key"
      cleanWhiteSpace();
      String  key;
      var char = _get();
      if (char.type == TokenType.S_QUOTATION || char.type == TokenType.D_QUOTATION) {
        key = _analyzeKey();
      }
      if (key == '') {
        throw Exception('key is empty');
      }
      // print('key: $key');

      // "key"   :
      cleanWhiteSpace();
      dynamic value;
      assert(_get().type == TokenType.COLON);
      _moveForward();
      value = _analyzeValue();
      cleanWhiteSpace();
      // print('value: $value(${value.runtimeType})');
      // value == ''でもok

      result[key] = value;

      if (_get().type == TokenType.COMMA) {
        _moveForward();
        cleanWhiteSpace();
        continue;
      }
    }

    return result;
  }
}