import 'package:flutter/material.dart';
import 'package:ylc/models/enums/category_enum.dart';
import 'package:ylc/ui/advocates/advocates_page.dart';
import 'package:ylc/widgets/navigaton_helper.dart';

enum AdvocateType {
  Verified,
  NotVerified,
}

class CustomConsultation extends StatefulWidget {
  @override
  _CustomConsultationState createState() => _CustomConsultationState();
}

class _CustomConsultationState extends State<CustomConsultation> {
  CategoryType type;
  AdvocateType advocateType;
  ExperienceData selectedData;

  final borderside = BorderSide(
    width: 0.2,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Consultation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: DropdownButton<CategoryType>(
                value: type,
                hint: Text('Select a category'),
                items: CategoryType.values
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text(e.data.title),
                        value: e,
                      ),
                    )
                    .toList(),
                onChanged: (type) {
                  setState(() {
                    this.type = type;
                  });
                },
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Advocate Type',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 12),
            Card(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey),
                ),
                child: Row(
                  children: [
                    advocateTypeBuilder(
                      AdvocateType.Verified,
                    ),
                    advocateTypeBuilder(
                      AdvocateType.NotVerified,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Experience',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 12),
            Card(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey),
                ),
                child: Row(
                  children: [
                    experienceBuilder(ExperienceData(null, 5, separator: '<')),
                    experienceBuilder(ExperienceData(5, 10)),
                    experienceBuilder(ExperienceData(11, 15)),
                    experienceBuilder(ExperienceData(null, 15, separator: '>')),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: RaisedButton(
                child: Text('Search'),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onPressed:
                    type != null && advocateType != null && selectedData != null
                        ? () {
                            navigateToPage(
                              context,
                              AdvocatesPage(
                                advocatePageData: AdvocatePageData(
                                  type.data.title,
                                  advocateType == AdvocateType.Verified,
                                  selectedData,
                                ),
                              ),
                            );
                          }
                        : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget advocateTypeBuilder(AdvocateType type) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            advocateType = type;
          });
        },
        child: Container(
          alignment: Alignment.center,
          height: 100,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: type == advocateType ? Colors.red : Colors.grey,
              ),
              top: borderside,
              right: borderside,
              left: borderside,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                foregroundColor:
                    type == AdvocateType.Verified ? Colors.green : Colors.red,
                child: Icon(
                  type == AdvocateType.Verified ? Icons.check : Icons.clear,
                ),
              ),
              Text(type == AdvocateType.Verified ? 'Verified' : 'Not verified'),
            ],
          ),
        ),
      ),
    );
  }

  Widget experienceBuilder(ExperienceData data) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedData = data;
          });
        },
        child: Container(
          alignment: Alignment.center,
          height: 100,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 3,
                color: data == selectedData ? Colors.red : Colors.grey,
              ),
              top: borderside,
              right: borderside,
              left: borderside,
            ),
          ),
          child: Text(
            '${data.lowerLimit ?? ''} ${data.separator} ${data.upperLimit ?? ''}\nYears',
          ),
        ),
      ),
    );
  }
}

class ExperienceData {
  final int lowerLimit;
  final int upperLimit;
  final String separator;

  ExperienceData(this.lowerLimit, this.upperLimit, {this.separator = '-'});

  bool operator ==(covariant ExperienceData other) {
    return this.lowerLimit == other.lowerLimit &&
        this.upperLimit == other.upperLimit;
  }

  @override
  int get hashCode => super.hashCode;
}
