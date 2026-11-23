import 'category.dart';
import 'metadata.dart';

class CategoryResponseDto {
  final int? results;
  final Metadata? metadata;
  final List<Category>? data;

  CategoryResponseDto({this.results, this.metadata, this.data});
}
