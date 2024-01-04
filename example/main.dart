import 'package:generate_api_key/generate_api_key.dart';

void main(List<String> args) {
  const generator = GenerateApiKey(
    prefix: 'pk',
    options: StringGenerationOptions(
      length: 20,
      pool: 'ABCDEFG1234567890',
    ),
  );

  final apiKey = generator.generateApiKey();
  print(apiKey); // pk.ECCC9398D9G2D3G26A1F
}
