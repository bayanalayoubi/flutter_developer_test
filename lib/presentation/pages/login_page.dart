import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:products_app/business_logic/blocs/login_bloc.dart';
import 'package:products_app/business_logic/blocs/login_event.dart';
import 'package:products_app/business_logic/blocs/login_state.dart';
import 'package:products_app/presentation/pages/categories_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => LoginBloc()..add(LoginCheck()),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isLoggedIn) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged in successfully!')),
              );

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => CategoriesPage(),
              ));
            } else if (state.errorMessage.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
          builder: (context, state) {
            _usernameController.text = state.username;
            _passwordController.text = state.password;

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Color(0xFFA21C4F)),
                        ),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    labelStyle: TextStyle(color: Color(0xFFA21C4F)),
                                    prefixIcon: Icon(Icons.person, color: Color(0xFFA21C4F)),
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Color(0xFFA21C4F)),
                        ),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(color: Color(0xFFA21C4F)),
                                    prefixIcon: Icon(Icons.lock, color: Color(0xFFA21C4F)),
                                    border: InputBorder.none,
                                  ),
                                  obscureText: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity, // Makes the button take the full width
                        child: ElevatedButton(
                          onPressed: () {
                            final username = _usernameController.text;
                            final password = _passwordController.text;
                            context.read<LoginBloc>().add(
                              LoginSubmitted(username: username, password: password),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFA21C4F),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(color: Color(0xFFE0DEE0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Image.asset(
                    'assets/log1.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Image.asset(
                    'assets/log2.png',
                    width: 100,
                    height: 100,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
