import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uas_mobile2/Backend/Provider/supabase_auth.dart';
import 'package:uas_mobile2/Frontend/Halaman_User/Sidebar/edit_profile.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';
  String email = '';
  String phone = '';
  String? profileImageUrl;
  File? profileImage;

  @override
  void initState() {
    super.initState();
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
        final imageUrl = await authService.getProfileImage();

        setState(() {
          username = usernameFromDb ?? '';
          email = emailFromDb ?? '';
          phone = phoneFromDb ?? '';
          profileImageUrl = imageUrl;
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
    }
  }

  Future<void> _saveProfileImage() async {
    if (profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pilih gambar terlebih dahulu!',
            style: TextStyle(
              fontFamily: "poppinsregular",
            ),
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    try {
      final authService =
          Provider.of<SupabaseAuthService>(context, listen: false);
      await authService.updateProfileImage(profileImage!);
      await _loadProfile();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Gambar profil berhasil diperbarui!',
              style: TextStyle(
                fontFamily: "poppinsregular",
              ),
            ),
            backgroundColor: warnaKopi3,
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      log("Gagal memperbarui gambar profil: $e", name: "ProfilePage");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Gagal memperbarui gambar profil!',
              style: TextStyle(
                fontFamily: "poppinsregular",
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showFullImage() {
    if (profileImage == null &&
        (profileImageUrl == null || profileImageUrl!.isEmpty)) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: profileImage != null
                  ? Image.file(profileImage!)
                  : Image.network(
                      profileImageUrl!,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.red,
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfilePage(),
      ),
    );

    if (result == true) {
      _loadProfile();
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
                        Icon(Icons.person, size: 80, color: warnaKopi2),
                        SizedBox(height: 16),
                        Text(
                          'Profile Saya',
                          style: TextStyle(
                            fontFamily: "poppinsregular",
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: warnaKopi2,
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  Center(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: _showFullImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: profileImage != null
                                ? FileImage(profileImage!)
                                : (profileImageUrl != null &&
                                        profileImageUrl!.isNotEmpty
                                    ? NetworkImage(profileImageUrl!)
                                    : null),
                            child: (profileImage == null &&
                                    (profileImageUrl == null ||
                                        profileImageUrl!.isEmpty))
                                ? const Icon(Icons.person,
                                    size: 50, color: Colors.white)
                                : null,
                          ),
                        ),

                        // Tombol + di kanan bawah CircleAvatar
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: warnaKopi2,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.add,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  _buildProfileInfo(),
                  const SizedBox(height: 20),

                  // Tombol Simpan Gambar
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 190,
                      child: ElevatedButton(
                        onPressed: _saveProfileImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: warnaKopi2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: const Text(
                          'Simpan Gambar',
                          style: TextStyle(
                            fontFamily: "poppinsregular",
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 85),

                  // Tombol Edit Profil
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _navigateToEditProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: warnaKopi2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 15),
                      ),
                      child: const Text(
                        'Edit Profil',
                        style: TextStyle(
                          fontFamily: "poppinsregular",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
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
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: warnaKopi2),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 15),
                      ),
                      child: const Text(
                        'Kembali',
                        style: TextStyle(
                          fontFamily: "poppinsregular",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: warnaKopi2,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
          Text(title,
              style: const TextStyle(
                  fontFamily: "poppinsregular",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
          Text(value.isEmpty ? 'Tidak ada data' : value,
              style: const TextStyle(
                  fontFamily: "poppinsregular",
                  fontSize: 14,
                  color: Colors.black54)),
        ],
      ),
    );
  }
}
