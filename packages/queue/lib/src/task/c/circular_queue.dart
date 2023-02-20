part of queue;

class CircularQueue<T> implements IQueuable<T> {
  INode<T>? _front;
  INode<T>? _rear;
  int _count = 0;

  @override
  List<T> enqueue(T value) {
    final newNode = Node.create(value);

    if (_rear == null) {
      _front = newNode;
      _rear = newNode;
      newNode.setNext(_front!);
    } else {
      _rear!.setNext(newNode);
      _rear = newNode;
      if (_front != null) _rear!.setNext(_front!);
    }

    _count++;

    return getQueue();
  }

  @override
  T dequeue() {
    if (!isNotEmpty()) {
      throw EmptyQueueError();
    }

    final dequeued = _front!.value;

    if (_front == _rear) {
      _front = null;
      _rear = null;
    } else {
      _front = _front!.getNext();
      if (_front != null) _rear!.setNext(_front!);
    }

    _count--;

    return dequeued;
  }

  @override
  List<T> getQueue() {
    List<T> queue = [];

    if (_front == null) {
      return queue;
    }

    INode<T>? current = _front;

    do {
      queue.add(current!.value);
      current = current.getNext();
    } while (current != _front);

    return queue;
  }

  @override
  int size() {
    return _count;
  }

  @override
  bool isNotEmpty() {
    return size() > 0;
  }

  @override
  String toString() {
    return "CircularQueue(${getQueue().join(" -> ")})";
  }
}
