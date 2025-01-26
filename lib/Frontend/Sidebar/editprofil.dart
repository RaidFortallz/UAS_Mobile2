import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_mobile2/Backend/Provider/supabase_auth.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _newUsername;
  String? _newEmail;
  String? _newPhone;
  String? _currentPassword;
  String? _newPassword;

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<SupabaseAuthService>(context, listen: false);
    final user = authService.getCurrentUser();

    // Jika user tidak ditemukan, tampilkan halaman error
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profil'),
          backgroundColor: warnaKopi3,
        ),
        body: const Center(
          child: Text("Pengguna tidak ditemukan."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: warnaKopi3,
        elevation: 0, // Menghilangkan shadow pada app bar
      ),
      body: SingleChildScrollView(
        // Menambahkan scroll view untuk responsif
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Field Email
              TextFormField(
                initialValue: user.email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: warnaKopi3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: warnaKopi3, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                onSaved: (value) {
                  _newEmail = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Field Username
              TextFormField(
                initialValue: user.userMetadata?['username'] ?? '',
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: const TextStyle(color: warnaKopi3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: warnaKopi3, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                onSaved: (value) {
                  _newUsername = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Field Nomor HP
              TextFormField(
                initialValue: user.userMetadata?['phone_number'] ?? '',
                decoration: InputDecoration(
                  labelText: 'Nomor HP',
                  labelStyle: const TextStyle(color: warnaKopi3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: warnaKopi3, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                onSaved: (value) {
                  _newPhone = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor HP tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Field Password Lama
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password Lama',
                  labelStyle: const TextStyle(color: warnaKopi3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: warnaKopi3, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                onSaved: (value) {
                  _currentPassword = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password lama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Field Password Baru
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  labelStyle: const TextStyle(color: warnaKopi3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: warnaKopi3, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                onSaved: (value) {
                  _newPassword = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password baru tidak boleh kosong';
                  }
                  if (value.length < 6) {
                    return 'Password baru harus lebih dari 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Field Konfirmasi Password Baru
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  labelStyle: const TextStyle(color: warnaKopi3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: warnaKopi3, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                onSaved: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password tidak boleh kosong';
                  }
                  if (value != _newPassword) {
                    return 'Password baru dan konfirmasi password tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: warnaKopi3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    if (_newUsername != null &&
                        _newEmail != null &&
                        _newPhone != null) {
                      try {
                        // Memperbarui data profil pengguna di Supabase
                        await authService.updateUserProfile(
                          userId: user.id,
                          newUsername: _newUsername!,
                          newEmail: _newEmail!,
                          newPhone: _newPhone!,
                        );

                        // Memperbarui password jika ada perubahan
                        if (_newPassword != null && _currentPassword != null) {
                          await authService.updateUserPassword(
                            currentPassword: _currentPassword!,
                            newPassword: _newPassword!,
                          );
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Profil berhasil diperbarui!')),
                        );
                        Navigator.pop(context); // Kembali ke halaman profil
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Gagal memperbarui profil: $e')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tolong isi semua data!')),
                      );
                    }
                  }
                },
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
