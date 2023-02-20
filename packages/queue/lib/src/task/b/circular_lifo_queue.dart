import 'queuable.dart';
import 'node.dart';

class CircularLIFOQueue implements IQueuable {
  Node<String>? _front;
  Node<String>? _rear;
  int _count = 0;

  CircularLIFOQueue() {
    _count = 0;
  }

  @override
  List<String> enqueue(String value) {
    Node<String> newNode = Node(value);

    if (_front == null) {
      _front = newNode;
      _rear = newNode;
    } else {
      newNode.next = _front;
      _front!.prev = newNode;
      _front = newNode;
    }

    _count++;

    return getQueue();
  }

  @override
  String dequeue() {
    if (_count == 0) {
      throw StateError('Queue is empty!');
    }

    final dequeued = _front!.value;

    if (_front == _rear) {
      _front = null;
      _rear = null;
    } else {
      _front = _front!.next;
      _front!.prev = null;
    }

    _count--;

    return dequeued;
  }

  @override
  List<String> getQueue() {
    List<String> queue = [];

    if (_rear == null) {
      return queue;
    }

    Node<String>? current = _rear;

    while (current != null) {
      queue.add(current.value);
      current = current.prev;
    }

    return queue;
  }

  @override
  int size() {
    return _count;
  }
}
