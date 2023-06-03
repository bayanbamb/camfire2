import 'package:flutter/material.dart';
import 'package:first_app/constants.dart';
import 'package:first_app/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class EmptyScreen extends StatefulWidget {
  final String loggedInUser;

  EmptyScreen({required this.loggedInUser});

  @override
  _EmptyScreenState createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen> {
  final _database = DBHelper();
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 100.0,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 176, 206, 196),
            ),
            child: Container(
              padding: EdgeInsets.only(top: 50.0),
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen(loggedInUser: widget.loggedInUser),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.account_circle,
                      size: 40.0,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                  ),
                  SizedBox(width: 16.0),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    child: Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: defaultPadding),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _database.getItems2(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final items = snapshot.data!;

                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () =>
                                _showItemDetails(context, items[index]),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        items[index]['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      items[index]['name'],
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      '\$${items[index]['price']}',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                        top: 0,
                                                        left: 55,
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          _rentItem(
                                                              items[index]
                                                                  ['id'],
                                                              widget
                                                                  .loggedInUser,
                                                              context);
                                                        },
                                                        child: Text(
                                                          'Rent',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        style: TextButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Color(0xFF608478),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 0),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showItemDetails(BuildContext context, Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailsPage(item: item),
      ),
    );
  }

  void _rentItem(int id, String loggedInUser, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('Confirm Rent'),
        content: Text('Are you sure you want to rent this item?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _database.rentItem(id, loggedInUser);
              setState(() {});
              Navigator.pop(dialogContext);
            },
            child: Text('Rent'),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String loggedInUser;

  HomeScreen({required this.loggedInUser});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DBHelper _database;
  final _newItemNameController = TextEditingController();
  final _newItemDescriptionController = TextEditingController();
  final _newItemPriceController = TextEditingController();
  final _newItemImageController = TextEditingController();
  bool _showAddForm = false;

  @override
  void initState() {
    super.initState();
    _database = DBHelper();
  }

  void dispose() {
    _newItemNameController.dispose();
    _newItemDescriptionController.dispose();
    _newItemPriceController.dispose();
    _newItemImageController.dispose();
    super.dispose();
  }

  void _addItem(String loggedInUser) async {
    final newItemName = _newItemNameController.text;
    final newItemDescription = _newItemDescriptionController.text;
    final newItemPrice = double.tryParse(_newItemPriceController.text) ?? 0.0;
    final newItemImage = _newItemImageController.text;

    if (newItemName.isNotEmpty && newItemPrice != 0.0) {
      await _database.insertItems(
        newItemName,
        newItemDescription,
        newItemPrice,
        newItemImage,
        loggedInUser,
      );

      setState(() {
        _newItemNameController.clear();
        _newItemDescriptionController.clear();
        _newItemPriceController.clear();
        _newItemImageController.clear();
        _showAddForm = false;
      });
    } else {
      Fluttertoast.showToast(
          msg:
              "The name or price of the item is missing, please fill in the field");
    }
  }

  void _deleteItem(int id, BuildContext context) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await _database.deleteItem(id);
      setState(() {});
    }
  }

  void _logout(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _showItemDetails(BuildContext context, Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailsPage(item: item),
      ),
    );
  }

  void _returnItem(int id, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text('Confirm Return'),
        content: Text('Are you ready to return this item?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _database.returnItem(id);
              setState(() {});
              Navigator.pop(dialogContext);
            },
            child: Text('Return'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        backgroundColor: Color(0xFF608478),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Own Items:'),
            SizedBox(height: defaultPadding * 0.3),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _database.getItems(widget.loggedInUser),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final items = snapshot.data!;

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(items[index]['name']),
                      subtitle: Text('\$${items[index]['price']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            _deleteItem(items[index]['id'], context),
                      ),
                      leading: SizedBox(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            items[index]['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onTap: () => _showItemDetails(context, items[index]),
                    ),
                  );
                },
              ),
            ),
            Text('Items I Have Rented:'),
            SizedBox(height: defaultPadding * 0.3),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _database.getRentedItems(widget.loggedInUser),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final items = snapshot.data!;

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(items[index]['name']),
                      subtitle: Text('\$${items[index]['price']} (Rented)'),
                      trailing: TextButton(
                        onPressed: () =>
                            _returnItem(items[index]['id'], context),
                        child: Text('Return'),
                      ),
                      leading: SizedBox(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            items[index]['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onTap: () => _showItemDetails(context, items[index]),
                    ),
                  );
                },
              ),
            ),
            Offstage(
              offstage: !_showAddForm,
              child: Column(
                children: [
                  TextField(
                    controller: _newItemNameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 7),
                  TextField(
                    controller: _newItemDescriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  SizedBox(height: 7),
                  TextField(
                    controller: _newItemPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Price'),
                  ),
                  SizedBox(height: 7),
                  TextField(
                    controller: _newItemImageController,
                    decoration: InputDecoration(labelText: 'Image URL'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _addItem(widget.loggedInUser),
                    child: Text('Done'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showAddForm = true;
                });
              },
              child: Text('Add An Item'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class ItemDetailsPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemDetailsPage({required this.item});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:
          AppBar(title: Text(item['name']), backgroundColor: Color(0xFF608478)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item['image'],
                height: size.height * 0.4,
              ),
            ),
            SizedBox(height: defaultPadding),
            Text(
              item['description'],
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Price: ',
                  style: TextStyle(fontSize: 25),
                ),
                Text(
                  '\$${item['price']}',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
