part of queue;

abstract class INode<T> {
  T get value;
  void setNext(INode<T> node);
  INode<T>? getNext();
}

// 4. Used a factory method to create Node objects
class Node<T> implements INode<T> {
  final T _value;
  INode<T>? _next;

  Node(this._value);

  @override
  T get value => _value;

  @override
  void setNext(INode<T> node) {
    _next = node;
  }

  @override
  INode<T>? getNext() {
    return _next;
  }

  static Node<T> create<T>(T value) {
    return Node(value);
  }
}
