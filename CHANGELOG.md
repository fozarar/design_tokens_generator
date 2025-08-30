## 1.0.3

* **Fixed**: App spacing generator now properly parses values with units (px, rem, em, etc.)
* **Fixed**: Spacing values now generate valid Dart syntax (4.0 instead of 4px)
* **Improved**: User-friendly error messages when assets directory doesn't exist
* **Added**: Pre-validation of paths and JSON files before starting generation
* **Enhanced**: Step-by-step instructions for fixing common setup issues
* **Fixed**: Better error handling with actionable solutions for users
* **Added**: Automatic detection of missing design token files with helpful guidance

## 1.0.2

* **Fixed**: Made $metadata.json and $themes.json optional for Figma Design Token exports
* **Improved**: Automatic JSON file discovery when metadata files are not present
* **Enhanced**: Better error handling for missing or malformed metadata files
* **Added**: Support for direct Figma token exports without additional configuration files

## 1.0.1
- Fixed: Corrected GitHub repository link in pubspec.yaml

## 1.0.0

* Initial release of Design Tokens Generator
* Smart color generation from JSON design tokens
* Intelligent seed color detection for Material 3 themes
* Multi-theme support (Individual, Corporate, Can themes)
* Typography and spacing generation from design tokens
* CLI tool with compiled binary support
* Token resolution for complex references and nested structures
* Material Design 3 compatible theme generation
* Brand-aware color prioritization
* Comprehensive documentation and examples

