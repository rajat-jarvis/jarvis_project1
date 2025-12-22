import 'package:get/get.dart';
import '../model/model_class.dart';

class EditableTextController extends GetxController {
  var texts = <EditableTextItem>[].obs;
  var selectedIndex = RxnInt();

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
    texts.removeAt(selectedIndex.value!);
    selectedIndex.value = null;
  }
}




