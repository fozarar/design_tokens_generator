## 1.0.5

* **Fixed**: Replaced all print statements with proper logging framework for better debugging
* **Improved**: Generated constant names now follow camelCase naming convention (colorGreen50 instead of color_green_50)
* **Enhanced**: Better lint compliance with proper constant identifier naming
* **Added**: Professional logging with different levels (info, warning, severe) for better development experience
* **Fixed**: Eliminated all lint warnings and errors in generated code
* **Improved**: Token name generation now produces more readable and consistent variable names
* **Enhanced**: Code quality improvements across all generator classes

## 1.0.4

* **Added**: Enhanced token name generation for better camelCase support
* **Improved**: Better handling of complex token paths and naming

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

