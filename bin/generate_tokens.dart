#!/usr/bin/env dart
// ignore_for_file: avoid_print

import 'dart:io';
import 'package:design_tokens_generator/design_tokens_generator.dart';

void main(List<String> arguments) async {
  // Find the project root directory by looking for pubspec.yaml
  Directory currentDir = Directory.current;
  Directory? projectRoot;

  // Walk up the directory tree to find the project root
  while (currentDir.path != currentDir.parent.path) {
    if (File('${currentDir.path}/pubspec.yaml').existsSync()) {
      projectRoot = currentDir;
      break;
    }
    currentDir = currentDir.parent;
  }

  if (projectRoot == null) {
    print('❌ Could not find project root (looking for pubspec.yaml)');
    print('   Current directory: ${Directory.current.path}');
    exit(1);
  }

  print('📁 Project root: ${projectRoot.path}');

  // Default paths relative to project root
  String assetsPath = '${projectRoot.path}/assets/design_tokens';
  String outputPath =
      '${projectRoot.path}/lib/app/core/design_system/generated';

  // Parse command line arguments
  for (int i = 0; i < arguments.length; i++) {
    switch (arguments[i]) {
      case '--assets':
      case '-a':
        if (i + 1 < arguments.length) {
          final argPath = arguments[i + 1];
          // Make path absolute if it's relative
          assetsPath = argPath.startsWith('/')
              ? argPath
              : '${projectRoot.path}/$argPath';
          i++; // Skip next argument
        }
        break;
      case '--output':
      case '-o':
        if (i + 1 < arguments.length) {
          final argPath = arguments[i + 1];
          // Make path absolute if it's relative
          outputPath = argPath.startsWith('/')
              ? argPath
              : '${projectRoot.path}/$argPath';
          i++; // Skip next argument
        }
        break;
      case '--help':
      case '-h':
        _printHelp();
        return;
      default:
        print('Unknown argument: ${arguments[i]}');
        _printHelp();
        exit(1);
    }
  }

  // Validate paths before starting generation
  print('🔍 Checking paths...');
  print('   Assets: $assetsPath');
  print('   Output: $outputPath');

  // Check if assets directory exists
  final assetsDir = Directory(assetsPath);
  if (!await assetsDir.exists()) {
    print('');
    print('❌ Assets directory does not exist: $assetsPath');
    print('');
    print('💡 To fix this issue:');
    print('');
    print('1. Create the design tokens directory:');
    print('   mkdir -p "$assetsPath"');
    print('');
    print('2. Add your Figma design token JSON files to this directory:');
    print('   - Export your design tokens from Figma as JSON');
    print('   - Place them in the assets directory');
    print('');
    print('3. Example structure:');
    print('   $assetsPath/');
    print('   ├── colors.json');
    print('   ├── typography.json');
    print('   └── spacing.json');
    print('');
    print('4. Or use a different path with:');
    print('   dart run design_tokens_generator:generate_tokens --assets <your-path>');
    print('');
    print('📖 For more help, visit: https://pub.dev/packages/design_tokens_generator');
    print('');
    exit(1);
  }

  // Check if there are any JSON files in the assets directory
  final jsonFiles = await assetsDir
      .list(recursive: true)
      .where((entity) => entity is File && entity.path.endsWith('.json'))
      .where((entity) => !entity.path.split('/').last.startsWith('\$'))
      .toList();

  if (jsonFiles.isEmpty) {
    print('');
    print('⚠️  No JSON token files found in: $assetsPath');
    print('');
    print('💡 Please add your design token JSON files:');
    print('   - Export your design tokens from Figma as JSON');
    print('   - Place them in: $assetsPath');
    print('   - Files should end with .json (e.g., colors.json, typography.json)');
    print('');
    exit(1);
  }

  print('   ✅ Found ${jsonFiles.length} JSON files');

  try {
    final generator = DesignTokenGenerator(
      assetsPath: assetsPath,
      outputPath: outputPath,
    );

    await generator.generate();
  } catch (e, stackTrace) {
    print('❌ Error generating design tokens:');
    print('   $e');
    print('');
    print('Stack trace:');
    print(stackTrace);
    exit(1);
  }
}

void _printHelp() {
  print('Design Token Generator for Flutter');
  print('');
  print('Usage: dart bin/generate_tokens.dart [options]');
  print('');
  print('Options:');
  print('  -a, --assets <path>    Path to design tokens assets directory');
  print('                         (default: assets/design_tokens)');
  print('  -o, --output <path>    Path to output generated files');
  print(
      '                         (default: lib/app/core/design_system/generated)');
  print('  -h, --help             Show this help message');
  print('');
  print('Examples:');
  print('  dart bin/generate_tokens.dart');
  print(
      '  dart bin/generate_tokens.dart --assets ./tokens --output ./lib/theme');
}
