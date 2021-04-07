import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ylc/models/enums/category_enum.dart';
import 'package:ylc/ui/advocates/advocates_page.dart';
import 'package:ylc/ui/advocates/custom_consultation.dart';
import 'package:ylc/ui/homepage/all_categories_page.dart';
import 'package:ylc/values/colors.dart';
import 'package:ylc/values/images.dart';
import 'package:ylc/values/strings.dart';
import 'package:ylc/widgets/category_card.dart';
import 'package:ylc/widgets/navigaton_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<CategoryType> categoriesOnHomePage = [
    CategoryType.Family,
    CategoryType.RealEstate,
    CategoryType.Insurance,
    CategoryType.LabourEmployment,
    CategoryType.Criminal,
    CategoryType.Immigration,
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 12),
            Container(
              height: 250,
              width: double.infinity,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          YlcColors.colorFilterWarm,
                          BlendMode.hue,
                        ),
                        child: Image.asset(
                          GeneralImages.appBarImage,
                          height: 200,
                          // color: YlcColors.colorFilterWarm,
                          // colorBlendMode: BlendMode.softLight,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      Strings.yourLegalConsultancy,
                      style: GoogleFonts.lora(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 55,
                      child: Hero(
                        tag: "search",
                        child: GestureDetector(
                          onTap: () {
                            navigateToPage(context, AllCategoriesPage());
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 4,
                            child: TextField(
                              decoration: InputDecoration(
                                enabled: false,
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                prefixIcon: Icon(Icons.search),
                                hintText: Strings.whatAreYouLookingFor,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(width: 8),
                Text(Strings.expertise),
                Spacer(),
                FlatButton(
                  child: Text('View All'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AllCategoriesPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: categoriesOnHomePage.length,
                itemBuilder: (_, index) {
                  return CategoryCard(
                    model: categoriesOnHomePage[index].data,
                    isSelected: true,
                    onTap: () => navigateToPage(
                      context,
                      AdvocatesPage(model: categoriesOnHomePage[index].data),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: YlcColors.categoryBackGround,
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 113,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(Strings.homePageHelpText1),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(Strings.homePageHelpText2),
                        SizedBox(width: 8),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: Stack(
                            children: [
                              Image.asset(
                                CustomIcons.nextIcon,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    navigateToPage(
                                      context,
                                      CustomConsultation(),
                                    );
                                  },
                                  child: Icon(
                                    Icons.navigate_next,
                                    color: YlcColors.categoryBackGround,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
