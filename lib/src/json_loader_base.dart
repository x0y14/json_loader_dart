// TODO: Put public facing types in this file.

export 'parser.dart';
export 'lexer.dart';
export 'loader.dart';
import 'package:json_loader/json_loader.dart';


class JsonLoader {
  final Lexer _lexer = Lexer();
  final Parser _parser = Parser();
  final Loader _loader = Loader();

  Future<Map> parseWithPath(String path) async {
    var fileData = await _loader.readFile(path);
    return await parseWithString(fileData);
  }

  Future<Map> parseWithString(String json) async {
    var tokens = _lexer.lex(json);
    _parser.set(tokens);
    var result = _parser.parse();
    return result;
  }


}
