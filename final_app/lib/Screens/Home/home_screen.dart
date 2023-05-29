import 'package:flutter/material.dart';
import 'package:first_app/constants.dart';
import 'package:first_app/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

/*class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> items = [
    Item(
        name: 'Tent',
        description: 'A waterproof 2-person tent',
        price: 20,
        image: 'assets/images/tent.jpg'),
    Item(
        name: 'Sleeping bag',
        description: 'A warm sleeping bag',
        price: 10,
        image: 'assets/images/sleepingBag.jpg'),
    Item(
        name: 'Camp stove',
        description: 'A portable gas stove',
        price: 15,
        image: 'assets/images/stove.jpg'),
  ];

  final _newItemNameController = TextEditingController();
  final _newItemDescriptionController = TextEditingController();
  final _newItemPriceController = TextEditingController();
  final _newItemImageController = TextEditingController();

  void _addItem() {
    final newItemName = _newItemNameController.text;
    final newItemDescription = _newItemDescriptionController.text;
    final newItemPrice = double.tryParse(_newItemPriceController.text) ?? 0.0;
    final newItemImage = _newItemImageController.text;

    if (newItemName.isNotEmpty) {
      setState(() {
        items.add(Item(
          name: newItemName,
          description: newItemDescription,
          price: newItemPrice,
          image: newItemImage,
        ));
      });

      _newItemNameController.clear();
      _newItemDescriptionController.clear();
      _newItemPriceController.clear();
      _newItemImageController.clear();
    }
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  void _logout() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _showItemDetails(Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailsPage(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: Color(0xFF608478),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Items:'),
            SizedBox(height: defaultPadding * 0.3),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(items[index].name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteItem(index),
                  ),
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        items[index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () => _showItemDetails(items[index]),
                ),
              ),
            ),
            TextField(
              controller: _newItemNameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _newItemDescriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _newItemPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: _newItemImageController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addItem,
              child: Text('Add'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _logout,
              child: Text('Log out'),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  final String name;
  final String description;
  final double price;
  final String image;

  const Item({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });
}

class ItemDetailsPage extends StatelessWidget {
  final Item item;

  const ItemDetailsPage({required this.item});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:
          AppBar(title: Text(item.name), backgroundColor: Color(0xFF608478)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                item.image,
                height: size.height * 0.4,
              ),
            ),
            SizedBox(height: defaultPadding),
            Text(
              item.description,
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
                  '\$${item.price}',
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
*/

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: Color(0xFF608478),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Items:'),
            SizedBox(height: defaultPadding * 0.3),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _database.getItems(widget.loggedInUser),
                builder: (context, snapshot) {
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
            Column(
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
                /*TextButton(
                  onPressed: () async {
                    try {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if (result != null && result.count > 0) {
                        setState(() {
                          _newItemImageController.text =
                              result.files.single.path!;
                        });
                      }
                    } catch (e) {
                      print('Error picking image: $e');
                    }
                  },
                  child: Column(
                    children: [
                      if (_newItemImageController.text.isNotEmpty)
                        Image.file(File(_newItemImageController.text)),
                      const SizedBox(height: 7),
                      Text('Select Image'),
                    ],
                  ),
                ),*/
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _addItem(widget.loggedInUser),
              child: Text('Add'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Logout'),
            ),
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
