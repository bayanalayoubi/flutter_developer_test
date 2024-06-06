import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/business_logic/blocs/category_bloc.dart';
import 'package:products_app/business_logic/blocs/category_event.dart';
import 'package:products_app/business_logic/blocs/category_state.dart';
import 'package:products_app/data/repositories/category_repository.dart';
import 'package:products_app/presentation/pages/products_page.dart';
import 'package:products_app/data/models/category.dart'; // Import the category model

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Categories' ,
          textAlign: TextAlign.center ,
          style: TextStyle(
              color: Colors.white
          ),),
        backgroundColor: Color(0xFFA21C4F),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.deepPurpleAccent[10],
      body: BlocProvider(
        create: (context) => CategoryBloc(categoryRepository: CategoryRepository())..add(FetchCategories()),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.error.isNotEmpty) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              final List<String> assetNames = ['electronics', 'jewelery', 'men', 'women'];
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 1.0, ),
                    itemCount: assetNames.length,
                    itemBuilder: (context, index) {
                      final Category category = state.categories.length > index
                          ? state.categories[index]
                          : Category(name: assetNames[index]); // Access category object
                      return Card(
                        color: Colors.white,
                        elevation: 4.0,
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
                                builder: (context) => ProductsPage(category: category.name), // Pass category name as String
                              ),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/${assetNames[index]}.jpeg',
                                width: 100,
                                height: 100,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error, color: Colors.red);
                                },
                              ), // Load the asset image
                              SizedBox(height: 8.0),
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFA21C4F),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
