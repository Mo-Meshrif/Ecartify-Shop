part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class GetCustomProductsEvent extends ProductEvent {
  final ProductsParmeters productsParmeters;
  const GetCustomProductsEvent({
    required this.productsParmeters,
  });
}

class GetProductDetailsEvent extends ProductEvent {
  final ProductDetailsParmeters productDetailsParmeters;
  const GetProductDetailsEvent({required this.productDetailsParmeters});
}

class UpdateProductDetailsEvent extends ProductEvent {
  final Product product;
  const UpdateProductDetailsEvent({required this.product});
}

class UpdateProductEvent extends ProductEvent{
  final ProductParameters productParameters;
  const UpdateProductEvent({required this.productParameters});
}