import 'package:json_loader/json_loader.dart';

void main() async {

  // string
  var jl1 = JsonLoader();
  var result1 = await jl1.parseWithString('{"name": "john"}');
  print('name: ${result1['name']}');// => 'name: john'

  // path
  var jl2 = JsonLoader();
  var result2 = await jl2.parseWithPath('example/test.json');
  print('s34: ${result2['s34']}');// => 's34: hello'

}
