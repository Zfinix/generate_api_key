// ignore_for_file: prefer_const_constructors, cascade_invocations
import 'package:generate_api_key/generate_api_key.dart';
import 'package:test/test.dart';

void main() {
  group('GenerateApiKey', () {
    test('can be instantiated', () {
      expect(GenerateApiKey(), isNotNull);
    });

    group('GenerateApiKey Single Test', () {
      test('Bytes API Key Length and Format', () {
        const length = 16; // Specify the desired length
        final generator = GenerateApiKey(
          options: BytesGenerationOptions(
            length: length,
          ),
        );
        final result = generator.generateApiKey();

        result.when(
          string: (String string) {
            // Check if the length matches the expected length
            expect(string.length, length);

            // Regular expression to match a hexadecimal string
            expect(string, matches(RegExp(r'^[0-9a-fA-F]+$')));
          },
          batch: (List<String> batch) {
            fail('Expected a single API key, got a batch');
          },
        );
      });

      test('Random String API Key Generation', () {
        final generator = GenerateApiKey(
          options: StringGenerationOptions(
            length: 20,
          ),
        );
        final result = generator.generateApiKey();

        result.when(
          string: (String string) {
            expect(string, isA<String>());
            expect(string.length, equals(20));
          },
          batch: (List<String> batch) {
            fail('Expected a single API key, got a batch');
          },
        );
      });

      test('Base62 API Key Format', () {
        final generator = GenerateApiKey(
          options: Base62GenerationOptions(),
        );

        final result = generator.generateApiKey();

        result.when(
          string: (String string) {
            expect(
              string,
              matches(
                RegExp(r'^[0-9A-Za-z]+$'),
              ),
            ); // Base62 format (alphanumeric characters)
          },
          batch: (List<String> batch) {
            fail('Expected a single API key, got a batch');
          },
        );
      });

      test('UUID v4 API Key Generation', () {
        final uuidGenerator = GenerateApiKey(
          options: UuidV4GenerationOptions(
            dashes: false,
          ),
        );

        final result = uuidGenerator.generateApiKey();

        result.when(
          string: (String string) {
            expect(string, isA<String>());
            // Add more assertions for UUID v4 format
          },
          batch: (List<String> batch) {
            fail('Expected a single API key, got a batch');
          },
        );
      });

      test('UUID v5 API Key Generation single', () {
        const uuidGenerator = GenerateApiKey(
          prefix: 'prod_app',
          options: UuidV5GenerationOptions(
            namespace: '596ac0ae-c4a0-4803-b796-8f239c8431ba',
            name: 'example',
          ),
        );

        final result = uuidGenerator.generateApiKey();

        result.when(
          string: (String string) {
            expect(string, isA<String>());
            expect(string, 'prod_app.5abd62a0-c40c-5d1f-a6b8-536624f5bf7f');
            // Add more assertions for UUID v4 format
          },
          batch: (List<String> batch) {
            fail('Expected a single API key, got a batch');
          },
        );
      });
    });

    group('GenerateApiKey Batch Tests', () {
      test(
        'Batch API Key Generation',
        () {
          final batchGenerator = GenerateApiKey(
            options: Base32GenerationOptions(),
            batch: 10,
          );
          final result = batchGenerator.generateApiKey();

          result.when(
            string: (String string) {
              fail('Expected a batch of API keys, got a single key');
            },
            batch: (List<String> batch) {
              expect(batch, isA<List<String>>());
              expect(batch, hasLength(10));
            },
          );
        },
      );

      test('UUID v5 API Key Generation batch', () {
        const uuidGenerator = GenerateApiKey(
          prefix: 'prod_app',
          options: UuidV5GenerationOptions(
            namespace: '596ac0ae-c4a0-4803-b796-8f239c8431ba',
            name: 'example',
          ),
          batch: 5,
        );

        final result = uuidGenerator.generateApiKey();

        result.when(
          string: (String string) {
            fail('Expected a batch of API keys, got a single key');

            // Add more assertions for UUID v4 format
          },
          batch: (List<String> batch) {
            expect(batch, isA<List<String>>());
            expect(batch, hasLength(5));
            expect(batch.first.contains('prod_app.'), true);
          },
        );
      });

      test('UuidV5GenerationOptions with Invalid UUID Namespace', () {
        expect(
          () => GenerateApiKey(
            options: UuidV5GenerationOptions(
              namespace: 'invalid-uuid',
              name: 'test',
            ),
          ).generateApiKey(),
          throwsA(isA<Exception>()),
        );
      });

      test('Invalid Batch Size (Negative Number)', () {
        expect(
          () => GenerateApiKey(
            options: StringGenerationOptions(),
            batch: -1,
          ).generateApiKey(),
          throwsA(isA<Exception>()),
        );
      });

      test('Invalid Batch Size (Zero)', () {
        expect(
          () => GenerateApiKey(
            options: StringGenerationOptions(),
            batch: 0,
          ).generateApiKey(),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
