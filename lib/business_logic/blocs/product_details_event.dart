import 'package:equatable/equatable.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object> get props => [];
}

class FetchProductDetails extends ProductDetailsEvent {
  final int id;

  const FetchProductDetails(this.id);

  @override
  List<Object> get props => [id];
}