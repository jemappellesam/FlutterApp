import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/profile_model.dart';
import '../services/database_helper.dart';
import '../widgets/animated_profile_border.dart';
import 'streaming_home_screen.dart';
import '../app_constants.dart';

class ProfileSelectionScreen extends StatefulWidget {
  const ProfileSelectionScreen({super.key});

  @override
  State<ProfileSelectionScreen> createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  late Future<List<Profile>> _profilesFuture;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final double _avatarRadius = 40.0;
  bool _isEditing = false;
  bool _showAddButton = true;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  void _loadProfiles() {
    setState(() {
      _profilesFuture = _dbHelper.getProfiles();
    });
  }

  void _showAddProfileDialog() {
    setState(() => _showAddButton = false);
    showDialog(
      context: context,
      builder: (context) => EditProfileDialog(
        profile: Profile(name: '', imagePath: availableImages.first),
        onSaved: () {
          _loadProfiles();
          setState(() => _showAddButton = true);
        },
        isNewProfile: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _showAddButton && !_isEditing
          ? FloatingActionButton(
              onPressed: _showAddProfileDialog,
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF6200EA), Color(0xFF121212)],
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Quem está assistindo?",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: FutureBuilder<List<Profile>>(
                          future: _profilesFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Erro ao carregar perfis: ${snapshot.error}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }

                            final profiles = snapshot.data!;

                            return GridView.builder(
                              padding: const EdgeInsets.only(bottom: 16),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: profiles.length + 1,
                              itemBuilder: (context, index) {
                                if (index == profiles.length) {
                                  return _buildAddProfileButton(context);
                                }
                                final profile = profiles[index];
                                return _buildProfileCard(profile, context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _isEditing = !_isEditing),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: Icon(
                    _isEditing ? Icons.done : Icons.edit,
                    color: Colors.white,
                  ),
                  label: Text(
                    _isEditing ? 'Concluir Edição' : 'Editar Perfis',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(Profile profile, BuildContext context) {
    return GestureDetector(
      onTap: () => _isEditing 
          ? _showEditDialog(profile) 
          : _navigateToHomeScreen(context, profile),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedProfileBorder(
                imageUrl: profile.imagePath,
                radius: _avatarRadius,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  profile.name,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          if (_isEditing)
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                onPressed: () => _showEditDialog(profile),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddProfileButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isEditing) return;
        _showAddProfileDialog();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _avatarRadius * 2,
            height: _avatarRadius * 2,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(_avatarRadius),
              border: Border.all(color: Colors.white30),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 8),
          Text(
            'Adicionar Perfil',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }

  void _showEditDialog(Profile profile) {
    showDialog(
      context: context,
      builder: (context) => EditProfileDialog(
        profile: profile,
        onSaved: _loadProfiles,
        isNewProfile: false,
      ),
    );
  }

  void _navigateToHomeScreen(BuildContext context, Profile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreamingHomeScreen(
          profileImage: profile.imagePath,
        ),
      ),
    );
  }
}

class EditProfileDialog extends StatefulWidget {
  final Profile profile;
  final VoidCallback onSaved;
  final bool isNewProfile;

  const EditProfileDialog({
    required this.profile,
    required this.onSaved,
    this.isNewProfile = false,
    super.key,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _nameController;
  late String _selectedImagePath;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _selectedImagePath = widget.profile.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[850],
      title: Text(
        widget.isNewProfile ? 'Criar Novo Perfil' : 'Editar Perfil',
        style: const TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Nome',
                  labelStyle: const TextStyle(color: Colors.white70),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite um nome para o perfil';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Selecione uma imagem:',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: availableImages.length,
                itemBuilder: (context, index) {
                  final imagePath = availableImages[index];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedImagePath = imagePath),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedImagePath == imagePath 
                              ? Colors.blue 
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: _validateAndSave,
          child: Text(widget.isNewProfile ? 'Criar' : 'Salvar'),
        ),
      ],
    );
  }

  void _validateAndSave() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImagePath.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione uma imagem')),
        );
        return;
      }
      _saveProfile();
    }
  }

  Future<void> _saveProfile() async {
    try {
      final updatedProfile = Profile(
        id: widget.isNewProfile ? null : widget.profile.id,
        name: _nameController.text.trim(),
        imagePath: _selectedImagePath,
      );

      if (widget.isNewProfile) {
        await DatabaseHelper.instance.insertProfile(updatedProfile);
      } else {
        await DatabaseHelper.instance.updateProfile(updatedProfile);
      }

      widget.onSaved();
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isNewProfile 
              ? 'Perfil criado com sucesso!' 
              : 'Perfil atualizado com sucesso!'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    }
  }
}
