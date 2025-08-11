import 'dart:convert';
import 'dart:io';
import 'package:balanced_foods/models/user.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:balanced_foods/screens/Vendedor/sales_module_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final GlobalKey<_EditUserFormState> _editUserFormKey = GlobalKey<_EditUserFormState>();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _lastName = TextEditingController();
  final _celular = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _lastName.dispose();
    _celular.dispose();
    _email.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final currentUser = Provider.of<UsersProvider>(context, listen: false).loggedUser;
    if (currentUser != null) {
      _name.text = currentUser.nombres ?? '';
      _lastName.text = currentUser.apellidos ?? '';
      _celular.text = currentUser.celular ?? '';
      _email.text = currentUser.correo ?? '';
      _address.text = currentUser.direccion ?? '';
      final initialImageFileName = currentUser.fotoPerfil;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bodyPadding = screenWidth * 0.06;
    return Scaffold(
      backgroundColor: AppColors.orange,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(64),
                  bottomRight: Radius.circular(64),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: bodyPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    IconButton(icon: Icon(Icons.arrow_back_ios), color: AppColors.orange, onPressed: () {Navigator.pop(context);} ),
                    const SizedBox(height: 20),
                    const NewUserHeader(),
                    const SizedBox(height: 30),
                    EditUserForm(
                      key: _editUserFormKey,
                      formKey: _formKey,
                      name: _name,
                      lastName: _lastName,
                      celular: _celular,
                      email: _email,
                      address: _address,
                      initialImageFileName: Provider.of<UsersProvider>(context, listen: false).loggedUser?.fotoPerfil,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 35),
            EditarButton(
              formKey: _formKey,
              name: _name,
              lastName: _lastName,
              celular: _celular,
              email: _email,
              address: _address,
              getBase64Image: () => _editUserFormKey.currentState?.base64Image,
            ),
          ],
        ),
      ),
    );
  }
}

class NewUserHeader extends StatelessWidget {
  const NewUserHeader({super.key});

  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: 290,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Datos de usuario', style: AppTextStyles.strong),
        ],
      ),
    );
  }
}

class EditUserForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController name;
  final TextEditingController lastName;
  final TextEditingController celular;
  final TextEditingController email;
  final TextEditingController address;
  final String? initialImageFileName;
  
  const EditUserForm({
    super.key,
    required this.formKey,
    required this.name,
    required this.lastName,
    required this.celular,
    required this.email,
    required this.address,
    this.initialImageFileName,
  });

  @override
  State<EditUserForm> createState() => _EditUserFormState();
}

class _EditUserFormState extends State<EditUserForm> {
  XFile? _selectedImage;
  String? _base64Image;
  final ImagePicker _picker = ImagePicker();

  // Getter para acceder al base64 desde fuera del widget
  String? get base64Image => _base64Image;

  ValueNotifier<bool> _isPickingImage = ValueNotifier(false);
  // Selección de imagen
  Future<void> _pickImage() async {
    if (_isPickingImage.value) return;
    _isPickingImage.value = true;
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await File(image.path).readAsBytes();
        final mimeType = lookupMimeType(image.path);
        final base64Image = 'data:$mimeType;base64,${base64Encode(bytes)}';
        setState(() {
          _selectedImage = image;
          _base64Image = base64Image;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    } finally {
      _isPickingImage.value = false;
    }
  }

  Widget _buildCustomerImage() {
    final imageUrl = (widget.initialImageFileName != null && widget.initialImageFileName!.isNotEmpty)
        ? 'https://adysabackend.facturador.es/archivos/usuarios/${Uri.encodeComponent(widget.initialImageFileName!)}'
        : null;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: _selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(58),
                  child: Image.file(
                    File(_selectedImage!.path),
                    fit: BoxFit.cover,
                  ),
                )
              : (imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 90, color: Colors.grey),
                      ),
                    )
                  : Icon(Icons.person, size: 80, color: Colors.grey)),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.all(8),
              child: Icon(Icons.camera_alt, color: Colors.grey[700], size: 28),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nombres', style: AppTextStyles.orange),
                    _buildTextField(
                      controller: widget.name,
                      validator: (value) {
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Text('Apellidos', style: AppTextStyles.orange),
                    _buildTextField(
                      controller: widget.lastName,
                      validator: (value) {
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 30),
                  _buildCustomerImage(),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text('Dirección', style: AppTextStyles.orange),
          _buildTextField(
            controller: widget.address,
            validator: (value) {
              return null;
            },
          ),
          const SizedBox(height: 30),
          Text('Número de celular', style: AppTextStyles.orange),
          _buildTextField(
            controller: widget.celular,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return null;
              }
              if (value.length == 9) {
                return null;
              }
              return 'El celular debe tener exactamente 9 dígitos';
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
          ),
          const SizedBox(height: 30),
          Text('Correo Corporativo', style: AppTextStyles.orange),
          _buildTextField(
            controller: widget.email,
            validator: (value) {
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value!)) {
                return 'Por favor, ingresa un correo electrónico válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class EditarButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController name;
  final TextEditingController lastName;
  final TextEditingController celular;
  final TextEditingController email;
  final TextEditingController address;
  final String? Function() getBase64Image;

  const EditarButton({
    super.key,
    required this.formKey,
    required this.name,
    required this.lastName,
    required this.celular,
    required this.email,
    required this.address,
    required this.getBase64Image,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.15;
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final currentUser = userProvider.loggedUser;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {                  
                  final base64Image = getBase64Image();

                  final updateUser = currentUser?.copyWith(
                    fotoPerfil: base64Image,
                    nombres: name.text,
                    apellidos: lastName.text,
                    correo: email.text,
                    celular: celular.text,
                    direccion: address.text,
                  );

                  final updateBody = updateUser!.toUpdateJson();
                  final token = userProvider.token;
                  bool isUpdated = await userProvider.updateUser(updateBody, token!); 
                  if (isUpdated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Datos actualizados correctamente")),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SalesModuleScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Error al actualizar los datos")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error al ingresar datos")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Modificar datos', style: AppTextStyles.register),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildTextField({
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller, style: AppTextStyles.controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.orange),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.orange, width: 2.0),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.orange),
        ),
      ),
      validator: validator,
    );
  }

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.orange
  );
  static final strong = base.copyWith(color: AppColors.gris,fontWeight: FontWeight.w600,fontSize: 20,decoration: TextDecoration.none);
  static final weak = base.copyWith(color: AppColors.gris,fontWeight: FontWeight.w300,decoration: TextDecoration.none);
  static final orange = base.copyWith();
  static final register = base.copyWith();
  static final controller = base.copyWith(color: AppColors.gris,fontWeight: FontWeight.w300);
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
}