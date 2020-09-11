import 'package:developers_moor/screen/developer_edit_page.dart';
import 'package:flutter/material.dart';

const languages = [
  "JAVA",
  "KOTLIN",
  "PYTHON",
  "SWIFT",
  "DART",
  "C++",
  "React Native"
];



class BuildChoiceChip extends StatefulWidget {

  String heading;

  BuildChoiceChip({this.heading});

  @override
  _BuildChoiceChipState createState() => _BuildChoiceChipState();
}

class _BuildChoiceChipState extends State<BuildChoiceChip> {
  @override
  Widget build(BuildContext context) {

    final pos = languages.indexOf(widget.heading);
    final controller = ScrollController(initialScrollOffset: pos * 50.0);

    return Container(
      height: 50,
      child: ListView.separated(
        itemCount: languages.length,
        controller: controller,
        itemBuilder: (context, index) {
          final selected = languages[index] == widget.heading;
          return ChoiceChip(
            label: Text(
              languages[index],
              style: TextStyle(color: selected ? Colors.white : Colors.black),
            ),
            selected: selected,
            backgroundColor: Colors.grey,
            onSelected: (selected) {
              setState(() {
                widget.heading = languages[index];
              });
            },
            avatar: selected
                ? Icon(
              Icons.check_circle,
              color: Colors.white,
            )
                : null,
            selectedColor: Theme.of(context).primaryColor,
          );
        },
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 8,
          );
        },
      ),
    );
  }
}

