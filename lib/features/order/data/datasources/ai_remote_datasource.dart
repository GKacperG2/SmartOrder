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
    const apiKey = AppConfig.openRouterApiKey;

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
              "Parse order text and extract products with quantities. CRITICAL: Extract FULL product names including brands and models. Examples:\n- 'Apple AirPods' NOT 'Apple'\n- 'Samsung Galaxy S21' NOT 'Samsung'\n- 'Essence Mascara Lash Princess' NOT 'Mascara'\nReturn pure JSON: [{\"name\": \"full product name\", \"quantity\": number}]",
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
        print('AI Response: $content'); // DEBUG: sprawdźmy co AI zwraca
        final decoded = jsonDecode(content) as List;
        return decoded.map((item) => OrderItemModel.fromJson(item)).toList();
      } else {
        throw ServerException();
      }
    } on DioException catch (e) {
      throw AiException(e.message ?? 'AI service error');
    }
  }
}
