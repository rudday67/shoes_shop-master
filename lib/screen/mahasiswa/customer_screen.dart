import 'package:flutter/material.dart';
import 'package:shoes_shop/component/bottom_up.dart';
import 'package:shoes_shop/dto/customer_service.dart';
import 'package:shoes_shop/screen/customer_edit.dart';
import 'package:shoes_shop/screen/drawer.dart';
import 'package:shoes_shop/screen/endpoints/endpoints.dart';
import 'package:shoes_shop/screen/services/data_service.dart';
import 'package:shoes_shop/screen/mahasiswa/customer_form.dart';

class CustomerServiceScreen extends StatefulWidget {
  const CustomerServiceScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomerServiceScreenState createState() => _CustomerServiceScreenState();
}

class _CustomerServiceScreenState extends State<CustomerServiceScreen> {
  Future<List<CustomerService>>? _customerService;

  @override
  void initState() {
    super.initState();
    _customerService = DataService.fetchCustomerService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Service List'),
      ),
      drawer: const Drawer(
        width: 200,
        backgroundColor: Colors.transparent,
        child: DrawerScren(),
      ),
      body: FutureBuilder<List<CustomerService>>(
        future: _customerService,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: const Color.fromARGB(255, 112, 85, 46),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: item.imageUrl != null
                        ? Image.network(
                            '${Endpoints.baseURLLive}/public/${item.imageUrl!}',
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          )
                        : const SizedBox(width: 80, height: 80),
                    title: Text(
                      item.titleIssues,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Description: ${item.descriptionIssues}',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Division: ${item.divisionDepartementTarget}',
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Priority: ${item.priorityName}',
                        ),
                        const SizedBox(height: 8),
                        // Add rating bar here
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          onPressed: () =>
                              _showDeleteConfirmationDialog(context, item),
                          icon: const Icon(Icons.delete),
                        ),
                        IconButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditDataScreen(issues: item),
                            ),
                          ),
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            BottomUpRoute(page: const Form2Screen()),
          );
          if (result == true) {
            setState(() {
              _customerService = DataService.fetchCustomerService();
            });
          }
        },
        tooltip: 'Add New Customer Service',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, CustomerService datas) async {
    final bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Data'),
        content:
            Text('Are you sure you want to delete this ${datas.titleIssues}?'),
        actions: [
          TextButton(
            onPressed: () {
              // Tidak jadi menghapus, kembali dengan nilai false
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Konfirmasi untuk menghapus, kembali dengan nilai true
              Navigator.of(context).pop(true);
              try {
                // Hapus data dengan memanggil metode DataService.deleteCustomerService
                await DataService.deleteCustomerService(datas.idCustomerService);
                // Refresh data setelah berhasil menghapus
                setState(() {
                  _customerService = DataService.fetchCustomerService();
                });
                // Tampilkan snackbar atau pesan berhasil dihapus
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data deleted successfully'),
                  ),
                );
              } catch (e) {
                // Tangani kesalahan jika gagal menghapus data
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete data: $e'),
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    // Jika pengguna mengonfirmasi penghapusan, lanjutkan penghapusan
    if (confirmed) {
      // Hapus data
    }
  }
}

