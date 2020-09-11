import 'package:developers_moor/database/developers_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildSearchTextField extends StatefulWidget {

  TextEditingController searchController;

  BuildSearchTextField({this.searchController});

  @override
  _BuildSearchTextFieldState createState() => _BuildSearchTextFieldState();
}

class _BuildSearchTextFieldState extends State<BuildSearchTextField> {


  @override
  void initState() {
    widget.searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final developersDao = Provider.of<DevelopersDao>(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        )
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.grey,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              controller: widget.searchController,
              onChanged: (value) {
                developersDao.watchAllFiltersDevelopers(
                  name: value
                );
              },
              cursorColor: Colors.black,
              decoration: InputDecoration.collapsed(
                  hintText: "Search...", filled: true, fillColor: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
