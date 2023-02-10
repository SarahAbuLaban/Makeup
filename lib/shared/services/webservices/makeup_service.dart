import 'package:lets_makeup/shared/services/local_database.dart';

import 'index.dart';
import '../../../model/product.dart';

class MakeupService extends NetworkRequests {
  Future<List<Product>> getProducts() async {
    final response = await getRequest(path: 'products.json');
    final jsonResponse = decodeResponse(response);

    LocalDatabase().insertList(List<Map<String, dynamic>>.from(jsonResponse));
    
    return List<Product>.from(jsonResponse.map((e) => Product.fromJson(e)));
  }
}