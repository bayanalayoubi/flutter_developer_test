import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/business_logic/blocs/category_event.dart';
import 'package:products_app/business_logic/blocs/category_state.dart';
import 'package:products_app/data/repositories/category_repository.dart';
import 'package:products_app/data/models/category.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository}) : super(CategoryState()) {
    on<FetchCategories>(_onFetchCategories);
  }

  Future<void> _onFetchCategories(FetchCategories event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final List<Category> categories = await categoryRepository.fetchCategories();
      emit(state.copyWith(categories: categories, isLoading: false));
    } catch (error) {
      emit(state.copyWith(error: error.toString(), isLoading: false));
    }
  }
}