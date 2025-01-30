import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_mobile2/Frontend/Sidebar/edit_profile.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';
import 'package:uas_mobile2/Backend/Provider/supabase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';
  String email = '';
  String phone = '';
  File? profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final authService =
        Provider.of<SupabaseAuthService>(context, listen: false);
    final user = authService.getCurrentUser();

    if (user != null) {
      final userId = user.id;
      try {
        final usernameFromDb = await authService.getUsernameByUserId(userId);
        final emailFromDb =
            await authService.getEmailByUsername(usernameFromDb ?? '');
        final phoneFromDb = await authService.getPhoneByUserId(userId);

        setState(() {
          username = usernameFromDb ?? '';
          email = emailFromDb ?? '';
          phone = phoneFromDb ?? '';
        });
      } catch (e) {
        log("Error loading profile: $e", name: "ProfilePage");
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });

      try {
        final authService =
            Provider.of<SupabaseAuthService>(context, listen: false);
        final userId = authService.getCurrentUser()?.id;
        if (userId != null && profileImage != null) {
          final fileName = 'profile_images/$userId.jpg';
          await Supabase.instance.client.storage
              .from('profile_images')
              .upload(fileName, profileImage!);
          log("Profile image uploaded successfully", name: "ProfilePage");
        }
      } catch (e) {
        log("Error uploading profile image: $e", name: "ProfilePage");
      }
    }
  }

  // Fungsi untuk menavigasi ke halaman edit profil
  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      ),
    );

    if (result == true) {
      _loadProfile(); // Memuat ulang profil jika ada perubahan
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                children: [
                  // Header
                  const Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.person,
                          size: 80,
                          color: warnaKopi3,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Profile Saya',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: warnaKopi3,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Header dengan gambar profil
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: profileImage != null
                          ? FileImage(profileImage!)
                          : null,
                      child: profileImage == null
                          ? const Icon(
                              Icons.camera_alt,
                              size: 30,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildProfileInfo(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Tombol Edit Profil
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _navigateToEditProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: warnaKopi3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'Edit Profil',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tombol Kembali
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: warnaKopi3),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'Kembali',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: warnaKopi3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Username', username),
            _buildInfoRow('Email', email),
            _buildInfoRow('Nomor HP', phone),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            value.isEmpty ? 'Tidak ada data' : value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
