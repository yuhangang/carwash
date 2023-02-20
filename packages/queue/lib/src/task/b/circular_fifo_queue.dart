import 'queuable.dart';
import 'node.dart';

class CircularFIFOQueue implements IQueuable {
  Node<String>? _front;
  Node<String>? _rear;
  int _count = 0;

  @override
  List<String> enqueue(String value) {
    Node<String> newNode = Node(value);

    if (_rear == null) {
      _front = newNode;
      _rear = newNode;
      newNode.next = _front;
      newNode.prev = _rear;
    } else {
      newNode.prev = _rear;
      _rear!.next = newNode;
      _rear = newNode;
      _rear!.next = _front;
      _front!.prev = _rear;
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
      _front!.prev = _rear;
      _rear!.next = _front;
    }

    _count--;

    return dequeued;
  }

  @override
  List<String> getQueue() {
    List<String> queue = [];

    if (_front == null) {
      return queue;
    }

    Node<String>? current = _front;

    do {
      queue.add(current!.value);
      current = current.next;
    } while (current != _front);

    return queue;
  }

  @override
  int size() {
    return _count;
  }
}
