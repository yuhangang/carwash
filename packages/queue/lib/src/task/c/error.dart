part of queue;

class EmptyQueueError extends StateError {
  EmptyQueueError() : super('Queue is Empty!');
}
