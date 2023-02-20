abstract class IQueuable {
  List<String> enqueue(String value);
  String dequeue();
  List<String> getQueue();
  int size();
}
