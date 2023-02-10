import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lets_makeup/model/product.dart';

import '../shared/services/webservices/makeup_service.dart';

class ProductController extends GetxController {
  final _products = RxList<Product>([]);
  final _loading = Rx<ConnectionState>(ConnectionState.waiting);

  @override
  void onInit() {
    Future.delayed(Duration.zero, () async => getProducts());
    super.onInit();
  }

  Future<void> getProducts() async {
    final result = await MakeupService().getProducts();
    _products(result);
    _loading(ConnectionState.done);
  }

  List<Product> get products => _products;

  bool get loading => _loading.value != ConnectionState.done;
}
