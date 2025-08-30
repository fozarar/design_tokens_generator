import 'package:flutter_test/flutter_test.dart';

import 'package:design_tokens_generator/design_tokens_generator.dart';

void main() {
  group('Design Tokens Generator', () {
    test('should be able to create DesignTokenGenerator instance', () {
      final generator = DesignTokenGenerator(
        assetsPath: 'test/assets',
        outputPath: 'test/output',
      );

      expect(generator, isNotNull);
    });
  });
}
