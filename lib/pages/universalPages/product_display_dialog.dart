import 'package:delightsome_software/appColors.dart';
import 'package:delightsome_software/dataModels/productStoreModels/productItem.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:delightsome_software/helpers/universalHelpers.dart';
import 'package:delightsome_software/utils/appdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDisplayDialog extends StatelessWidget {
  const ProductDisplayDialog(
      {super.key, required this.products, required this.id, required this.displayPrice});

  final List<ProductItemModel> products;
  final String id;
  final bool displayPrice;

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        height: 300,
        child: Column(
          children: [
            // top bar
            top_bar(context),

            // content
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 2),
                padding: EdgeInsets.only(bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkTheme
                      ? AppColors.dark_dialogBackground_1
                      : AppColors.light_dialogBackground_1,
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Column(
                      children:
                          products.map((p) => productTile(context, p)).toList(),
                    ),
                  ),
                ),
              ),
            ),

            // copy button
            copy_button(context),
          ],
        ),
      ),
    );
  }

  // WIDGETS
  Widget top_bar(context) {
    return Container(
      width: double.infinity,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.primaryForegroundColor,
      child: Stack(
        children: [
          // action buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // close button
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: AppColors.secondaryWhiteIconColor,
                  size: 22,
                ),
              ),

              Expanded(child: Container()),
            ],
          ),

          // title
          Center(
            child: Text(
              'Products - ${id}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget productTile(context, ProductItemModel product) {
    bool isDarkTheme =
        Provider.of<AppData>(context).themeMode == ThemeMode.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: isDarkTheme
              ? AppColors.dark_borderColor
              : AppColors.light_borderColor,
        ),
        borderRadius: BorderRadius.circular(6),
        color: Colors.transparent,
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // product name
              Text(
                product.product.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),

              Text(
                product.quantity.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkTheme
                      ? AppColors.dark_secondaryTextColor
                      : AppColors.light_secondaryTextColor,
                ),
              ),

              if (product.price != 0 && product.quantity != 0 && displayPrice)
                Text(
                  UniversalHelpers.format_number(
                      product.price * product.quantity,
                      currency: true),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkTheme
                        ? AppColors.dark_secondaryTextColor
                        : AppColors.light_secondaryTextColor,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // copy button
  Widget copy_button(context) {
    return InkWell(
      onTap: () {
        copied_product.value = products;
        UniversalHelpers.showToast(
          context: context,
          color: Colors.blue,
          toastText: 'Products copied',
          icon: Icons.check,
        );
      },
      child: Container(
        width: double.infinity,
        height: 35,
        padding: EdgeInsets.symmetric(horizontal: 8),
        color: AppColors.orange_1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.copy_all, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'Copy Products',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  //
}
