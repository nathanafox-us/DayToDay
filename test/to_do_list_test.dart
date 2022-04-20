import 'package:flutter_test/flutter_test.dart';
import 'package:day_to_day/to_do_list.dart';

void main() {
  test('The to do list has the same number of items and checked attributes',
      () {
    ToDoList list = ToDoList("test");
    expect(list.checked.length, list.items.length);
  });
}
