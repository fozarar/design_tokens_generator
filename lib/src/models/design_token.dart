import 'package:json_annotation/json_annotation.dart';

part 'design_token.g.dart';

@JsonSerializable()
class DesignToken {

  const DesignToken({
    required this.value,
    required this.type,
    this.description,
  });

  factory DesignToken.fromJson(Map<String, dynamic> json) =>
      _$DesignTokenFromJson(json);
  final dynamic value;
  final String type;
  final String? description;

  Map<String, dynamic> toJson() => _$DesignTokenToJson(this);

  /// Check if this token references another token
  bool get isReference =>
      value is String &&
      value.toString().startsWith('{') &&
      value.toString().endsWith('}');

  /// Extract the reference path from a token reference
  String? get referencePath {
    if (!isReference) return null;
    final ref = value.toString();
    return ref.substring(1, ref.length - 1);
  }
}

@JsonSerializable()
class TokenSet {

  const TokenSet({required this.tokens});

  factory TokenSet.fromJson(Map<String, dynamic> json) =>
      _$TokenSetFromJson(json);
  final Map<String, dynamic> tokens;

  Map<String, dynamic> toJson() => _$TokenSetToJson(this);
}

@JsonSerializable()
class TokenMetadata {

  const TokenMetadata({required this.tokenSetOrder});

  factory TokenMetadata.fromJson(Map<String, dynamic> json) =>
      _$TokenMetadataFromJson(json);
  final List<String> tokenSetOrder;

  Map<String, dynamic> toJson() => _$TokenMetadataToJson(this);
}
