class ToDoList {
  // all vals would come from database
  String title = ""; //title of note
  List<String> items = []; //individual list items in the note
  List<bool?> checked = []; //if individual list item is checked or not

  // might have to change constructor depending on database
  ToDoList(this.title);

  void addItem(String text) {
    items.add(text);
    checked.add(false);
  }

  void removeItem(int index) {
    items.removeAt(index);
    checked.removeAt(index);
  }

  ToDoList.hasAll(this.title, this.items, this.checked);
}
