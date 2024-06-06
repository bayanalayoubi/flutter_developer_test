import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/business_logic/blocs/product_details_event.dart';
import 'package:products_app/business_logic/blocs/product_details_state.dart';
import 'package:products_app/data/repositories/product_repository.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ProductRepository productRepository;

  ProductDetailsBloc({required this.productRepository}) : super(ProductDetailsLoading()) {
    on<FetchProductDetails>(_onFetchProductDetails);
  }

  void _onFetchProductDetails(
      FetchProductDetails event, Emitter<ProductDetailsState> emit) async {
    emit(ProductDetailsLoading());
    try {
      final product = await productRepository.fetchProductDetails(event.id); // Ensure the correct property is accessed
      emit(ProductDetailsLoaded(product));
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }
}