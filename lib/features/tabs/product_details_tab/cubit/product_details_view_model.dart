import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/exceptions/app_exceptions.dart';
import 'package:ecommerce/domain/use_cases/get_product_details_use_case.dart';
import 'package:ecommerce/features/tabs/product_details_tab/cubit/product_details_states.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductDetailsViewModel extends Cubit<ProductDetailsStates> {
  final GetProductDetailsUseCase getProductDetailsUseCase;

  ProductDetailsViewModel({required this.getProductDetailsUseCase})
    : super(ProductDetailsLoadingState());

  late String _productId;

  void init(String productId) {
    _productId = productId;
    getProduct();
  }

  Future<void> getProduct() async {
    emit(ProductDetailsLoadingState());
    try {
      final product = await getProductDetailsUseCase.invoke(_productId);
      emit(ProductDetailsSuccessState(product: product, quantity: 1));
    } on AppExceptions catch (e) {
      emit(ProductDetailsErrorState(message: e.message));
    }
  }

  void increment() {
    final current = state;
    if (current is ProductDetailsSuccessState && current.canIncrement) {
      emit(
        ProductDetailsSuccessState(
          product: current.product,
          quantity: current.quantity + 1,
        ),
      );
    }
  }

  void decrement() {
    final current = state;
    if (current is ProductDetailsSuccessState && current.canDecrement) {
      emit(
        ProductDetailsSuccessState(
          product: current.product,
          quantity: current.quantity - 1,
        ),
      );
    }
  }
}
