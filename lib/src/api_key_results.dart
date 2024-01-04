// ignore_for_file: public_member_api_docs

/// Results from the API key/token generation.
sealed class ApiKeyResults {
  const ApiKeyResults();

  void when({
    required void Function(String value) string,
    required void Function(List<String> batch) batch,
  });
}

class StringApiKeyResults extends ApiKeyResults {
  const StringApiKeyResults(this.value);
  final String value;

  @override
  void when({
    required void Function(String string) string,
    required void Function(List<String> batch) batch,
  }) {
    string(value);
  }

  @override
  String toString() => value;
}

class BatchApiKeyResults extends ApiKeyResults {
  const BatchApiKeyResults(this.batch);
  final List<String> batch;

  @override
  void when({
    required void Function(String value) string,
    required void Function(List<String> batch) batch,
  }) {
    batch(this.batch);
  }

  @override
  String toString() => '$batch';
}
