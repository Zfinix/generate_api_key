// ignore_for_file: public_member_api_docs, only_throw_errors

import 'dart:math';
import 'dart:typed_data';

import 'package:base32/base32.dart';
import 'package:base32/encodings.dart';
import 'package:base_x/base_x.dart';
import 'package:generate_api_key/generate_api_key.dart';
import 'package:generate_api_key/src/constants.dart';
import 'package:uuid/data.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/validation.dart';

part 'utils.dart';

class GenerateApiKey {
  const GenerateApiKey({
    this.options = const StringGenerationOptions(),
    this.prefix,
    this.batch,
  });

  ///
  final String? prefix;

  ///
  final int? batch;

  ///
  final BaseGenerationOptions options;

  ApiKeyResults generateApiKey() {
    // Check for batch generation.

    if (batch != null && !_isNaturalNum(batch!)) {
      throw Exception('The `batch` option must be a natural number > 0.');
    }

    if (batch != null && batch! <= 0) {
      throw Exception('The `batch` option must be a natural number > 0.');
    }

    String apiKey() => switch (options) {
          BytesGenerationOptions() => _getCryptoApiKey(
              options: options as BytesGenerationOptions,
            ),
          Base32GenerationOptions() => _getBase32CrockfordApiKey(
              options: options as Base32GenerationOptions,
            ),
          Base62GenerationOptions() => _getBase62ApiKey(),
          UuidV4GenerationOptions() => _getUuidV4ApiKey(
              options: options as UuidV4GenerationOptions,
            ),
          UuidV5GenerationOptions() => _getUuidV5ApiKey(
              options: options as UuidV5GenerationOptions,
            ),
          _ => _getRandomStringApiKey(
              options: options as StringGenerationOptions,
            )
        };

    // Check for batch generation.
    if (batch != null) {
      // Generate the keys.
      final apiKeys = List.generate(
        batch!,
        (index) => prefix != null ? '$prefix.${apiKey()}' : apiKey(),
      );

      return BatchApiKeyResults(apiKeys);
    } else {
      // Generate the API key.
      // Add a prefix if necessary.
      return StringApiKeyResults(
        prefix != null ? '$prefix.${apiKey()}' : apiKey(),
      );
    }
  }

  String _getCryptoApiKey({
    required BytesGenerationOptions options,
  }) {
    // Determine the length for the key.
    final length = options.length ??
        generateNatural(
          min: options.min ?? DEFAULT_MIN_LENGTH,
          max: options.max ?? DEFAULT_MAX_LENGTH,
        );

    // Set the total bytes.
    final totalBytes = (length / 2).ceil();

    // Generate the API key.
    var apiKey = generateRandomBytes(totalBytes).toHexString();

    // Check the key length.
    if (apiKey.length > length) {
      final endIndex = apiKey.length - (apiKey.length - length);
      apiKey = apiKey.slice(0, endIndex);
    }

    return apiKey;
  }

  String _getRandomStringApiKey({
    required StringGenerationOptions options,
  }) {
    // Determine the length for the key.
    final length = options.length ??
        generateNatural(
          min: options.min ?? DEFAULT_MIN_LENGTH,
          max: options.max ?? DEFAULT_MAX_LENGTH,
        );

    // Generate the string.
    return generateRandomString(
      length: length,
      pool: options.pool ?? DEFAULT_CHARACTER_POOL,
    );
  }

  String _getBase32CrockfordApiKey({
    required Base32GenerationOptions options,
  }) {
    // Create the uuid options.
    final v4options = V4Options(generateRandomBytes(16), null);

    // Create a new UUID.
    final uuid = const Uuid().v4(config: v4options);

    // Split at the dashes.
    final uuidParts = uuid.split('-');

    // Convert the UUID into 4 equally separate parts.
    final partsArr = [
      uuidParts[0],
      '${uuidParts[1]}${uuidParts[2]}',
      '${uuidParts[3]}${uuidParts[4].substring(0, 4)}',
      uuidParts[4].substring(4),
    ];

    // Iterate through each part.
    final apiKeyArr = partsArr.map((value) {
      // Get every two characters.
      final valueArr =
          RegExp('.{1,2}').allMatches(value).map((m) => m.group(0)!).toList();

      // Convert each value into a number.
      final numArr = valueArr.map((item) => int.parse(item, radix: 16));

      // Create the string.
      return base32.encode(
        Uint8List.fromList(numArr.toList()),
        encoding: Encoding.crockford,
      );
    });

    // Check if we should add dashes.
    return (options.dashes) ? apiKeyArr.join('-') : apiKeyArr.join();
  }

  String _getBase62ApiKey() {
    // Set the encoding alphabet for Base62.
    final base62 = BaseXCodec(BASE62_CHAR_POOL);

    // Create the uuid options.
    final v4options = V4Options(generateRandomBytes(16), null);

    // Create a new UUID.
    final uuid = const Uuid().v4(config: v4options);

    // Create the UUID buffer.
    final uuidBuffer = _uuidToBuffer(uuid);

    // Generate the API key.
    return base62.encode(uuidBuffer);
  }

  String _getUuidV4ApiKey({
    required UuidV4GenerationOptions options,
  }) {
    // Create the uuid options.
    final v4options = V4Options(generateRandomBytes(16), null);

    // Generate the API key.
    final apiKey = const Uuid().v4(config: v4options);

    // Check if we should remove dashes.
    return (!options.dashes) ? apiKey.replaceAll('-', '') : apiKey;
  }

  String _getUuidV5ApiKey({
    required UuidV5GenerationOptions options,
  }) {
    if (batch == null) {
      if (!UuidValidation.isValidUUID(fromString: options.namespace)) {
        throw Exception(
          'The required `namespace` option must be a valid UUID.',
        );
      }
    }

    // Create the uuid options.
    final v4options = V4Options(generateRandomBytes(16), null);

    // Get the namespace. When using batch processing
    // create a namespace UUID. A namespace must be unique.
    final namespace =
        batch != null ? const Uuid().v4(config: v4options) : options.namespace;

    // Generate the API key.
    final apiKey = const Uuid().v5(
      namespace,
      options.name,
    );

    // Check if we should remove dashes.
    return (!options.dashes) ? apiKey.replaceAll('-', '') : apiKey;
  }
}
