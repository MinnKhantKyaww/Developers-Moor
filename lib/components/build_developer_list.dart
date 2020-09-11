import 'package:developers_moor/database/developers_database.dart';
import 'package:developers_moor/screen/developer_edit_page.dart';
import 'package:developers_moor/screen/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildDeveloperList extends StatefulWidget {

  bool onChange = false;
  String nameValue;

  BuildDeveloperList({this.onChange, this.nameValue});

  @override
  _BuildDeveloperListState createState() => _BuildDeveloperListState();
}

class _BuildDeveloperListState extends State<BuildDeveloperList> {
  @override
  Widget build(BuildContext context) {

    final developersDao = Provider.of<DevelopersDao>(context);

    return StreamBuilder(
      stream: onChange ? developersDao.watchAllFiltersDevelopers(name: widget.nameValue) : developersDao.watchAllDevelopers(),
      builder: (context, AsyncSnapshot<List<Developer>> snapshot) {
        final developers = snapshot.data ?? List();
        return ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              indent: 16,
              height: 1,
            );
          },
          padding: EdgeInsets.all(8.0),
          itemCount: developers.length,
          itemBuilder: (context, index) {
            final developerItem = developers[index];
            return _buildDeveloperItem(developerItem, developersDao, context);
          },
        );
      },
    );
  }
}

Widget _buildDeveloperItem(
    Developer developer, DevelopersDao developersDao, BuildContext context) {
  return Dismissible(
    key: Key(developer.id.toString()),
    direction: DismissDirection.endToStart,
    background: Container(
      alignment: Alignment.centerRight,
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Delete",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    onDismissed: (direction) {
      developersDao.deleteDevelopers(developer);
    },
    confirmDismiss: (direction) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Are you sure want to delete?"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("NO"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("YES"),
              ),
            ],
          );
        }
      );
    },
    child: _buildListTile(context, developer, developersDao),
  );
}

ListTile _buildListTile(BuildContext context, Developer developer, DevelopersDao developersDao) {
  return ListTile(
    onTap: () {
      showDialog<bool>(
        context: context,
        child: DeveloperEditPage(developer: developer),
      ).then((result) {
        developersDao.watchAllDevelopers();
      });
    },
    leading: CircleAvatar(
      radius: 30,
      backgroundColor: Colors.blueGrey[700],
    ),
    title: Text("${developer.name ?? "None"}"),
    subtitle: Text("${developer.heading ?? "None"}"),
    trailing: Text(developer.age.toString()),
  );
}
