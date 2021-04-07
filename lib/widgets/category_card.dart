import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ylc/models/local/category_model.dart';
import 'package:ylc/values/colors.dart';
import 'package:ylc/values/images.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel model;
  final VoidCallback onTap;
  final isSelected;

  const CategoryCard({Key key, this.model, this.onTap, this.isSelected = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? YlcColors.categoryBackGround : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Image.asset(
                GeneralImages.categoryShade,
                color: YlcColors.categoryForeGround,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(model.image),
                    Spacer(),
                    SizedBox(
                      width: constraints.maxWidth * 0.8,
                      child: Text(
                        model.title,
                        style: GoogleFonts.lora(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = YlcColors.categoryForeGround.withOpacity(0.5);

    path.moveTo(0, 0);
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.07, size.height * 0.71,
        size.width * 0.1, size.height * 0.69);
    path.lineTo(size.height * 0.7, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CategoryPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(CategoryPainter oldDelegate) => false;
}
