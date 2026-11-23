import 'package:ecommerce/data/data_sources/remote/cart_remote_data_source.dart';
import 'package:ecommerce/domain/entities/response/cart.dart';
import 'package:ecommerce/domain/repos/cart_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CartRepo)
class CartRepoImpl implements CartRepo {
  final CartRemoteDataSource cartRemoteDataSource;

  CartRepoImpl({required this.cartRemoteDataSource});

  @override
  Future<Cart> getCart() => cartRemoteDataSource.getCart();

  @override
  Future<Cart> addToCart(String productId) =>
      cartRemoteDataSource.addToCart(productId);

  @override
  Future<Cart> updateItemQuantity(String productId, int count) =>
      cartRemoteDataSource.updateItemQuantity(productId, count);

  @override
  Future<Cart> removeItem(String productId) =>
      cartRemoteDataSource.removeItem(productId);
}
