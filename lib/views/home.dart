import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lets_makeup/controllers/product.dart';
import 'package:lets_makeup/shared/index.dart';
import 'package:lets_makeup/shared/services/local_database.dart';
import 'package:lets_makeup/shared/utils/text_utils.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:share_plus/share_plus.dart';

import '../model/product.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = Get.put(ProductController(), tag: 'product_controller');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Center(
          child: Text(
            'Makeup',
            style: TextStyle(color: kPrimary),
          ),
        ),
      ),
      body: Obx(() {
        return LoadingOverlay(
          isLoading: controller.loading,
          color: kPrimary,
          progressIndicator: const CircularProgressIndicator(
            backgroundColor: kPrimary,
            color: kSecondary,
          ),
          child: Obx(() {
            if (controller.products.isEmpty && !controller.loading) {
              return const Center(
                child: Text('No Products to show!\nCome back another time :)'),
              );
            }
            return ListView.builder(
                itemCount: controller.products.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(kPadding),
                itemBuilder: (context, index) {
                  final product = controller.products[index];
                  return Column(
                    children: [
                      cell(product),
                      const SizedBox(
                        height: kPadding,
                      )
                    ],
                  );
                });
          }),
        );
      }),
    );
  }

  Widget cell(final Product product) {
    return Container(
      padding: const EdgeInsets.all(kPadding / 2),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
          ),
          borderRadius: BorderRadius.circular(kPadding * 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(kPadding),
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 200,
                ),
                child: Stack(
                  children: [
                    Builder(
                      builder: (context) {
                        if (TextUtils.isEmpty(product.image)) {
                          return Image.asset(
                            'assets/splash.webp',
                            width: double.maxFinite,
                            fit: BoxFit.fitWidth,
                          );
                        }
                        return Image.network(product.image!,
                            width: double.maxFinite, fit: BoxFit.fitWidth,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                          return Image.asset(
                            'assets/splash.webp',
                            width: double.maxFinite,
                            fit: BoxFit.fitWidth,
                          );
                        });
                      },
                    ),
                    GestureDetector(
                      onTap: () async {
                        final result = await LocalDatabase().getProduct(product.id);

                        Share.share(
                            result?.name! ?? "",
                          subject: result?.description
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(kPadding / 2),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle
                              // borderRadius: BorderRadius.circular(16)
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: kPadding, vertical: kPadding / 2),
                          child:const Icon(Icons.share,color: kPrimary,),
                        ),
                      ),
                    )
                  ],
                ),
              )),
          const SizedBox(
            height: kPadding / 2,
          ),
          Container(
            padding: const EdgeInsets.all(kPadding / 2),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(kPadding * 2)),
            child: Text(product.category ?? ""),
          ),
          const SizedBox(
            height: kPadding / 2,
          ),
          Text(
            product.name ?? "",
            style:
                const TextStyle(color: kPrimary, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: kPadding / 2,
          ),
          Text(product.description ?? ""),
          const SizedBox(
            height: kPadding / 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final tag in product.tags ?? [])
                      Container(
                        padding: const EdgeInsets.all(kPadding / 2),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(kPadding)),
                        child: Text(tag),
                      ),
                  ],
                ),
              ),
              Text(
                '${product.price} ${product.priceSign}',
                style: Theme.of(context).textTheme.headline6?.copyWith(),
              )
            ],
          ),
          const SizedBox(
            height: kPadding / 2,
          ),
          if (product.colors?.isNotEmpty ?? false) ...[
            Text(
              'Colors:',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: kPadding / 2,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final color in product.colors ?? [])
                  Container(
                    padding: const EdgeInsets.all(kPadding / 2),
                    decoration: BoxDecoration(
                        color: Color(int.parse(
                            '0x0FF${color['hex_value'].toString().replaceFirst('#', '')}')),
                        borderRadius: BorderRadius.circular(kPadding)),
                    child: Text(color['colour_name']),
                  ),
              ],
            ),
          ],
          // Row(
          //   children: [
          //     for (final color in product.colors ?? [])
          //       Expanded(
          //           child: Container(
          //         height: 10,
          //         color: Color(int.parse(
          //             '0x0FF${color['hex_value'].toString().replaceFirst('#', '')}')),
          //       ))
          //   ],
          // ),
          const SizedBox(
            height: kPadding / 2,
          ),
        ],
      ),
    );
  }
}
