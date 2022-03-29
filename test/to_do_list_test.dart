import 'package:flutter_test/flutter_test.dart';
import 'package:day_to_day/to_do_list.dart';

void main() {
  test('The to do list has the same number of items and checked attributes',
      () {
    ToDoList list = ToDoList("test");
    expect(list.checked.length, list.items.length);
  });

  test(
      'Add items to the to do list, checked length should increase with the item length',
      () {
    ToDoList list = ToDoList("test");

    for (int i = 0; i < 10; i++) {
      int itemsBefore = list.items.length;
      list.addItem("new item $i");
      int itemsAfter = list.items.length;
      expect(itemsBefore + 1, itemsAfter);
      expect(list.checked.length, list.items.length);
    }
  });
}
