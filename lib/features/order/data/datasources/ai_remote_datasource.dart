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
      'model': 'openai/gpt-oss-safeguard-20b',
      'messages': [
        {
          'role': 'system',
          'content':
              "You are an expert in parsing order details from text in any language (English, Polish, etc.). Extract product names and quantities. Return ONLY a valid JSON array of objects, where each object has 'name' (string) and 'quantity' (number) fields. Do not include any other text or explanation, only the JSON array. Example: [{\"name\": \"iPhone 9\", \"quantity\": 2}, {\"name\": \"eggs\", \"quantity\": 10}]",
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
