import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  Future<dynamic> get(
    String endpoint, {
    String? token,
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}$endpoint',
    ).replace(
      queryParameters: queryParameters,
    );

    return _sendRequest(
      () => _client.get(
        uri,
        headers: _headers(token),
      ),
    );
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}$endpoint',
    );

    return _sendRequest(
      () => _client.post(
        uri,
        headers: _headers(token),
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}$endpoint',
    );

    return _sendRequest(
      () => _client.patch(
        uri,
        headers: _headers(token),
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  Map<String, String> _headers(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> _sendRequest(
    Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request();

      dynamic data;

      if (response.body.isNotEmpty) {
        try {
          data = jsonDecode(response.body);
        } catch (_) {
          data = response.body;
        }
      }

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        return data;
      }

      final message = data is Map<String, dynamic>
          ? data['message']?.toString() ??
              'Something went wrong.'
          : 'Something went wrong.';

      throw ApiException(
        message: message,
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Unable to connect to the server.',
      );
    }
  }
}