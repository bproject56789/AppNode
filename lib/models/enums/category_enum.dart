import 'package:ylc/models/local/category_model.dart';
import 'package:ylc/values/images.dart';
import 'package:ylc/values/strings.dart';

enum CategoryType {
  Family,
  RealEstate,
  Insurance,
  LabourEmployment,
  Criminal,
  Immigration,
  Education,
  Tax,
  Civil,
  Environmental,
  BankingFinance,
  Investment,
  IntellectualProperty,
  DisputeResolution,
  Corporate,
}

extension Data on CategoryType {
  CategoryModel get data {
    CategoryModel _model;
    switch (this) {
      case CategoryType.Family:
        _model = CategoryModel(CategoryImages.family, Strings.family);
        break;
      case CategoryType.RealEstate:
        _model = CategoryModel(CategoryImages.realEstate, Strings.realEstate);
        break;
      case CategoryType.Insurance:
        _model = CategoryModel(CategoryImages.insurance, Strings.insurance);
        break;
      case CategoryType.LabourEmployment:
        _model = CategoryModel(CategoryImages.labour, Strings.labourEmployment);
        break;
      case CategoryType.Criminal:
        _model = CategoryModel(CategoryImages.jail, Strings.criminal);
        break;
      case CategoryType.Immigration:
        _model = CategoryModel(CategoryImages.immigrant, Strings.immigration);
        break;
      case CategoryType.Education:
        _model = CategoryModel(CategoryImages.education, Strings.education);
        break;
      case CategoryType.Tax:
        _model = CategoryModel(CategoryImages.tax, Strings.tax);
        break;
      case CategoryType.Civil:
        _model = CategoryModel(CategoryImages.civil, Strings.civil);
        break;
      case CategoryType.Environmental:
        _model = CategoryModel(CategoryImages.sprout, Strings.environmental);
        break;
      case CategoryType.BankingFinance:
        _model = CategoryModel(CategoryImages.banking, Strings.bankingFinance);
        break;
      case CategoryType.Investment:
        _model = CategoryModel(CategoryImages.investing, Strings.investment);
        break;
      case CategoryType.IntellectualProperty:
        _model = CategoryModel(
            CategoryImages.property, Strings.intellectualProperty);
        break;
      case CategoryType.DisputeResolution:
        _model =
            CategoryModel(CategoryImages.dispute, Strings.disputeResolution);
        break;
      case CategoryType.Corporate:
        _model = CategoryModel(CategoryImages.corporate, Strings.corporate);
        break;
    }
    return _model;
  }
}
