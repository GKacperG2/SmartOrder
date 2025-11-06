import 'package:dio/dio.dart';
import 'package:smartorder/core/error/exceptions.dart';
import 'package:smartorder/features/products/data/models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await dio.get('https://dummyjson.com/products?limit=50');

    if (response.statusCode == 200) {
      final products = (response.data['products'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
      return products;
    } else {
      throw ServerException();
    }
  }
}
