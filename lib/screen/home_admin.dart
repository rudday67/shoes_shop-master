// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_shop/screen/login_admin.dart';
import 'package:shoes_shop/shoe.dart';
import 'package:shoes_shop/shoe_provider.dart';
import 'package:image_picker/image_picker.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  Shoe? _selectedShoe;

  @override
  void initState() {
    super.initState();
    // Load shoes when the widget is first created
    Provider.of<ShoeProvider>(context, listen: false).loadShoes();
  }

  void _showDeleteDialog(Shoe shoe) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: const Text('Apakah Anda yakin untuk hapus?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await Provider.of<ShoeProvider>(context, listen: false)
                    .deleteShoe(shoe.id);
                Navigator.of(context).pop(); // Close the delete confirmation dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ).then((_) {
      // Refresh shoe list after delete
      Provider.of<ShoeProvider>(context, listen: false).loadShoes();
    });
  }

  void _showEditDialog(Shoe shoe) {
    _selectedShoe = shoe;
    _nameController.text = shoe.name;
    _priceController.text = shoe.price;
    _imageController.text = shoe.image;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _imageController.text.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(_imageController.text),
                            fit: BoxFit.cover,
                            height: 150,
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: () async {
                          final imagePicker =
                              Provider.of<ShoeProvider>(context, listen: false);
                          final imageSource =
                              await showDialog<ImageSource>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: const Text('Choose image source'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.camera_alt),
                                      title: const Text('Camera'),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pop(ImageSource.camera);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.photo_library),
                                      title: const Text('Gallery'),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pop(ImageSource.gallery);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );

                          if (imageSource == null) return;

                          // ignore: unnecessary_nullable_for_final_variable_declarations
                          final String? imagePath =
                              await imagePicker.pickImage(imageSource);

                          if (imagePath != null) {
                            setState(() {
                              _imageController.text = imagePath;
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final updatedShoe = Shoe(
                            id: _selectedShoe!.id,
                            name: _nameController.text,
                            price: _priceController.text,
                            image: _imageController.text,
                          );
                          await Provider.of<ShoeProvider>(context, listen: false)
                              .updateShoe(updatedShoe);
                          Navigator.of(context).pop();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the current dialog
                          _showDeleteDialog(shoe); // Show delete confirmation dialog
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Edit name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      hintText: 'Edit price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    final imagePicker = Provider.of<ShoeProvider>(context, listen: false);

    final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Choose image source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );

    if (imageSource == null) return;

    // ignore: unnecessary_nullable_for_final_variable_declarations
    final String? imagePath = await imagePicker.pickImage(imageSource);

    if (imagePath != null) {
      setState(() {
        _imageController.text = imagePath;
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _imageController.text.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(_imageController.text),
                            fit: BoxFit.cover,
                            height: 150,
                          ),
                        )
                      : Container(),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Shoe name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      hintText: 'Shoe price',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final newShoe = Shoe(
                        id: DateTime.now().millisecondsSinceEpoch,
                        name: _nameController.text,
                        price: _priceController.text,
                        image: _imageController.text,
                      );
                      await Provider.of<ShoeProvider>(context, listen: false)
                          .addShoe(newShoe);
                      Navigator.of(context).pop();
                    },
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginAdmin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Data Sepatu',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Consumer<ShoeProvider>(
                builder: (context, provider, child) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: provider.shoes.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        _showEditDialog(provider.shoes[index]);
                      },
                      child: Container(
                        height: 120,
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.5),
                                blurRadius: 5,
                              )
                            ]),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 90,
                              width: 90,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  File(provider.shoes[index].image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    provider.shoes[index].name,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      provider.shoes[index].price,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      _showCreateDialog(context);
                    },
                    child: const Icon(Icons.add),
                  ),
                  FloatingActionButton(
                    onPressed: _logout,
                    child: const Icon(Icons.logout),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
