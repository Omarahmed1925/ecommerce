import 'package:ecommerce/api/model/response/product/product_dto.dart';

/// Cart and wishlist responses return a product either populated (object)
/// or as a bare id string depending on the operation; accept both.
ProductDto? productRefFromJson(Object? json) {
  if (json is Map<String, dynamic>) return ProductDto.fromJson(json);
  if (json is String) return ProductDto(id: json);
  return null;
}

List<ProductDto>? productRefListFromJson(Object? json) {
  if (json is! List) return null;
  return json.map(productRefFromJson).whereType<ProductDto>().toList();
}
