<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# Design Tokens Generator

A powerful Flutter package for generating design tokens from design system files. This package converts design tokens (colors, typography, spacing) into Flutter-ready Dart code with advanced theme support and automatic seed color detection.

## 🚀 Features

- ✨ **Smart Color Generation**: Automatically generates Flutter colors from JSON design tokens
- 🎨 **Intelligent Seed Color Detection**: Automatically finds the best brand colors for Material 3 themes
- 🎭 **Multi-Theme Support**: Supports Individual, Corporate, and Can themes with automatic theme detection
- 📱 **Material Design 3 Compatible**: Generates themes compatible with Flutter's Material 3
- 🔄 **Token Resolution**: Handles complex token references and nested structures
- 📝 **Typography Generation**: Converts design typography tokens to Flutter TextStyles
- 📏 **Spacing Generation**: Creates spacing constants from design tokens
- 🛠️ **CLI & Programmatic API**: Use via command line or integrate into your build process
- 🎯 **Brand-Aware**: Prioritizes brand colors (primary, blue, green, purple) for theme generation

## 🔧 Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  design_tokens_generator:
    path: ../design_tokens_generator
```

Or install from a git repository:

```yaml
dependencies:
  design_tokens_generator:
    git:
      url: https://github.com/your-org/design_tokens_generator.git
```

## 📖 Usage

### Command Line Usage

Run the generator from your project root:

```bash
# Basic usage
dart run design_tokens_generator:generate_tokens --assets assets/design_tokens --output lib/app/core/design_system/generated

# Using the compiled binary (faster)
./bin/generate_tokens_compiled --assets assets/design_tokens --output lib/app/core/design_system/generated
```

### Programmatic Usage

```dart
import 'package:design_tokens_generator/design_tokens_generator.dart';

void main() async {
  final generator = DesignTokenGenerator(
    assetsPath: 'assets/design_tokens',
    outputPath: 'lib/app/core/design_system/generated',
  );
  
  await generator.generate();
  print('✅ Design tokens generated successfully!');
}
```

## 📂 Generated Files

The package generates the following files in your output directory:

### `app_colors.dart`
Contains all color constants organized by theme:
```dart
class AppColors {
  // Value Colors (base colors)
  static const Color value_value_colors_brand_600 = Color(0xFF1570ef);
  static const Color value_value_colors_brand_500 = Color(0xFF2e90fa);
  
  // Individual Theme Colors
  static const Color individual_individual_color_primary = Color(0xFF1570ef);
  
  // Corporate Theme Colors  
  static const Color corporate_corporate_color_primary = Color(0xFF2e90fa);
  
  // Can Theme Colors
  static const Color can_can_color_primary = Color(0xFF6938ef);
}
```

### `app_theme.dart`
Complete Flutter themes with automatic seed color selection:
```dart
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.value_value_colors_brand_600, // Auto-selected
        brightness: Brightness.light,
      ),
      // ... complete theme configuration
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.value_value_colors_brand_700, // Auto-selected
        brightness: Brightness.dark,
      ),
      // ... complete theme configuration
    );
  }
}
```

### `app_typography.dart`
Typography styles from design tokens:
```dart
class AppTypography {
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.25,
  );
  // ... more typography styles
}
```

### `app_spacing.dart`
Spacing constants:
```dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  // ... more spacing values
}
```

## 🏗️ Design Token Structure

Your design tokens should be organized as JSON files in the assets directory:

```
assets/design_tokens/
├── $metadata.json          # Token metadata
├── $themes.json            # Theme definitions
├── Color/                  # Color tokens
│   ├── base.json
│   ├── individual.json
│   ├── corporate.json
│   └── can.json
├── Typography/             # Typography tokens
├── Spacing/               # Spacing tokens
├── Primitives/            # Primitive tokens
├── Containers/            # Container tokens
└── Radius/               # Border radius tokens
```

## 🎨 Smart Seed Color Detection

The generator automatically selects the best seed colors for Material 3 themes using intelligent prioritization:

### Priority Order:
1. **Brand colors** - `brand`, `primary`
2. **Blue variants** - `blue`, `bluelight`, `bluedark`
3. **Other colors** - `green`, `purple`, `indigo`, `teal`, `cyan`

### Tone Selection:
- **Light theme**: Prefers 500-600 tones
- **Dark theme**: Prefers 700-800 tones

### Example Output:
```
🎯 Searching for seed colors...
🔍 Found 1300+ color tokens
🎯 Brand tokens found: 10
   Brand: value.value.colors.brand.600 -> #1570ef
🎯 Selected light token: value.value.colors.brand.600
🎯 Converted to: AppColors.value_value_colors_brand_600
```

## 🔄 Token Resolution

The generator handles complex token references:

```json
{
  "color": {
    "primary": {
      "value": "{color.brand.600}"
    },
    "brand": {
      "600": {
        "value": "#1570ef"
      }
    }
  }
}
```

Results in resolved tokens ready for Flutter:
```dart
static const Color color_primary = Color(0xFF1570ef);
static const Color color_brand_600 = Color(0xFF1570ef);
```

## 🎭 Multi-Theme Support

The generator automatically detects and organizes themes:

- **Individual Theme**: Personal/consumer interface colors
- **Corporate Theme**: Business/enterprise interface colors  
- **Can Theme**: Custom brand theme colors
- **Value Colors**: Base color palette shared across themes

## 📱 Integration Example

```dart
import 'package:flutter/material.dart';
import 'app/core/design_system/generated/app_theme.dart';
import 'app/core/design_system/generated/app_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Design System Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.individual_individual_color_background_primary,
      body: Center(
        child: Text(
          'Hello Design System!',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: AppColors.individual_individual_color_text_primary,
          ),
        ),
      ),
    );
  }
}
```

## 🛠️ Development & Build

### Build the CLI tool:
```bash
dart compile exe bin/generate_tokens.dart -o bin/generate_tokens_compiled
```

### Run tests:
```bash
dart test
```

### Analyze code:
```bash
dart analyze
```

## 🔍 Troubleshooting

### Common Issues:

**Colors not generating:**
- Check that your JSON files contain valid color values (hex format)
- Ensure color tokens are in the correct directory structure

**Theme not applying:**
- Verify that AppTheme is imported correctly
- Check that Material 3 is enabled: `useMaterial3: true`

**Seed colors not found:**
- Ensure you have brand or primary colors in your tokens
- Check that color tokens follow the expected naming convention

## 📊 Performance

- **Token Processing**: ~1000+ tokens processed per second
- **File Generation**: Generates 4 files in under 2 seconds
- **Memory Usage**: Minimal memory footprint
- **Build Integration**: Fast enough for watch mode builds

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.


## 🙏 Acknowledgments

- Flutter team for the excellent Material 3 implementation
- Design Token Community Group for the design tokens specification
- All contributors who helped improve this package

