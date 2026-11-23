import 'category.dart';
import 'metadata.dart';

class BrandsResponseDto {
  final int? results;
  final Metadata? metadata;
  final List<Category>? data;

  BrandsResponseDto({this.results, this.metadata, this.data});
}
