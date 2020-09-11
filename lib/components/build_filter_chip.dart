import 'package:developers_moor/database/developers_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const languages = [
  "JAVA",
  "KOTLIN",
  "PYTHON",
  "SWIFT",
  "DART",
  "C++",
  "React Native"
];

class BuildFilterChip extends StatefulWidget {

  String heading;

  TextEditingController searchController;

  BuildFilterChip({this.heading, this.searchController});

  @override
  _BuildFilterChipState createState() => _BuildFilterChipState();
}

class _BuildFilterChipState extends State<BuildFilterChip> {
  @override
  Widget build(BuildContext context) {

    final developerDao = Provider.of<DevelopersDao>(context);

    return Container(
      color: Colors.grey.shade50,
      height: 46,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: languages.length,
        itemBuilder: (context, index) {
          var selected = widget.heading == languages[index];
          return ChoiceChip(
            selected: selected,
            label: Text(languages[index],
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
              ),),
            selectedColor: Theme.of(context).primaryColor,
            onSelected: (selected) {
              widget.heading = selected ? languages[index] : null;
              developerDao.watchAllFiltersDevelopers(
                  name: widget.searchController.text);
            },
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 8,
          );
        },
      ),
    );
  }
}

