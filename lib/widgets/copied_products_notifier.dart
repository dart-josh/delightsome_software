import 'package:delightsome_software/dataModels/productStoreModels/productItem.model.dart';
import 'package:delightsome_software/globalvariables.dart';
import 'package:flutter/material.dart';

class CopiedProductsNotifier extends StatelessWidget {
  const CopiedProductsNotifier({super.key, required this.pasteFn});

  final Function(List<ProductItemModel>) pasteFn;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: copied_product,
      builder: (context, value, child) {
        if (value.isEmpty) return SizedBox();

        return InkWell(
          onTap: () => pasteFn(value),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(4),
                ),
                height: 25,
                margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                padding: EdgeInsets.only(left: 38, top: 2, right: 10),
                child: Text(
                  'Paste products',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0.5, 0.5),
                        color: Colors.white12,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Center(
                    child: Icon(Icons.paste, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
