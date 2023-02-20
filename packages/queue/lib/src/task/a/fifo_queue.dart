import 'queuable.dart';

class FIFOQueue implements IQueuable {
  final List<String> _queue = [];

  FIFOQueue();

  @override
  List<String> enqueue(String value) {
    _queue.add(value);
    return _queue;
  }

  @override
  String dequeue() {
    if (_queue.isEmpty) throw StateError('Queue is empty!');
    return _queue.removeAt(0);
  }

  @override
  List<String> getQueue() {
    return _queue;
  }

  @override
  int size() => _queue.length;
}
