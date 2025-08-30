import 'dart:convert';
import 'dart:io';
import '../models/design_token.dart';

class TokenLoader {
  final String assetsPath;

  TokenLoader({required this.assetsPath});

  /// Load metadata from $metadata.json
  Future<TokenMetadata> loadMetadata() async {
    final file = File('$assetsPath/\$metadata.json');
    final content = await file.readAsString();
    final json = jsonDecode(content) as Map<String, dynamic>;
    return TokenMetadata.fromJson(json);
  }

  /// Load all token files based on metadata order
  Future<Map<String, TokenSet>> loadAllTokens() async {
    final metadata = await loadMetadata();
    final tokenSets = <String, TokenSet>{};

    for (final tokenSetPath in metadata.tokenSetOrder) {
      final tokens = await loadTokenSet(tokenSetPath);
      tokenSets[tokenSetPath] = tokens;
    }

    return tokenSets;
  }

  /// Load a specific token set file
  Future<TokenSet> loadTokenSet(String tokenSetPath) async {
    final file = File('$assetsPath/$tokenSetPath.json');
    final content = await file.readAsString();
    final json = jsonDecode(content) as Map<String, dynamic>;
    return TokenSet(tokens: json);
  }

  /// Flatten nested token structure into a flat map with dot notation
  Map<String, DesignToken> flattenTokens(Map<String, TokenSet> tokenSets) {
    final flattened = <String, DesignToken>{};

    for (final entry in tokenSets.entries) {
      final setName = entry.key;
      final tokenSet = entry.value;

      _flattenTokensRecursive(
        tokenSet.tokens,
        flattened,
        setName.toLowerCase().replaceAll('/', '.'),
      );
    }

    return flattened;
  }

  void _flattenTokensRecursive(
    Map<String, dynamic> tokens,
    Map<String, DesignToken> flattened,
    String prefix,
  ) {
    for (final entry in tokens.entries) {
      final key = entry.key;
      final value = entry.value;
      final path = prefix.isNotEmpty ? '$prefix.$key' : key;

      if (value is Map<String, dynamic>) {
        if (value.containsKey('value') && value.containsKey('type')) {
          // This is a design token
          flattened[path] = DesignToken.fromJson(value);
        } else {
          // This is a nested group, recurse
          _flattenTokensRecursive(value, flattened, path);
        }
      }
    }
  }
}
