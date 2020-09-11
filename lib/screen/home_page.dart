import 'package:developers_moor/database/developers_database.dart';
import 'package:developers_moor/screen/developer_edit_page.dart';
import 'package:flutter/cupertino.dart';
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

bool onChange = false;

void saveDeveloper(
    BuildContext context, DevelopersDao developersDao, Developer developer) {
  final route = CupertinoPageRoute<bool>(
    builder: (context) => DeveloperEditPage(
      developer: developer,
    ),
  );

  Navigator.push(context, route);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController;

  String _heading;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchTextField(BuildContext context) {
    final developersDao = Provider.of<DevelopersDao>(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )),
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
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  value.isEmpty ? onChange = false : onChange = true;
                });
                developersDao.watchAllFiltersDevelopers(name: value);
              },
              cursorColor: Colors.black,
              autofocus: false,
              decoration: InputDecoration.collapsed(
                hintText: "Search...",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip() {
    final developerDao = Provider.of<DevelopersDao>(context);

    return Container(
      color: Colors.grey.shade50,
      height: 46,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: languages.length,
        itemBuilder: (context, index) {
          var selected = _heading == languages[index];
          return ChoiceChip(
            selected: selected,
            label: Text(
              languages[index],
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
              ),
            ),
            selectedColor: Theme.of(context).primaryColor,
            onSelected: (selected) {
              setState(() {
                _heading = selected ? languages[index] : "";
              });
              _heading != null && _heading.isNotEmpty
                  ? onChange = true
                  : onChange = false;
              developerDao.watchAllFiltersDevelopers(heading: _heading);
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
            });
      },
      child: _buildListTile(context, developer, developersDao),
    );
  }

  ListTile _buildListTile(
      BuildContext context, Developer developer, DevelopersDao developersDao) {
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: _buildSearchTextField(context),
      bottom: PreferredSize(
        child: _buildFilterChip(),
        preferredSize: Size.fromHeight(45),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final developersDao = Provider.of<DevelopersDao>(context);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: StreamBuilder(
        stream: onChange
            ? developersDao.watchAllFiltersDevelopers(
                name: _searchController.text, heading: _heading)
            : developersDao.watchAllDevelopers(),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveDeveloper(context, developersDao, Developer());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
