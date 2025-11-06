import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartorder/core/error/failures.dart';
import 'package:smartorder/core/usecases/usecase.dart';
import 'package:smartorder/features/products/domain/usecases/get_products.dart';
import 'package:smartorder/features/products/presentation/bloc/products_event.dart';
import 'package:smartorder/features/products/presentation/bloc/products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProducts getProducts;

  ProductsBloc({required this.getProducts}) : super(ProductsInitial()) {
    on<GetProductsEvent>((event, emit) async {
      emit(ProductsLoading());
      final failureOrProducts = await getProducts(NoParams());
      failureOrProducts.fold(
        (failure) => emit(ProductsError(message: _mapFailureToMessage(failure))),
        (products) => emit(ProductsLoaded(products: products)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case NetworkFailure:
        return 'Network Failure';
      default:
        return 'Unexpected error';
    }
  }
}
