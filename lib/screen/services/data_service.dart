import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shoes_shop/dto/balances.dart';
import 'package:shoes_shop/dto/customer_service.dart';
import 'package:shoes_shop/dto/datas.dart';
import 'package:shoes_shop/dto/news.dart';
import 'package:shoes_shop/dto/spendings.dart';
import 'dart:convert';
import 'package:shoes_shop/screen/endpoints/endpoints.dart';
import 'package:shoes_shop/utils/secure_storage_util.dart';

class DataService {
  static Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse(Endpoints.news));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => News.fromJson(item)).toList();
    } else {
      // Handle error
      throw Exception('Failed to load news');
    }
  }

  static Future<List<Datas>> fetchDatas() async {
    final response = await http.get(Uri.parse(Endpoints.datas));
    debugPrint('here0');
    if (response.statusCode == 200) {
      debugPrint('here');
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Datas.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Handle error
      throw Exception('Failed to load data');
    }
  }

  static Future<List<CustomerService>> fetchCustomerService() async {
    final response = await http.get(Uri.parse(Endpoints.CustomerService));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => CustomerService.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load datas');
    }
  }

  static Future<void> deleteCustomerService(int idCustomerService) async {
    await http.delete(
        Uri.parse('${Endpoints.CustomerService}/$idCustomerService'),
        headers: {'Content-type': 'application/json'});
  }

  static Future<News> createNews(String title, String body) async {
    final response = await http.post(
      Uri.parse(Endpoints.news),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'body': body,
      }),
    );

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      return News.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to create post: ${response.statusCode}');
    }
  }

  static Future<List<Balances>> fetchBalances() async {
    final response = await http.get(Uri.parse(Endpoints.balance));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Balances.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<Spendings>> fetchSpendings() async {
    final response = await http.get(Uri.parse(Endpoints.spending));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (data['datas'] as List<dynamic>)
          .map((item) => Spendings.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<http.Response> sendSpendingData(int spending) async {
    final url = Uri.parse(Endpoints.spending);
    final data = {'spending': spending};

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return response;
  }

  static Future<http.Response> sendLoginData(String email, String password) async {
    final url = Uri.parse(Endpoints.login);
    final data = {'email': email, 'password': password};

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    return response;
  }

  static Future<void> logoutData() async {
  final url = Uri.parse(Endpoints.logout);
  final String? accessToken = await SecureStorageUtil.storage.read(key: 'token');
  debugPrint("logout with $accessToken");

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    await SecureStorageUtil.deleteToken();
    debugPrint("Token deleted");
  } else {
    debugPrint("Failed to logout: ${response.statusCode}");
  }
}
}
