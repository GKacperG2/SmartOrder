import 'package:dartz/dartz.dart';
import 'package:smartorder/core/error/exceptions.dart';
import 'package:smartorder/core/error/failures.dart';
import 'package:smartorder/core/network/network_info.dart';
import 'package:smartorder/features/order/data/datasources/ai_remote_datasource.dart';
import 'package:smartorder/features/order/domain/entities/order_item.dart';
import 'package:smartorder/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final AiRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<OrderItem>>> analyzeOrderText(String text) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.analyzeOrderText(text);
        return Right(result);
      } on AiException catch (e) {
        return Left(AiFailure(e.message));
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
