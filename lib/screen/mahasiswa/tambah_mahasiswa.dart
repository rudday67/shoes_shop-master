// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shoes_shop/screen/mahasiswa/mahasiswa_page.dart';

class MahasiswaBaru extends StatefulWidget {
  const MahasiswaBaru({Key? key}) : super(key: key);

  @override
  _MahasiswaBaruState createState() => _MahasiswaBaruState();
}

class _MahasiswaBaruState extends State<MahasiswaBaru> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _body = TextEditingController();
  final TextEditingController _nimmahasiswa = TextEditingController();
  final TextEditingController _namamahasiswa = TextEditingController();
  final TextEditingController _kelasmahasiswa = TextEditingController();
  final TextEditingController _dataprestasi = TextEditingController();


  bool _isFormIncomplete = false;

  Future<void> _tambahData() async {
    try {
      final Map<String, dynamic> newData = {
        'title': _title.text,
        'body': _body.text,
        'nim': _nimmahasiswa.text,
        'Nama': _namamahasiswa.text,
        'Kelas': _kelasmahasiswa.text,
        'data':_dataprestasi.text,
        
      };

      final response = await http.post(
        Uri.parse('https://66038e2c2393662c31cf2e7d.mockapi.io/api/v1/news'),
        body: jsonEncode(newData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        // Data berhasil ditambahkan
        print('Data berhasil ditambahkan');
        Navigator.pop(
            context); // Kembali ke halaman sebelumnya setelah berhasil menambahkan data
      } else {
        // Gagal menambahkan data
        print('Gagal menambahkan data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pendaftaran'),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, // Mengaitkan GlobalKey dengan widget Form
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _title,
                    decoration:
                        const InputDecoration(labelText: 'Jenis Pendaftaran :'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Harap isi data terlebih dahulu';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _body,
                    decoration:
                        const InputDecoration(labelText: 'Program Pendidikan :'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Harap isi data terlebih dahulu';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _namamahasiswa,
                    decoration:
                        const InputDecoration(labelText: 'Nomor Induk Mahasiswa:'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Harap isi data terlebih dahulu';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _nimmahasiswa,
                    decoration: const InputDecoration(labelText: 'Nama Mahasiswa:'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Harap isi data terlebih dahulu';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _kelasmahasiswa,
                    decoration: const InputDecoration(labelText: 'Kelas Mahasiswa'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Harap isi data terlebih dahulu';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _dataprestasi,
                    decoration:
                        const InputDecoration(labelText: 'Data Prestasi :'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Harap isi data terlebih dahulu';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Tambahkan async karena _tambahData() adalah operasi async
                          if (_formKey.currentState!.validate()) {
                            await _tambahData(); // Tunggu hingga _tambahData() selesai
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Data berhasil ditambahkan'), // Tampilkan pesan "Data berhasil ditambahkan"
                                    backgroundColor: Colors.green, // Ganti warna Snackbar menjadi hijau
                              ),
                            );
                          } else {
                            setState(() {
                              _isFormIncomplete =
                                  true; // Setel _isFormIncomplete menjadi true saat validasi gagal
                            });
                          }
                        },
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all(
                              const Size(150, 50)), // Set minimum size
                        ),
                        child: const Text('Simpan'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MahasiswaScreen()));
                        },
                        // ignore: sort_child_properties_last
                        child: const Text('Batal'),
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all(
                              const Size(150, 50)), // Set minimum size
                        ),
                      ),
                    ],
                  ),
                  if (_isFormIncomplete)
                    const Text(
                      '',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            )),
      ),
    );
  }
}
