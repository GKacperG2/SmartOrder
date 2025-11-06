import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smartorder/core/config/app_config.dart';
import 'package:smartorder/core/error/exceptions.dart';
import 'package:smartorder/features/order/data/models/order_item_model.dart';

abstract class AiRemoteDataSource {
  Future<List<OrderItemModel>> analyzeOrderText(String text);
}

class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  final Dio dio;

  AiRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<OrderItemModel>> analyzeOrderText(String text) async {
    const url = 'https://openrouter.ai/api/v1/chat/completions';
    final apiKey = AppConfig.openRouterApiKey;

    if (apiKey.isEmpty) {
      throw AiException('API key is missing.');
    }

    final headers = {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'};

    final body = {
      'model': 'openai/gpt-3.5-turbo',
      'messages': [
        {
          'role': 'system',
          'content':
              "You are an expert in parsing order details. Extract product names and quantities from the user's text. Return the result as a JSON array of objects, where each object has 'name' and 'quantity' fields. For example: [{\"name\": \"iPhone 9\", \"quantity\": 2}]",
        },
        {'role': 'user', 'content': text},
      ],
    };

    try {
      final response = await dio.post(
        url,
        data: jsonEncode(body),
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        final content = response.data['choices'][0]['message']['content'];
        final decoded = jsonDecode(content) as List;
        return decoded.map((item) => OrderItemModel.fromJson(item)).toList();
      } else {
        throw ServerException();
      }
    } on DioError catch (e) {
      throw AiException(e.message ?? 'AI service error');
    }
  }
}
