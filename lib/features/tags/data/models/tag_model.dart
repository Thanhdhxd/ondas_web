import 'package:ondas_web/features/tags/domain/entities/tag.dart';

class TagModel extends Tag {
  const TagModel({
    required super.id,
    required super.name,
    super.type,
    super.colorHex,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String?,
      colorHex: json['colorHex'] as String?,
    );
  }
}
