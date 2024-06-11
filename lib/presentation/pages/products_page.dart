import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/business_logic/blocs/products_bloc.dart';
import 'package:products_app/business_logic/blocs/products_event.dart';
import 'package:products_app/business_logic/blocs/products_state.dart';
import 'package:products_app/data/repositories/product_repository.dart';
import 'package:products_app/presentation/pages/product_details.dart';
import 'package:products_app/data/models/product.dart';

class ProductsPage extends StatefulWidget {
  final String category;

  ProductsPage({required this.category, Key? key}) : super(key: key);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  double _selectedMinRating = 0.0;
  final TextEditingController _ratingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ratingController.text = _selectedMinRating.toString();
  }

  @override
  void dispose() {
    _ratingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFA21C4F),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _ratingController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Min Rating',
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                    onSubmitted: (value) {
                      setState(() {
                        _selectedMinRating = double.tryParse(value) ?? 0.0;
                        BlocProvider.of<ProductsBloc>(context).add(
                          FetchProductsByCategoryAndRating(widget.category, _selectedMinRating),
                        );
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _selectedMinRating = double.tryParse(_ratingController.text) ?? 0.0;
                      BlocProvider.of<ProductsBloc>(context).add(
                        FetchProductsByCategoryAndRating(widget.category, _selectedMinRating),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.deepPurpleAccent[10],
      body: BlocProvider(
        create: (context) => ProductsBloc(productRepository: ProductRepository())
          ..add(FetchProductsByCategory(widget.category)),
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProductsLoaded) {
              final filteredProducts = state.products
                  .where((product) => product.rating.rate >= _selectedMinRating)
                  .toList();
              return ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: Color(0xFFA21C4F),
                        width: 2.0,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsPage(productId: product.id),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                color: Colors.white,
                                child: Image.network(
                                  product.image,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.title.length > 20
                                      ? product.title.substring(0, 20) + '...'
                                      : product.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFFA21C4F),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    product.rating.rate.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < product.rating.rate
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 16,
                                );
                              }),
                            ),
                            SizedBox(height: 5),
                            Text(
                              product.description.length > 50
                                  ? product.description.substring(0, 50) + '...'
                                  : product.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '\$${product.price.toInt()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is ProductsError) {
              return Center(child: Text('Failed to load products: ${state.message}'));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
