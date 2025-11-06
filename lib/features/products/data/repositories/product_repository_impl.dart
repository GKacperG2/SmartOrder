import 'package:dartz/dartz.dart';
import 'package:smartorder/core/error/exceptions.dart';
import 'package:smartorder/core/error/failures.dart';
import 'package:smartorder/core/network/network_info.dart';
import 'package:smartorder/features/products/data/datasources/product_remote_datasource.dart';
import 'package:smartorder/features/products/domain/entities/product.dart';
import 'package:smartorder/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProducts = await remoteDataSource.getProducts();
        return Right(remoteProducts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
