import 'package:flutter/material.dart';
import 'package:shoes_shop/dto/datas.dart';
import 'package:shoes_shop/screen/mahasiswa/form_screen.dart';
import 'package:shoes_shop/screen/services/data_service.dart';
import 'package:shoes_shop/screen/endpoints/endpoints.dart';
import 'package:shoes_shop/screen/drawer.dart';

class DatasScreen extends StatefulWidget {
  const DatasScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DatasScreenState createState() => _DatasScreenState();
}

class _DatasScreenState extends State<DatasScreen> {
  Future<List<Datas>>? _datas;

  @override
  void initState() {
    super.initState();
    _datas = DataService.fetchDatas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DATAS'),
      ),
       drawer: const Drawer(
        width: 200,
        backgroundColor: Colors.transparent,
        child: DrawerScren(),
      ),
      body: Center(
        child: FutureBuilder<List<Datas>>(
          future: _datas,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final post = snapshot.data!;
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final data = post[index];
                  return ListTile(
                    title: Text(data.name),
                    // ignore: unnecessary_null_comparison
                    subtitle: data.imageUrl != null
                        ? Row(
                            children: [
                              Image.network(
                                fit: BoxFit.fitWidth,
                                width: 350,
                                Uri.parse(
                                        '${Endpoints.baseURLLive}/public/${data.imageUrl}')
                                    .toString(),
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons
                                        .error), // Display error icon if image fails to load
                              ),
                            ],
                          )
                        : null,
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // Show a loading indicator while waiting for data
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 102, 149, 139),
        tooltip: 'Increment',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}