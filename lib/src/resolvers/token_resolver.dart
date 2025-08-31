import 'package:logging/logging.dart';
import '../models/design_token.dart';

class TokenResolver {
  static final _logger = Logger('TokenResolver');

  TokenResolver(this._tokens);
  final Map<String, DesignToken> _tokens;

  /// Resolve all token references to their final values
  Map<String, dynamic> resolveAllTokens() {
    final resolved = <String, dynamic>{};
    final resolving = <String>{};

    for (final entry in _tokens.entries) {
      final path = entry.key;
      try {
        resolved[path] = _resolveToken(path, resolving);
      } catch (e) {
        _logger.warning(
            '⚠️  Failed to resolve token: $path - Using original value');
        // Use the original value as fallback for unresolved references
        resolved[path] = entry.value.value;
      }
    }

    _logger.info('🔗 Resolved ${resolved.length} design tokens');
    return resolved;
  }

  /// Resolve a single token, handling circular references
  dynamic _resolveToken(String path, Set<String> resolving) {
    if (resolving.contains(path)) {
      throw Exception(
          'Circular reference detected: ${resolving.join(' -> ')} -> $path');
    }

    final token = _tokens[path];
    if (token == null) {
      throw Exception('Token not found: $path');
    }

    if (!token.isReference) {
      return token.value;
    }

    resolving.add(path);

    final referencePath = token.referencePath!;
    final normalizedPath = _normalizeTokenPath(referencePath);

    final resolvedValue = _resolveToken(normalizedPath, resolving);
    resolving.remove(path);

    return resolvedValue;
  }

  /// Normalize token reference paths to match our flattened structure
  String _normalizeTokenPath(String path) {
    // Find all tokens that might match this reference
    final searchTerms = path
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('-', '');

    final candidates = _tokens.keys.where((key) {
      final keyNormalized = key
          .toLowerCase()
          .replaceAll(' ', '')
          .replaceAll('(', '')
          .replaceAll(')', '')
          .replaceAll('-', '')
          .replaceAll('_', '');

      return keyNormalized.contains(searchTerms.replaceAll('.', '')) ||
          key.toLowerCase().endsWith(path.toLowerCase()) ||
          _pathMatches(key, path);
    }).toList();

    if (candidates.isNotEmpty) {
      // Sort by best match
      candidates.sort((a, b) {
        final aScore = _calculateMatchScore(a, path);
        final bScore = _calculateMatchScore(b, path);
        return bScore.compareTo(aScore); // Higher score first
      });

      return candidates.first;
    }

    throw Exception('Could not resolve token path: $path');
  }

  bool _pathMatches(String tokenKey, String referencePath) {
    final refParts = referencePath.toLowerCase().split('.');
    final keyParts = tokenKey.toLowerCase().split('.');

    // Check if the reference path parts are contained in the token key
    int matchCount = 0;
    for (final refPart in refParts) {
      for (final keyPart in keyParts) {
        if (keyPart.contains(refPart
            .replaceAll(' ', '')
            .replaceAll('(', '')
            .replaceAll(')', ''))) {
          matchCount++;
          break;
        }
      }
    }

    return matchCount >= refParts.length - 1; // Allow one part to not match
  }

  int _calculateMatchScore(String tokenKey, String referencePath) {
    int score = 0;
    final refParts = referencePath.toLowerCase().split('.');
    final keyParts = tokenKey.toLowerCase().split('.');

    // Exact part matches
    for (final refPart in refParts) {
      if (keyParts.any((keyPart) => keyPart == refPart)) {
        score += 10;
      } else if (keyParts.any((keyPart) => keyPart.contains(refPart))) {
        score += 5;
      }
    }

    // Prefer shorter paths (more specific)
    score -= tokenKey.split('.').length;

    return score;
  }
}
