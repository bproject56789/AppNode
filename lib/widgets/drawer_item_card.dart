import 'package:flutter/material.dart';
import 'package:ylc/models/local/drawer_item_model.dart';

class DrawerItemCard extends StatelessWidget {
  final DrawerItemModel model;
  final VoidCallback onTap;
  final Color color;

  const DrawerItemCard({Key key, this.model, this.onTap, this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: model.image != null
                  ? Image.asset(model.image, color: color)
                  : Container(),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(model.title),
            ),
          ],
        ),
      ),
    );
  }
}
