import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:smartorder/core/error/failures.dart';
import 'package:smartorder/core/usecases/usecase.dart';
import 'package:smartorder/features/order/domain/entities/order_item.dart';
import 'package:smartorder/features/order/domain/repositories/order_repository.dart';

class AnalyzeOrderText implements UseCase<List<OrderItem>, AnalyzeOrderParams> {
  final OrderRepository repository;

  AnalyzeOrderText(this.repository);

  @override
  Future<Either<Failure, List<OrderItem>>> call(AnalyzeOrderParams params) async {
    return await repository.analyzeOrderText(params.text);
  }
}

class AnalyzeOrderParams extends Equatable {
  final String text;

  const AnalyzeOrderParams({required this.text});

  @override
  List<Object> get props => [text];
}
