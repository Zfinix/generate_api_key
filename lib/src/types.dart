// ignore_for_file: public_member_api_docs

/// Generation methods for key/token generation.
enum GenerationMethod {
  string,
  bytes,
  base32,
  base62,
  uuidv4,
  uuidv5,
}

base class BaseGenerationOptions {
  const BaseGenerationOptions();
}

final class StringGenerationOptions extends BaseGenerationOptions {
  const StringGenerationOptions({
    this.min,
    this.max,
    this.length,
    this.pool,
  });

  final int? min;
  final int? max;
  final int? length;
  final String? pool;
}

/// Generation options for the "bytes" method.
final class BytesGenerationOptions extends BaseGenerationOptions {
  const BytesGenerationOptions({
    this.min,
    this.max,
    this.length,
  });

  final int? min;
  final int? max;
  final int? length;
}

/// Generation options for the "base62" method.
final class Base62GenerationOptions extends BaseGenerationOptions {
  const Base62GenerationOptions();
}

/// Generation options for the "base32" method.
final class Base32GenerationOptions extends BaseGenerationOptions {
  const Base32GenerationOptions({
    this.dashes = true,
  });

  final bool dashes;
}

/// Generation options for the "uuidv4" method.

final class UuidV4GenerationOptions extends BaseGenerationOptions {
  const UuidV4GenerationOptions({
    this.dashes = true,
  });

  final bool dashes;
}

/// Generation options for the "uuidv5" method.
final class UuidV5GenerationOptions extends BaseGenerationOptions {
  const UuidV5GenerationOptions({
    required this.namespace,
    this.dashes = true,
    this.name,
  });

  final bool dashes;
  final String? name;
  final String namespace;
}

/// Default generation options.
typedef DefaultGenerationOptions = ({
  int? min,
  int? max,
  String? pool,
  bool? dashes,
});
