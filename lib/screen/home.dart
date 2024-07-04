import 'dart:io';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shoes_shop/shoe_provider.dart';
import 'package:shoes_shop/shoe.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  List<Shoe> _filteredShoes = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShoeProvider>(context, listen: false).loadShoes();
    });
  }

  void _filterShoes(String query) {
    final provider = Provider.of<ShoeProvider>(context, listen: false);
    setState(() {
      if (query.isEmpty) {
        _filteredShoes = provider.shoes;
      } else {
        _filteredShoes = provider.shoes
            .where((shoe) => shoe.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShoeProvider>(context);
    _filteredShoes =
        _searchController.text.isEmpty ? provider.shoes : _filteredShoes;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for shoes...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: _filterShoes,
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: _filteredShoes.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.rightSlide,
                      title:
                          'Hubungi penjual ${_filteredShoes[index].name}?',
                      btnOkText: 'Hubungi',
                      btnOkOnPress: () async {
                        // ignore: deprecated_member_use
                        if (!await launch(
                            'https://wa.me/6281353902427')) {
                          throw 'Could not launch WhatsApp';
                        }
                      },
                    ).show();
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
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 90,
                          width: 90,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              File(_filteredShoes[index].image),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                _filteredShoes[index].name,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  _filteredShoes[index].price,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
