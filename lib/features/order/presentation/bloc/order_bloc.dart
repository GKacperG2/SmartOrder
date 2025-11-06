import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartorder/core/error/failures.dart';
import 'package:smartorder/features/order/domain/entities/matched_order_item.dart';
import 'package:smartorder/features/order/domain/usecases/analyze_order_text.dart';
import 'package:smartorder/features/order/domain/usecases/match_order_items.dart';
import 'package:smartorder/features/order/presentation/bloc/order_event.dart';
import 'package:smartorder/features/order/presentation/bloc/order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final AnalyzeOrderText analyzeOrderText;
  final MatchOrderItems matchOrderItems;

  OrderBloc({required this.analyzeOrderText, required this.matchOrderItems})
    : super(OrderInitial()) {
    on<AnalyzeOrderEvent>((event, emit) async {
      emit(OrderLoading());
      final failureOrOrderItems = await analyzeOrderText(AnalyzeOrderParams(text: event.orderText));

      await failureOrOrderItems.fold(
        (failure) async => emit(OrderError(message: _mapFailureToMessage(failure))),
        (orderItems) async {
          final failureOrMatchedItems = await matchOrderItems(
            MatchOrderParams(orderItems: orderItems, products: event.products),
          );

          failureOrMatchedItems.fold(
            (failure) => emit(OrderError(message: _mapFailureToMessage(failure))),
            (matchedItems) {
              final total = matchedItems.fold<double>(0.0, (sum, item) {
                if (item.status == MatchStatus.matched) {
                  return sum + (item.product!.price * item.quantity);
                }
                return sum;
              });
              emit(OrderAnalyzed(matchedItems: matchedItems, total: total));
            },
          );
        },
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return 'Server Failure';
    } else if (failure is NetworkFailure) {
      return 'Network Failure';
    } else if (failure is AiFailure) {
      return failure.message;
    } else {
      return 'Unexpected error';
    }
  }
}
