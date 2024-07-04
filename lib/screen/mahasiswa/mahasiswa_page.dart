// ignore_for_file: library_private_types_in_public_api, sort_child_properties_last

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoes_shop/dto/news.dart';
import 'package:shoes_shop/screen/mahasiswa/data_mahasiswa.dart';
import 'package:shoes_shop/screen/mahasiswa/tambah_mahasiswa.dart';

class MahasiswaScreen extends StatefulWidget {
  const MahasiswaScreen({Key? key}) : super(key: key);

  @override
  _MahasiswaScreenState createState() => _MahasiswaScreenState();
}

class _MahasiswaScreenState extends State<MahasiswaScreen> {
  //Method
  Future<List<News>> _getData() async {
    try {
      final response = await http.get(
          Uri.parse('https://66038e2c2393662c31cf2e7d.mockapi.io/api/v1/news'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<News> newsList =
            data.map((item) => News.fromJson(item)).toList();
        return newsList;
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<void> _deleteData(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(
            'https://66038e2c2393662c31cf2e7d.mockapi.io/api/v1/news/$id'),
      );

      if (response.statusCode == 200) {
        // Refresh data setelah penghapusan berhasil
        setState(() {});
      } else {
        throw Exception('Failed to delete news');
      }
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Mahasiswa')),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Add your navigation logic here, for example:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MahasiswaBaru()),
        );
      },
      child: const Icon(Icons.add),
      shape: const CircleBorder(),
    ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<News>>(
              future: _getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final post = snapshot.data![index];
                      return Card(
                        elevation: 3,
                        margin:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(post.title),
                                subtitle: Text(post.body),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailMahasiswa(
                                        id: post
                                            .id), // Mengirimkan ID mahasiswa
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Delete"),
                                      content: const Text(
                                          "Anda yakin ingin menghapus data ini?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await _deleteData(post.id);
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Delete"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
