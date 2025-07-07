import 'package:flutter_test/flutter_test.dart';
import 'package:meme_editor_app/core/error/failure.dart';

void main() {
  group('Failure equality', () {
    test('ServerFailure equality works', () {
      const failure1 = ServerFailure('Error');
      const failure2 = ServerFailure('Error');

      expect(failure1, failure2);
    });

    test('Diff messages Server Failure are not equal', () {
      const failure1 = ServerFailure('Error A');
      const failure2 = ServerFailure('Error B');

      expect(failure1, isNot(failure2));
    });

    test('Default message Permission Failure works', () {
      const failure = PermissionFailure();

      expect(
        failure.message,
        'Permission denied. Please allow application to access your storage',
      );
    });

    test('Custom message Permission Failure works', () {
      const failure = PermissionFailure('Message Test');

      expect(failure.message, 'Message Test');
    });
  });
}
