import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:smartorder/core/network/network_info.dart';
import 'package:smartorder/features/order/data/datasources/ai_remote_datasource.dart';
import 'package:smartorder/features/order/data/repositories/order_repository_impl.dart';
import 'package:smartorder/features/order/domain/repositories/order_repository.dart';
import 'package:smartorder/features/order/domain/usecases/analyze_order_text.dart';
import 'package:smartorder/features/order/domain/usecases/match_order_items.dart';
import 'package:smartorder/features/order/presentation/bloc/order_bloc.dart';
import 'package:smartorder/features/products/data/datasources/product_remote_datasource.dart';
import 'package:smartorder/features/products/data/repositories/product_repository_impl.dart';
import 'package:smartorder/features/products/domain/repositories/product_repository.dart';
import 'package:smartorder/features/products/domain/usecases/get_products.dart';
import 'package:smartorder/features/products/presentation/bloc/products_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features
  // Products
  sl.registerFactory(() => ProductsBloc(getProducts: sl()));
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<ProductRemoteDataSource>(() => ProductRemoteDataSourceImpl(dio: sl()));

  // Order
  sl.registerFactory(() => OrderBloc(analyzeOrderText: sl(), matchOrderItems: sl()));
  sl.registerLazySingleton(() => AnalyzeOrderText(sl()));
  sl.registerLazySingleton(() => MatchOrderItems());
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<AiRemoteDataSource>(() => AiRemoteDataSourceImpl(dio: sl()));

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // External
  sl.registerLazySingleton(() => Dio());
}
