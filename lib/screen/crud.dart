import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shoes_shop/screen/drawer.dart';

import '../utils/database_instance.dart';

class Crud extends StatefulWidget {
  const Crud({super.key});

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  var produk = TextEditingController();
  var editProduk = TextEditingController();
  DatabaseInstance? databaseInstance;

  Future initDatabase() async {
    await databaseInstance!.database();
    setState(() {});
  }

  Future delete(int id) async {
    await databaseInstance!.delete(id);
    setState(() {});
  }

  @override
  void initState() {
    databaseInstance = DatabaseInstance();
    initDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        width: 200,
        backgroundColor: Colors.transparent,
        child: DrawerScren(),
      ),
      appBar: AppBar(
        title: const Text('CRUD'),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Container(
                // ignore: prefer_const_constructors
                padding: EdgeInsets.only(left: 20, right: 20),
                // color: Colors.amber,
                child: Column(
                  children: [
                    TextField(
                      controller: produk,
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(labelText: 'Add Produk'),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              await databaseInstance!
                                  .insert({'nama': produk.text});
                              produk.clear();
                              setState(() {});
                            },
                            child: const Text('Add'))
                      ],
                    )
                  ],
                ),
              )),
          const Divider(thickness: 2),
          Expanded(
              flex: 5,
              child: databaseInstance != null
                  ? FutureBuilder<List<ProdukModel>>(
                      future: databaseInstance!.all(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // ignore: prefer_is_empty
                          if (snapshot.data!.length == 0) {
                            return const Center(
                              child: Text('Data kosong'),
                            );
                          }
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(snapshot.data![index].name),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        editProduk.text =
                                            snapshot.data![index].name;
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.question,
                                          animType: AnimType.rightSlide,
                                          body: TextField(
                                            controller: editProduk,
                                          ),
                                          btnOkOnPress: () async {
                                            await databaseInstance!.update(
                                                snapshot.data![index].id,
                                                {'nama': editProduk.text});
                                            setState(() {});
                                          },
                                        ).show();
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.question,
                                                animType: AnimType.rightSlide,
                                                title: 'Hapus data?',
                                                btnOkOnPress: () => delete(
                                                    snapshot.data![index].id))
                                            .show();
                                      },
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red)),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return const Center(child: Text('Belum ada data'));
                        }
                      },
                    )
                  : const Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}
