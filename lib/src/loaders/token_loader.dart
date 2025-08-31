import 'dart:convert';
import 'dart:io';
import 'package:logging/logging.dart';
import '../models/design_token.dart';

class TokenLoader {
  static final _logger = Logger('TokenLoader');

  TokenLoader({required this.assetsPath});
  final String assetsPath;

  /// Load metadata from $metadata.json (optional)
  Future<TokenMetadata?> loadMetadata() async {
    final file = File('$assetsPath/\$metadata.json');
    if (!await file.exists()) {
      _logger.info(
          'ℹ️  No \$metadata.json found - will scan for JSON files automatically');
      return null;
    }

    try {
      final content = await file.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      return TokenMetadata.fromJson(json);
    } catch (e) {
      _logger.warning('⚠️  Failed to parse \$metadata.json: $e');
      return null;
    }
  }

  /// Load all token files - either from metadata order or by scanning directory
  Future<Map<String, TokenSet>> loadAllTokens() async {
    final metadata = await loadMetadata();
    final tokenSets = <String, TokenSet>{};

    if (metadata != null) {
      // Use metadata order if available
      _logger.info('📋 Using metadata file to load tokens in order');
      for (final tokenSetPath in metadata.tokenSetOrder) {
        try {
          final tokens = await loadTokenSet(tokenSetPath);
          tokenSets[tokenSetPath] = tokens;
          _logger.info('   ✓ Loaded: $tokenSetPath.json');
        } catch (e) {
          _logger.warning('   ⚠️  Failed to load: $tokenSetPath.json - $e');
        }
      }
    } else {
      // Scan directory for JSON files automatically
      _logger.info('🔍 Scanning directory for JSON token files');
      await _scanAndLoadTokenFiles(tokenSets);
    }

    if (tokenSets.isEmpty) {
      throw Exception('No token files found in $assetsPath');
    }

    _logger.info('📦 Loaded ${tokenSets.length} token sets');
    return tokenSets;
  }

  /// Automatically scan directory and subdirectories for JSON files
  Future<void> _scanAndLoadTokenFiles(Map<String, TokenSet> tokenSets) async {
    final directory = Directory(assetsPath);

    if (!await directory.exists()) {
      throw Exception('''
📁 Assets directory does not exist: $assetsPath

💡 To fix this issue:

1. Create the design tokens directory:
   mkdir -p "$assetsPath"

2. Add your Figma design token JSON files to this directory:
   - Copy your exported JSON files from Figma
   - Place them in: $assetsPath/

3. Example structure:
   $assetsPath/
   ├── colors.json
   ├── typography.json
   └── spacing.json

4. Or use a different path with:
   dart run design_tokens_generator:generate_tokens --assets <your-path>

📖 For more help, visit: https://pub.dev/packages/design_tokens_generator
''');
    }

    await for (final entity in directory.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.json')) {
        // Skip metadata and themes files as they're not token files
        final fileName = entity.path.split('/').last;
        if (fileName.startsWith('\$')) {
          continue;
        }

        // Calculate relative path from assets directory
        final relativePath = entity.path
            .replaceFirst('${directory.path}/', '')
            .replaceFirst('.json', '');

        try {
          final content = await entity.readAsString();
          final json = jsonDecode(content) as Map<String, dynamic>;
          tokenSets[relativePath] = TokenSet(tokens: json);
          _logger.info('   ✓ Auto-loaded: $relativePath.json');
        } catch (e) {
          _logger.warning('   ⚠️  Failed to parse: $relativePath.json - $e');
        }
      }
    }
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
