part of queue;

abstract class IQueuable<T> {
  List<T> enqueue(T value);
  T dequeue();
  List<T> getQueue();
  int size();
  bool isNotEmpty();
}
