import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  String? _confirmNewPassword;

  bool _isLoading = true;
  late SupabaseAuthService authService;
  late User? user;

  @override
  void initState() {
    super.initState();
    authService = Provider.of<SupabaseAuthService>(context, listen: false);
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    user = authService.getCurrentUser();
    if (user != null) {
      _newUsername = await authService.getUsernameByUserId(user!.id);
      _newEmail = user!.email;
      _newPhone = await authService.getPhoneByUserId(user!.id);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: warnaKopi2,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Email: $_newEmail",
                        style: const TextStyle(
                          fontFamily: "poppinsregular",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: warnaKopi2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Username: $_newUsername",
                        style: const TextStyle(
                          fontFamily: "poppinsregular",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: warnaKopi2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildTextField("Nomor HP", _newPhone ?? '',
                        (value) => _newPhone = value),
                    const SizedBox(height: 20),
                    buildTextField("Password Lama", "",
                        (value) => _currentPassword = value, false, true),
                    const SizedBox(height: 20),
                    buildTextField("Password Baru", "",
                        (value) => _newPassword = value, false, true),
                    const SizedBox(height: 20),
                    buildTextField("Konfirmasi Password Baru", "", (value) {
                      _confirmNewPassword = value;
                      if (_newPassword != null &&
                          _confirmNewPassword != null &&
                          _newPassword != _confirmNewPassword) {
                        return 'Password baru dan konfirmasi tidak cocok';
                      }
                      return null;
                    }, false, true),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: warnaKopi2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    if (_newPassword != _confirmNewPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Password baru dan konfirmasi tidak cocok!')),
                      );
                      return;
                    }

                    try {
                      if (_currentPassword != null && _newPassword != null) {
                        if (_currentPassword!.isEmpty ||
                            _newPassword!.isEmpty ||
                            _confirmNewPassword!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Harap isi semua kolom password!')),
                          );
                          return;
                        }

                        bool isPasswordCorrect = await authService
                            .verifyCurrentPassword(_currentPassword!);
                        if (!isPasswordCorrect) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Password lama salah!')),
                          );
                          return;
                        }

                        if (_newPassword == _currentPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Password baru tidak boleh sama dengan password lama!')),
                          );
                          return;
                        }

                        await authService.updateUserPassword(
                          currentPassword: _currentPassword!,
                          newPassword: _newPassword!,
                        );
                      }

                      await authService.updateUserProfile(
                        userId: user!.id,
                        newUsername: _newUsername!,
                        newEmail: _newEmail!,
                        newPhone: _newPhone!,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Profil berhasil diperbarui!')),
                      );

                      Navigator.pop(context, true);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal memperbarui profil: $e')),
                      );
                    }
                  }
                },
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(
                      fontFamily: "poppinsregular",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, String initialValue, Function(String?) onSaved,
      [bool isEmail = false, bool isPassword = false]) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: warnaKopi,
          fontFamily: "poppinsregular",
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: warnaKopi2, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
      obscureText: isPassword,
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong'; // Validasi untuk memastikan kolom tidak kosong
        }
        return null;
      },
    );
  }
}
