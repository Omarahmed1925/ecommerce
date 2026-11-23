import 'package:ecommerce/data/data_sources/remote/category_remote_data_source.dart';
import 'package:ecommerce/domain/entities/response/category.dart';
import 'package:ecommerce/domain/entities/response/sub_category.dart';
import 'package:ecommerce/domain/repos/category_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoryRepository)
class CatgoryRepoImpl implements CategoryRepository {
  CategoryRemoteDataSource categoryRemoteDataSource;
  CatgoryRepoImpl({required this.categoryRemoteDataSource});
  @override
  Future<List<Category>?> getAllCategories() async {
    return await categoryRemoteDataSource.getAllCategories();
  }

  @override
  Future<List<Subcategory>> getSubCategories(String categoryId) =>
      categoryRemoteDataSource.getSubCategories(categoryId);
}
