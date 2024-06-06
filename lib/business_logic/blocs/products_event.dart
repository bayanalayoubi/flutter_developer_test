import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class FetchProductsByCategory extends ProductsEvent {
  final String category;

  const FetchProductsByCategory(this.category);

  @override
  List<Object> get props => [category];
}