import 'package:ecommerce/data/data_sources/remote/brands_remote_data_source.dart';
import 'package:ecommerce/domain/entities/response/category.dart';
import 'package:ecommerce/domain/repos/brands_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BrandsRepo)
class BrandsRepoImpl implements BrandsRepo {
  BrandsRemoteDataSource brandsRemoteDataSource;
  BrandsRepoImpl({required this.brandsRemoteDataSource});

  @override
  Future<List<Category>?> getAllBrands() async {
    return await brandsRemoteDataSource.getAllBrands();
  }
}
