import 'package:flutter_test/flutter_test.dart';

import 'package:jio_leh/services/supabase/supabase_pin_service.dart';

void main() {
  group('isDuplicatePinError', () {
    test('a duplicate (23505) means the pin already exists', () {
      expect(isDuplicatePinError(errorCode: '23505'), isTrue);
    });

    test('any other error code is not a duplicate pin', () {
      expect(isDuplicatePinError(errorCode: '23503'), isFalse);
    });

    test('a null error code is not a duplicate pin', () {
      expect(isDuplicatePinError(errorCode: null), isFalse);
    });
  });
}
