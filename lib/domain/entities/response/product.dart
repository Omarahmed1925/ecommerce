import 'package:ecommerce/domain/entities/response/category.dart';
import 'package:ecommerce/domain/entities/response/sub_category.dart';

class Product {
  final int? sold;
  final List<String>? images;
  final List<Subcategory>? subcategory;
  final int? ratingsQuantity;
  final String? id;
  final String? title;
  final String? slug;
  final String? description;
  final int? quantity;
  final int? price;
  final int? priceAfterDiscount;
  final String? imageCover;
  final Category? category;
  final Category? brand;
  final double? ratingsAverage;
  final String? createdAt;
  final String? updatedAt;

  Product({
    this.sold,
    this.images,
    this.subcategory,
    this.ratingsQuantity,
    this.id,
    this.title,
    this.slug,
    this.description,
    this.quantity,
    this.price,
    this.priceAfterDiscount,
    this.imageCover,
    this.category,
    this.brand,
    this.ratingsAverage,
    this.createdAt,
    this.updatedAt,
  });

  /// The price the customer actually pays.
  int get finalPrice => priceAfterDiscount ?? price ?? 0;

  bool get hasDiscount =>
      priceAfterDiscount != null &&
      price != null &&
      priceAfterDiscount! < price!;
}
