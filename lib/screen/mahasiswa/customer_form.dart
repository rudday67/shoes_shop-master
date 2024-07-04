import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shoes_shop/screen/endpoints/endpoints.dart';

class Form2Screen extends StatefulWidget {
  const Form2Screen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Form2ScreenState createState() => _Form2ScreenState();
}

class _Form2ScreenState extends State<Form2Screen> {
  final _titleController = TextEditingController();
  final _ratingController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _divisionDepartementTargetController = TextEditingController();
  final _priorityNameController = TextEditingController();

  File? galleryFile;
  final picker = ImagePicker();

  _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);
    setState(() {
      if (pickedFile != null) {
        galleryFile = File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing is selected')),
        );
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ratingController.dispose();
    _descriptionController.dispose();
    _divisionDepartementTargetController.dispose();
    _priorityNameController.dispose();
    super.dispose();
  }

  saveData() {
    debugPrint(_titleController.text);
  }

  Future<void> _postDataWithImage(BuildContext context) async {
    if (galleryFile == null) {
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(Endpoints.CustomerService),
    );
    request.fields['title_issues'] = _titleController.text;
    request.fields['description_issues'] = _descriptionController.text;
    request.fields['rating'] = _ratingController.text.toString();
    request.fields['division_departement_target'] =
        _divisionDepartementTargetController.text;
    request.fields['priority_name'] = _priorityNameController.text;

    var multipartFile = await http.MultipartFile.fromPath(
      'image',
      galleryFile!.path,
    );
    request.files.add(multipartFile);

    request.send().then((response) {
      if (response.statusCode == 201) {
        debugPrint('Data and image posted successfully!');
        Navigator.of(context).pop(true);
      } else {
        debugPrint('Error posting data: ${response.statusCode}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Data',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo, // Mengubah warna background AppBar
        elevation: 0,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                border:
                                    Border(bottom: BorderSide(color: Colors.indigo)),
                              ),
                              width: double.infinity,
                              height: 150,
                              child: galleryFile == null
                                  ? const Center(
                                      child: Text(
                                        'Pick your Image here',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Image.file(galleryFile!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(_titleController, "Title of Image"),
                        _buildTextField(_descriptionController, "Description"),
                        _buildTextField(_ratingController, "Rating 1-5"),
                        _buildTextField(
                            _divisionDepartementTargetController, "Division"),
                        _buildTextField(_priorityNameController, "Priority"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          _postDataWithImage(context);
        },
        child: const Icon(Icons.save, color: Colors.white),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[800]),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }
}
