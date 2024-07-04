// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../database_helper_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final DatabaseHelperProfile _databaseHelper = DatabaseHelperProfile();
  bool _isEditing = false;
  int? _profileId;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _databaseHelper.getProfile();
    if (profile != null) {
      setState(() {
        _profileId = profile['id'];
        _nameController.text = profile['name'];
        _emailController.text = profile['email'];
        _genderController.text = profile['gender'];
        _phoneController.text = profile['phone'];
      });
    }
  }

  Future<void> _saveProfile() async {
    final profile = {
      'id': _profileId,
      'name': _nameController.text,
      'email': _emailController.text,
      'gender': _genderController.text,
      'phone': _phoneController.text,
    };

    if (_profileId == null) {
      // Insert new profile if it doesn't exist
      await _databaseHelper.insertProfile(profile);
    } else {
      // Update existing profile
      await _databaseHelper.updateProfile(profile);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved!')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(
              radius: 65,
              backgroundImage: AssetImage('assets/Profile1.png'),
            ),
            const SizedBox(height: 20),
            _buildProfileField('Nama', _nameController, enabled: _isEditing),
            const SizedBox(height: 20),
            _buildProfileField('Email', _emailController, enabled: _isEditing),
            const SizedBox(height: 20),
            _buildProfileField('Jenis Kelamin', _genderController, enabled: _isEditing),
            const SizedBox(height: 20),
            _buildProfileField('No Hp', _phoneController, enabled: _isEditing),
            const SizedBox(height: 30),
            if (_isEditing)
              ElevatedButton(
                onPressed: () => _confirmSaveProfile(context),
                child: const Text('Simpan Profile'),
              ),
            const SizedBox(height: 10), // Padding tambahan agar tidak terlalu rapat dengan tombol
            if (!_isEditing)
              TextButton(
                onPressed: _startEditing,
                child: const Text('Edit Profil'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            enabled: enabled,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _confirmSaveProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Anda yakin ingin menyimpan perubahan?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _saveProfile();
              setState(() {
                _isEditing = false;
              });
            },
            child: const Text('Ya'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }
}
