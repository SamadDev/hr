import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:nandrlon/models/product.model.dart';

class ProductService {
  static Future<List<Product>> getAll() async {
    final String response =
        await rootBundle.loadString('assets/json/product.json');
    final data = await json.decode(response);

    return data.map<Product>((json) => Product.fromJson(json)).toList();
  }
}
