import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/usuario.dart';
import '../bloc/usuarios_bloc.dart';
import '../bloc/usuarios_event.dart';
import '../bloc/usuarios_state.dart';

class UsuarioFormPage extends StatefulWidget {
  final Usuario? usuario;

  const UsuarioFormPage({super.key, this.usuario});

  @override
  State<UsuarioFormPage> createState() => _UsuarioFormPageState();
}

class _UsuarioFormPageState extends State<UsuarioFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreController;
  late final TextEditingController _usuarioController;
  late final TextEditingController _correoController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _identificacionController;
  late final TextEditingController _direccionController;
  late final TextEditingController _idAgenciaController;
  late final TextEditingController _idConsignatarioController;

  int _rol = 4;
  int _status = 1;
  bool _requiereCambioClave = false;

  bool get _isEditing => widget.usuario != null;

  @override
  void initState() {
    super.initState();
    final u = widget.usuario;
    _nombreController = TextEditingController(text: u?.nombre ?? '');
    _usuarioController = TextEditingController(text: u?.usuario ?? '');
    _correoController = TextEditingController(text: u?.correo ?? '');
    _telefonoController = TextEditingController(text: u?.telefono ?? '');
    _identificacionController = TextEditingController(text: u?.identificacion ?? '');
    _direccionController = TextEditingController(text: u?.direccion ?? '');
    _idAgenciaController = TextEditingController(
      text: u?.idAgencia?.toString() ?? '',
    );
    _idConsignatarioController = TextEditingController(
      text: u?.idConsignatario?.toString() ?? '',
    );
    if (u != null) {
      _rol = u.rol;
      _status = u.status;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _usuarioController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _identificacionController.dispose();
    _direccionController.dispose();
    _idAgenciaController.dispose();
    _idConsignatarioController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final usuario = Usuario(
      id: widget.usuario?.id,
      nombre: _nombreController.text.trim(),
      usuario: _usuarioController.text.trim(),
      correo: _correoController.text.trim().isEmpty
          ? null
          : _correoController.text.trim(),
      telefono: _telefonoController.text.trim().isEmpty
          ? null
          : _telefonoController.text.trim(),
      identificacion: _identificacionController.text.trim().isEmpty
          ? null
          : _identificacionController.text.trim(),
      rol: _rol,
      status: _status,
      direccion: _rol == 4 && _direccionController.text.trim().isNotEmpty
          ? _direccionController.text.trim()
          : null,
      idAgencia: _rol == 4 && _idAgenciaController.text.trim().isNotEmpty
          ? int.tryParse(_idAgenciaController.text.trim())
          : null,
      idConsignatario:
          _rol == 3 && _idConsignatarioController.text.trim().isNotEmpty
              ? int.tryParse(_idConsignatarioController.text.trim())
              : null,
    );

    if (_isEditing) {
      context.read<UsuariosBloc>().add(UpdateUsuario(usuario));
    } else {
      context.read<UsuariosBloc>().add(CreateUsuario(usuario));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsuariosBloc, UsuariosState>(
      listener: (context, state) {
        if (state is UsuarioOperationSuccess) {
          Navigator.of(context).pop();
        } else if (state is UsuariosError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? 'Editar Usuario' : 'Nuevo Usuario'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre completo *'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _usuarioController,
                  decoration: const InputDecoration(labelText: 'Usuario *'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _correoController,
                  decoration: const InputDecoration(labelText: 'Correo'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _telefonoController,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _identificacionController,
                  decoration: const InputDecoration(labelText: 'Identificación'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  key: ValueKey<int>(_rol),
                  decoration: const InputDecoration(labelText: 'Rol *'),
                  initialValue: _rol,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Administrador')),
                    DropdownMenuItem(value: 2, child: Text('Técnico')),
                    DropdownMenuItem(value: 3, child: Text('Consignatario')),
                    DropdownMenuItem(value: 4, child: Text('Usuario / Agencia')),
                  ],
                  onChanged: (v) => setState(() => _rol = v ?? 4),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  key: ValueKey<int>(_status),
                  decoration: const InputDecoration(labelText: 'Estado *'),
                  initialValue: _status,
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Activo')),
                    DropdownMenuItem(value: 0, child: Text('Inactivo')),
                  ],
                  onChanged: (v) => setState(() => _status = v ?? 1),
                ),
                const SizedBox(height: 16),
                if (_rol == 4) ...[
                  TextFormField(
                    controller: _direccionController,
                    decoration: const InputDecoration(labelText: 'Dirección'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _idAgenciaController,
                    decoration: const InputDecoration(labelText: 'ID Agencia'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                ],
                if (_rol == 3) ...[
                  TextFormField(
                    controller: _idConsignatarioController,
                    decoration:
                        const InputDecoration(labelText: 'ID Consignatario'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                ],
                if (_isEditing) ...[
                  CheckboxListTile(
                    value: _requiereCambioClave,
                    onChanged: (v) =>
                        setState(() => _requiereCambioClave = v ?? false),
                    title: const Text('Requerir cambio de contraseña'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 24),
                BlocBuilder<UsuariosBloc, UsuariosState>(
                  builder: (context, state) {
                    final isLoading = state is UsuariosLoading;
                    return ElevatedButton(
                      onPressed: isLoading ? null : _onSave,
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(_isEditing ? 'GUARDAR CAMBIOS' : 'CREAR USUARIO'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
