class ToDoList {
  // all vals would come from database
  String title = ""; //title of note
  List<String> items = []; //individual list items in the note
  List<bool?> checked = []; //if individual list item is checked or not

  // might have to change constructor depending on database
  ToDoList(this.title) {
    items.add("Title is \"$title\"");
    checked.add(false);
    for (int j = 0; j < 10; j++) {
      items.add("Item $j");
      checked.add(false);
    }
  }
}
