import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartorder/features/order/presentation/bloc/api_validation_bloc.dart';
import 'package:smartorder/features/order/presentation/bloc/api_validation_event.dart';
import 'package:smartorder/features/order/presentation/bloc/api_validation_state.dart';
import 'package:smartorder/features/order/presentation/bloc/order_bloc.dart';
import 'package:smartorder/features/order/presentation/pages/order_page.dart';
import 'package:smartorder/features/products/presentation/bloc/products_bloc.dart';
import 'package:smartorder/features/products/presentation/pages/products_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<ProductsBloc>()),
        BlocProvider(create: (_) => di.sl<OrderBloc>()),
        BlocProvider(create: (_) => di.sl<ApiValidationBloc>()),
      ],
      child: MaterialApp(
        title: 'Smart Order',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[ProductsPage(), OrderPage()];

  @override
  void initState() {
    super.initState();
    // Sprawdź klucz API przy starcie
    Future.microtask(() {
      context.read<ApiValidationBloc>().add(ValidateApiKeyEvent());
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ApiValidationBloc, ApiValidationState>(
        listener: (context, state) {
          if (state is ApiValidationInvalid) {
            // Pokaż komunikat o błędnym kluczu API
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Błąd klucza API'),
                  ],
                ),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.read<ApiValidationBloc>().add(ValidateApiKeyEvent());
                    },
                    child: const Text('Spróbuj ponownie'),
                  ),
                ],
              ),
            );
          }
        },
        child: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Order'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
