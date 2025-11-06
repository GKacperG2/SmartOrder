import 'package:dartz/dartz.dart';
import 'package:smartorder/core/error/failures.dart';
import 'package:smartorder/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
}
