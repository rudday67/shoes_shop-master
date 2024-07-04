import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shoes_shop/screen/mahasiswa/mahasiswa_page.dart';

class DetailMahasiswa extends StatefulWidget {
  const DetailMahasiswa({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;

  @override
  // ignore: library_private_types_in_public_api
  _DetailMahasiswaState createState() => _DetailMahasiswaState();
}

class _DetailMahasiswaState extends State<DetailMahasiswa> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _body = TextEditingController();
  final TextEditingController _nimmahasiswa = TextEditingController();
  final TextEditingController _namamahasiswa = TextEditingController();
  final TextEditingController _kelasmahasiswa = TextEditingController();
  final TextEditingController _dataprestasi = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  } 

  Future<void> fetchData() async {
    try {
      final String id = widget.id; // Get the ID passed to the widget
      final response = await http.get(
        Uri.parse(
            'https://66038e2c2393662c31cf2e7d.mockapi.io/api/v1/news/$id'),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        _title.text = jsonData['title'];
        _body.text = jsonData['body'];
        _nimmahasiswa.text = jsonData['nim'];
        _namamahasiswa.text = jsonData['Nama'];
        _kelasmahasiswa.text = jsonData['Kelas'];
        _dataprestasi.text = jsonData['data'];
      } else {
        // ignore: avoid_print
        print('Gagal mendapatkan data: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error: $e');
    }
  }

  Future<void> _updateData() async {
    
    try {
      final Map<String, dynamic> updatedData = {
        'title': _title.text,
        'body': _body.text,
        'nim': _nimmahasiswa.text,
        'Nama': _namamahasiswa.text,
        'Kelas': _kelasmahasiswa.text,
        'data':_dataprestasi.text,
      };

      final response = await http.put(
        Uri.parse('https://66038e2c2393662c31cf2e7d.mockapi.io/api/v1/news/${widget.id}'),
        body: jsonEncode(updatedData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Data berhasil diperbarui
        Navigator.pop(
            // ignore: use_build_context_synchronously
            context); // Kembali ke halaman sebelumnya setelah berhasil memperbarui data
      } else {
        // Gagal memperbarui data
      }
    // ignore: empty_catches
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Mahasiswa')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Jenis Pendaftaran :'),
              ),
              TextFormField(
                controller: _body,
                decoration: const InputDecoration(labelText: 'Program Pendidikan :'),
              ),
              TextFormField(
                controller: _namamahasiswa,
                decoration:
                    const InputDecoration(labelText: 'Nomor Induk Mahasiswa:'),
              ),
              TextFormField(
                controller: _nimmahasiswa,
                decoration: const InputDecoration(labelText: 'Nama Mahasiswa:'),
              ),
              TextFormField(
                controller: _kelasmahasiswa,
                decoration: const InputDecoration(labelText: 'Kelas Mahasiswa'),
              ),
              TextFormField(
                controller: _dataprestasi,
                decoration: const InputDecoration(labelText: 'Data prestasi'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Panggil metode untuk memperbarui data saat tombol "Simpan" ditekan
                  _updateData();
                    ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Data berhasil diupdate'), // Tampilkan pesan "Data berhasil ditambahkan"
                                    backgroundColor: Colors.green, // Ganti warna Snackbar menjadi hijau
                              ),
                            );
                },
                child: const Text('Simpan'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MahasiswaScreen()));
                },
                child: const Text('Batal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}