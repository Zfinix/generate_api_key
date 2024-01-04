# Generate API Key

A Dart utility for generating various types of API keys including random strings, UUIDs, and keys based on specific encoding schemes like Base32 and Base62.

This library is a dart port of [generate_api_key][generate_api_key] npm package.

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

A Very Good Project created by Very Good CLI.

## Table of Contents

1. [Features](#features)
2. [Installation](#installation)
3. [Usage](#usage)
   - [Basic Usage](#basic-usage)
   - [Advanced Usage](#advanced-usage)
4. [Generation Options](#generation-options)
   - [String](#string)
   - [Bytes](#bytes)
   - [Base32](#base32)
   - [Base62](#base62)
   - [UuidV4](#uuidv4)
   - [UuidV5](#uuidv5)
5. [Examples](#examples)
6. [Error Handling](#error-handling)
7. [Security](#security)
8. [✨ Contribution](#contribution)

## Installation 💻

**❗ In order to start using Generate Api Key you must have the [Dart SDK][dart_install_link] installed on your machine.**

Install via `dart pub add`:

```sh
dart pub add generate_api_key
```

---

## Features

- Generate random string API keys.
- Generate UUID-based API keys (v4 and v5).
- Generate API keys using Base32 (Crockford's encoding) and Base62 encoding.
- Support for batch generation of API keys.
- Option to add a prefix to the generated API keys.
- Customizable key length and character pool for random string keys.

## Usage

To use this utility, import the package and create an instance of `GenerateApiKey` with the desired options which returns `ApiKeyResults`.

`ApiKeyResults` can be either `StringApiKeyResults` or `BatchApiKeyResults`, you might have something like this:

### Generation Options

The following table outlines the various `GenerationOptions` available, each suited for different API key generation methods:

| Option Class                | Description                                                                                                               |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| `StringGenerationOptions()` | Generates a random string API key. Allows specification of length and character pool.                                     |
| `BytesGenerationOptions()`  | Generates a key based on random bytes. Suitable for cryptographic purposes.                                               |
| `Base32GenerationOptions()` | Uses Base32 encoding to generate the API key. Can include options for Crockford's encoding and whether to include dashes. |
| `Base62GenerationOptions()` | Generates an API key using Base62 encoding. Ideal for compact, URL-safe keys.                                             |
| `UuidV4GenerationOptions()` | Creates a UUID version 4 based API key. Option to include or exclude dashes.                                              |
| `UuidV5GenerationOptions()` | Generates a UUID version 5 API key. Requires a namespace and a name. Also allows control over dashes.                     |

<br />

### Examples

Here's a basic example of generating a random string API key:

```dart
import 'package:generate_api_key/generate_api_key.dart';

void main() {
  const generator = GenerateApiKey(
    options: StringGenerationOptions(length: 20), // Set the desired length
  );

  final apiKey = generator.generateApiKey(); // Returns

  apiKey.when(
    string: (String value) {
      log(value);
    },
    batch: (List<String> batch) {
      print(batch);
    },
  );

  print(apiKey);
}
```

### Generation Option Examples

Each type of `GenerationOptions` can be used with the `GenerateApiKey` class to create API keys with different characteristics. Here are examples for each option:

#### String

Generates a random string API key.

```dart
  const generator = GenerateApiKey(
    prefix: 'pk',
    options: StringGenerationOptions(
      length: 20,
      pool: 'ABCDEFG1234567890',
    ),
  );

  final apiKey = generator.generateApiKey();
  print(apiKey); pk.ECCC9398D9G2D3G26A1F
```

#### Bytes

Generates an API key based on random bytes.

```dart
  const generator = GenerateApiKey(
    prefix: 'sk',
    options: BytesGenerationOptions(
      length: 20,
    ),
  );
  final apiKey = generator.generateApiKey();
  print(apiKey); // sk.3020e804ce9bd6d07ce1
```

#### Base32

Uses Base32 encoding to generate the API key.

```dart
  const generator = GenerateApiKey(
    options: Base32GenerationOptions(
      dashes: true, // Include dashes in the key
    ),
  );
  final apiKey = generator.generateApiKey();
  print(apiKey); // 5BWBHH0-ED4447R-M19N2ZR-7SNRCF0
```

#### Base62

Generates an API key using Base62 encoding.

```dart
  const generator = GenerateApiKey(
    options: Base62GenerationOptions(),
    prefix: 'lk',
  );
  final apiKey = generator.generateApiKey();
  print(apiKey); // lk.1BVCstg6fFVStHkaKG6vqB
```

#### UuidV4

Creates a UUID version 4 based API key.

```dart
  const generator = GenerateApiKey(
    prefix: 'key',
    options: UuidV4GenerationOptions(
      dashes: false, // Exclude dashes
    ),
  );
  final apiKey = generator.generateApiKey();
  print(apiKey); // key.9ccfa90e505341c9814d7e91a861b550
```

#### UuidV5

Generates a UUID version 5 API key.

```dart
  const generator = GenerateApiKey(
    prefix: 'prod_app',
    options: UuidV5GenerationOptions(
      namespace: '596ac0ae-c4a0-4803-b796-8f239c8431ba',
      name: 'example',
      dashes: true,
    ),
  );
  final apiKey = generator.generateApiKey();
  print(apiKey); // prod_app.5abd62a0-c40c-5d1f-a6b8-536624f5bf7f
```

### Advanced Usage

You can also generate API keys using other methods like UUID, Base32, and Base62, and customize options like key length, character pool, and whether to include dashes.

#### Batch Generation

```dart
  final batchGenerator = GenerateApiKey(
    prefix: 'sk',
    options: Base32GenerationOptions(),
    batch: 5, // Number of keys to generate
  );

  final batchApiKeys = batchGenerator.generateApiKey();
  print(batchApiKeys);
  // [
    // sk.13EX4M8-FJ04BHR-KCN76H8-DMET5JR,
    // sk.YXR9P48-3NB4KQR-JE511BG-1TG9QZ0,
    // sk.PE5A2E0-H8C4JNR-MQ1AJ2G-BMZXHC8,
    // sk.45ETSK0-2KFMNE0-KJMS2JR-BXTS330,
    // sk.N8QCPH8-XPJ4RYG-PBYCYBR-6H8AZG8
  // ]
```

---

## Customization

The `GenerateApiKey` class accepts several options for customization:

- `prefix`: A string that will be prefixed to each generated API key.
- `batch`: Number of API keys to generate in one go. If null, a single key is generated.
- `options`: The type of generation method and its specific options (e.g., `StringGenerationOptions`, `UuidV4GenerationOptions`).

## Error Handling

The class performs validations and will throw exceptions if invalid options are provided, such as a non-natural number for batch size or an invalid UUID in namespace options.

## Security

When generating and storing API keys and access tokens please be mindful of secure
database storage best practices. The reason API keys or access tokens are stored is to
confirm the key/token that is provided (ex. HTTP request) is valid and issued by your
organization or application (the same as a password). Just like a password, an API key
or access token can provide direct access to data or services that require authentication.

To authenticate an API key or access token, it is not necessary to know the raw
key/token value, the key/token just needs to validated to be correct. API keys and
access tokens should not be stored in plain text in your database, they should be
stored as a hashed value. Consider using database storage concepts such as salting
or peppering during the hashing process.

Lastly, if you suspect the API credentials for your organization or application have
been compromised, please revoke the keys and regenerate new keys.  
<br />

---

This README provides a basic guide for users to understand the purpose of the `GenerateApiKey` class and how to utilize it in their applications. You may need to adjust the package import statements and class/method names according to your actual implementation.

## Continuous Integration 🤖

Generate Api Key comes with a built-in [GitHub Actions workflow][github_actions_link] powered by [Very Good Workflows][very_good_workflows_link] but you can also add your preferred CI/CD solution.

Out of the box, on each pull request and push, the CI `formats`, `lints`, and `tests` the code. This ensures the code remains consistent and behaves correctly as you add functionality or make changes. The project uses [Very Good Analysis][very_good_analysis_link] for a strict set of analysis options used by our team. Code coverage is enforced using the [Very Good Workflows][very_good_coverage_link].

---

## Running Tests 🧪

To run all unit tests:

```sh
dart pub global activate coverage 1.2.0
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

## Contribution

Lots of PR's would be needed to make this plugin standard, as for iOS there's a permanent limitation for getting the exact data usage, there's only one way around it and it's super complex.

[dart_install_link]: https://dart.dev/get-dart
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[generate_api_key]: https://www.npmjs.com/package/generate-api-key
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
