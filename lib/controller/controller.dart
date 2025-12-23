import 'package:get/get.dart';
import '../model/model_class.dart';

class EditableTextController extends GetxController {
  var texts = <EditableTextItem>[].obs;
  var selectedIndex = RxnInt();
  EditableTextItem? lastDeletedItem;
  int? lastDeletedIndex;

  void select(int index) {
    selectedIndex.value = index;
  }

  void deselect() {
    selectedIndex.value = null;
  }

  void addText(EditableTextItem item) {
    texts.add(item);
    selectedIndex.value = texts.length - 1;
  }

  void updatePosition(int index, double x, double y) {
    texts[index].x = x;
    texts[index].y = y;
    texts.refresh();
  }

  void deleteSelected() {
    if (selectedIndex.value == null) return;

    lastDeletedIndex = selectedIndex.value;
    lastDeletedItem = texts[lastDeletedIndex!];

    texts.removeAt(lastDeletedIndex!);
    selectedIndex.value = null;
  }

  void restoreLastDeleted() {
    if (lastDeletedItem == null || lastDeletedIndex == null) return;

    texts.insert(lastDeletedIndex!, lastDeletedItem!);

    selectedIndex.value = lastDeletedIndex;

    lastDeletedItem = null;
    lastDeletedIndex = null;
  }

  void submitText() {
    final List<Map<String, dynamic>> textDetails = texts
        .map((item) => item.toJson())
        .toList();

    print(textDetails);
  }
}
