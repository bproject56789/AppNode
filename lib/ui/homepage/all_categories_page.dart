import 'package:flutter/material.dart';
import 'package:ylc/models/enums/category_enum.dart';
import 'package:ylc/ui/advocates/advocates_page.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/category_card.dart';
import 'package:ylc/widgets/custom_app_bar.dart';
import 'package:ylc/widgets/navigaton_helper.dart';

class AllCategoriesPage extends StatefulWidget {
  @override
  _AllCategoriesPageState createState() => _AllCategoriesPageState();
}

class _AllCategoriesPageState extends State<AllCategoriesPage> {
  List<CategoryType> data = [];

  @override
  void initState() {
    data = List.from(CategoryType.values);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Strings.expertise,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Hero(
              tag: "search",
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
                child: TextField(
                  onChanged: (v) {
                    setState(
                      () {
                        if (v.isEmpty || v == null) {
                          data = List.from(CategoryType.values);
                        } else {
                          data = List.from(CategoryType.values);
                          data.retainWhere(
                            (element) =>
                                element.data.title.toLowerCase().contains(
                                      v.toLowerCase(),
                                    ),
                          );
                        }
                      },
                    );
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(Icons.search),
                    hintText: Strings.whatAreYouLookingFor,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: data.isEmpty
                  ? Center(
                      child: Text("No categories found"),
                    )
                  : GridView.count(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 20),
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      children: data
                          .map(
                            (e) => CategoryCard(
                              model: e.data,
                              isSelected: true,
                              onTap: () => navigateToPage(
                                context,
                                AdvocatesPage(model: e.data),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
