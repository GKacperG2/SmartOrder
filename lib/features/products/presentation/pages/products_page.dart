import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartorder/features/products/presentation/bloc/products_bloc.dart';
import 'package:smartorder/features/products/presentation/bloc/products_event.dart';
import 'package:smartorder/features/products/presentation/bloc/products_state.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductsBloc>(context).add(GetProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsLoaded) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ListTile(title: Text(product.title), subtitle: Text('\$${product.price}'));
              },
            );
          } else if (state is ProductsError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Press the button to fetch products'));
        },
      ),
    );
  }
}
