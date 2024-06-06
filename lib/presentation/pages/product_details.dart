import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/business_logic/blocs/product_details_bloc.dart';
import 'package:products_app/business_logic/blocs/product_details_event.dart';
import 'package:products_app/business_logic/blocs/product_details_state.dart';
import 'package:products_app/data/repositories/product_repository.dart';

class ProductDetailsPage extends StatelessWidget {
  final int productId;

  ProductDetailsPage({required this.productId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details',
        style: TextStyle(
          color: Colors.white,
        ),),
        backgroundColor: Color(0xFFA21C4F),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: BlocProvider(
        create: (context) =>
        ProductDetailsBloc(productRepository: ProductRepository())
          ..add(FetchProductDetails(productId)),
        child: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildProductDetailsContent(state),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductDetailsContent(ProductDetailsState state) {
    if (state is ProductDetailsLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is ProductDetailsLoaded) {
      final product = state.product;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.network(
              product.image,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error);
              },
            ),
          ),
          SizedBox(height: 16),
          Text(
            product.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA21C4F),
            ),
          ),
          SizedBox(height: 16),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: Color(0xFFA21C4F),
                width: 2.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Price: \$${product.price.toInt()}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: Color(0xFFA21C4F),
                width: 2.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Category: ${product.category}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: Color(0xFFA21C4F),
                width: 2.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.description,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (state is ProductDetailsError) {
      return Center(
          child: Text('Failed to load product details: ${state.message}'));
    } else {
      return Container();
    }
  }
}
