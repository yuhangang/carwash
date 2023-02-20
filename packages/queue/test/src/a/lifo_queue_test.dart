import 'package:queue/src/task/a/lifo_queue.dart';
import 'package:test/test.dart';

main() {
  group('Testing FIFOQueue', () {
    test('Test enqueuing and dequeuing elements', () {
      final queue = LIFOQueue();
      queue.enqueue('apple');
      queue.enqueue('banana');
      queue.enqueue('cherry');
      expect(queue.size(), equals(3));
      expect(queue.getQueue(), ["apple", "banana", "cherry"]);

      expect(queue.dequeue(), equals('cherry'));
      expect(queue.size(), equals(2));
      expect(queue.getQueue(), [
        "apple",
        "banana",
      ]);

      expect(queue.dequeue(), equals('banana'));
      expect(queue.size(), equals(1));
      expect(queue.getQueue(), ["apple"]);

      expect(queue.dequeue(), equals('apple'));
      expect(queue.size(), equals(0));
      expect(queue.getQueue(), []);

      expect(
          () => queue.dequeue(),
          throwsA(isA<StateError>()
              .having((p0) => p0.message, '', 'Queue is empty!')));
    });
  });
}
