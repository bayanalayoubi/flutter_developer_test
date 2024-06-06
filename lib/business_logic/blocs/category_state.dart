import 'package:equatable/equatable.dart';
import 'package:products_app/data/models/category.dart';

class CategoryState extends Equatable {
  final List<Category> categories;
  final bool isLoading;
  final String error;

  const CategoryState({
    this.categories = const [],
    this.isLoading = false,
    this.error = '',
  });

  CategoryState copyWith({
    List<Category>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [categories, isLoading, error];
}