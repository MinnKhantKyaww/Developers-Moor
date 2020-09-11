import 'package:developers_moor/database/developers_database.dart';
import 'package:flutter/material.dart' hide Column;
import 'package:flutter/widgets.dart' as f show Column;
import 'package:moor_flutter/moor_flutter.dart';
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

class DeveloperEditPage extends StatefulWidget {
  final Developer developer;

  const DeveloperEditPage({this.developer});

  @override
  _DeveloperEditPageState createState() => _DeveloperEditPageState();
}

class _DeveloperEditPageState extends State<DeveloperEditPage> {
  TextEditingController _nameController;
  TextEditingController _ageController;

  String _heading;

  AppBar _appBar(
      BuildContext context, DevelopersDao developersDao, String heading) {
    return AppBar(
      title: Text(
        widget.developer.id == null ? "Create" : "Update",
      ),
      actions: [
        FlatButton(
            child: Text(
              "SAVE",
              style: TextStyle(color: Colors.white),
            ),
            shape: CircleBorder(),
            onPressed: () {
              if (widget.developer.id == null) {
                final d = DevelopersCompanion(
                    name: Value(_nameController.text),
                    age: Value(int.parse(_ageController.text)),
                    heading: Value(_heading));
                developersDao.insertDevelopers(d).whenComplete(() {
                  Navigator.of(context).pop(true);
                });
              } else {
                developersDao
                    .updateDevelopers(Developer(
                        id: widget.developer.id,
                        name: _nameController.text,
                        age: int.parse(_ageController.text),
                        heading: _heading))
                    .whenComplete(() {
                  Navigator.of(context).pop(true);
                });
              }
            })
      ],
    );
  }

  Widget _buildChoiceChip() {
    final pos = languages.indexOf(_heading);
    final controller = ScrollController(initialScrollOffset: pos * 50.0);

    return Container(
      height: 50,
      child: ListView.separated(
        itemCount: languages.length,
        controller: controller,
        itemBuilder: (context, index) {
          final selected = languages[index] == _heading;
          return ChoiceChip(
            label: Text(
              languages[index],
              style: TextStyle(color: selected ? Colors.white : Colors.black),
            ),
            selected: selected,
            backgroundColor: Colors.grey,
            onSelected: (selected) {
              setState(() {
                _heading = languages[index];
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

  @override
  void initState() {
    _nameController = TextEditingController(text:  widget.developer.name);
    _ageController = TextEditingController(text: "${widget.developer.age ?? ""}");
    _heading = widget.developer.heading ?? languages[0];
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final developersDao = Provider.of<DevelopersDao>(context);

    final widgets = [
      TextField(
        controller: _nameController,
        decoration: InputDecoration(
          labelText: "Name",
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      TextField(
        controller: _ageController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Age",
          border: OutlineInputBorder(),
        ),
      ),
      _buildChoiceChip(),
    ];

    if (widget.developer.id != null) {
      widgets.add(SizedBox(
        height: 16,
      ));
      widgets.add(RaisedButton(
        color: Color(0xffd50002),
        elevation: 0,
        padding: const EdgeInsets.all(16),
        onPressed: () {
          developersDao.deleteDevelopers(widget.developer).whenComplete(() {
            Navigator.of(context).pop(true);
          });
        },
        child: Text(
          "DELETE",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    }

    return Scaffold(
        appBar: _appBar(context, developersDao, _heading),
        body: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: f.Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: widgets,
              ),
            ),
          ),
        ));
  }
}
