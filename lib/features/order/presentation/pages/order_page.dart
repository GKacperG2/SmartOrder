import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartorder/features/order/domain/entities/matched_order_item.dart';
import 'package:smartorder/features/order/presentation/bloc/order_bloc.dart';
import 'package:smartorder/features/order/presentation/bloc/order_event.dart';
import 'package:smartorder/features/order/presentation/bloc/order_state.dart';
import 'package:smartorder/features/products/presentation/bloc/products_bloc.dart';
import 'package:smartorder/features/products/presentation/bloc/products_state.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _textController = TextEditingController();
  final _searchController = TextEditingController();
  List<MatchedOrderItem> _matchedItems = [];
  List<MatchedOrderItem> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _matchedItems.where((item) {
        final productName = item.product?.title.toLowerCase() ?? item.name.toLowerCase();
        return productName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is OrderAnalyzed) {
            setState(() {
              _matchedItems = state.matchedItems;
              _filteredItems = state.matchedItems;
            });
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _textController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Paste your order here...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<ProductsBloc, ProductsState>(
                  builder: (context, productsState) {
                    if (productsState is ProductsLoaded) {
                      return ElevatedButton(
                        onPressed: () {
                          final orderText = _textController.text;
                          if (orderText.isNotEmpty) {
                            BlocProvider.of<OrderBloc>(context).add(
                              AnalyzeOrderEvent(
                                orderText: orderText,
                                products: productsState.products,
                              ),
                            );
                          }
                        },
                        child: const Text('Analyze Order'),
                      );
                    }
                    return const ElevatedButton(
                      onPressed: null,
                      child: Text('Analyze Order (Loading Products...)'),
                    );
                  },
                ),
                const SizedBox(height: 16),
                if (state is OrderLoading)
                  const CircularProgressIndicator()
                else if (state is OrderAnalyzed)
                  Expanded(
                    child: Column(
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search products...',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(child: _buildResultList(_filteredItems, state.total)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _exportToJson(context, _matchedItems),
                          child: const Text('Export to JSON'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultList(List<MatchedOrderItem> items, double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildRow(item);
            },
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Suma całkowita: \$${total.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.right,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        color: Colors.grey.shade100,
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('Nazwa produktu', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Ilość',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Cena jednostkowa',
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Suma',
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(MatchedOrderItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product?.title ?? item.name),
                if (item.status != MatchStatus.matched)
                  const Text('Niedopasowane', style: TextStyle(color: Colors.red, fontSize: 12)),
              ],
            ),
          ),
          Expanded(flex: 1, child: Text(item.quantity.toString(), textAlign: TextAlign.center)),
          Expanded(
            flex: 2,
            child: Text(
              item.status == MatchStatus.matched
                  ? '\$${item.product!.price.toStringAsFixed(2)}'
                  : '-',
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item.status == MatchStatus.matched
                  ? '\$${(item.product!.price * item.quantity).toStringAsFixed(2)}'
                  : '-',
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _exportToJson(BuildContext context, List<MatchedOrderItem> items) {
    final jsonString = jsonEncode(items.map((item) => item.toJson()).toList());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('JSON Export'),
        content: SingleChildScrollView(child: Text(jsonString)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
