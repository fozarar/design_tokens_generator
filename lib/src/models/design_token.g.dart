// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'design_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DesignToken _$DesignTokenFromJson(Map<String, dynamic> json) => DesignToken(
      value: json['value'],
      type: json['type'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$DesignTokenToJson(DesignToken instance) =>
    <String, dynamic>{
      'value': instance.value,
      'type': instance.type,
      'description': instance.description,
    };

TokenSet _$TokenSetFromJson(Map<String, dynamic> json) => TokenSet(
      tokens: json['tokens'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$TokenSetToJson(TokenSet instance) => <String, dynamic>{
      'tokens': instance.tokens,
    };

TokenMetadata _$TokenMetadataFromJson(Map<String, dynamic> json) =>
    TokenMetadata(
      tokenSetOrder: (json['tokenSetOrder'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TokenMetadataToJson(TokenMetadata instance) =>
    <String, dynamic>{
      'tokenSetOrder': instance.tokenSetOrder,
    };
