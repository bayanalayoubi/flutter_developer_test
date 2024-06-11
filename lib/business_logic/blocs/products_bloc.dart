import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/business_logic/blocs/products_event.dart';
import 'package:products_app/business_logic/blocs/products_state.dart';
import 'package:products_app/data/repositories/product_repository.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository productRepository;

  ProductsBloc({required this.productRepository}) : super(ProductsLoading()) {
    on<FetchProductsByCategory>(_onFetchProductsByCategory);
    on<FetchProductsByCategoryAndRating>(_onFetchProductsByCategoryAndRating);
  }

  void _onFetchProductsByCategory(
      FetchProductsByCategory event, Emitter<ProductsState> emit) async {
    emit(ProductsLoading());
    try {
      final products = await productRepository.fetchProductsByCategory(event.category);
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  void _onFetchProductsByCategoryAndRating(
      FetchProductsByCategoryAndRating event, Emitter<ProductsState> emit) async {
    emit(ProductsLoading());
    try {
      final products = await productRepository.fetchProductsByCategory(event.category);
      final filteredProducts = products
          .where((product) => product.rating.rate >= event.minRating)
          .toList();
      emit(ProductsLoaded(filteredProducts));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}
