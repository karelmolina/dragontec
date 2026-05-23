import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/clientes_bloc.dart';
import '../bloc/clientes_event.dart';
import '../bloc/clientes_state.dart';

class RegistroClientePage extends StatefulWidget {
  const RegistroClientePage({super.key});

  @override
  State<RegistroClientePage> createState() => _RegistroClientePageState();
}

class _RegistroClientePageState extends State<RegistroClientePage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _correoController = TextEditingController();
  final _claveController = TextEditingController();
  final _claveConfirmacionController = TextEditingController();
  bool _obscureClave = true;
  bool _obscureConfirmacion = true;

  @override
  void dispose() {
    _nombreController.dispose();
    _usuarioController.dispose();
    _correoController.dispose();
    _claveController.dispose();
    _claveConfirmacionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Cliente'),
      ),
      body: BlocConsumer<ClientesBloc, ClientesState>(
        listener: (context, state) {
          if (state is ClienteRegistrado) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cliente registrado exitosamente')),
            );
            context.pop();
          } else if (state is ClientesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nombreController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _usuarioController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      prefixIcon: Icon(Icons.alternate_email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El usuario es requerido';
                      }
                      if (value.length < 3) {
                        return 'Mínimo 3 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _correoController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Ingrese un correo válido';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _claveController,
                    textInputAction: TextInputAction.next,
                    obscureText: _obscureClave,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureClave
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => _obscureClave = !_obscureClave);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La contraseña es requerida';
                      }
                      if (value.length < 6) {
                        return 'Mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _claveConfirmacionController,
                    textInputAction: TextInputAction.done,
                    obscureText: _obscureConfirmacion,
                    decoration: InputDecoration(
                      labelText: 'Confirmar contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmacion
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(
                            () => _obscureConfirmacion = !_obscureConfirmacion,
                          );
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirme la contraseña';
                      }
                      if (value != _claveController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed:
                        state is ClientesLoading ? null : _submit,
                    child: state is ClientesLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Registrarse'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('¿Ya tiene cuenta? Inicie sesión'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ClientesBloc>().add(
            RegistrarCliente(
              nombre: _nombreController.text.trim(),
              usuario: _usuarioController.text.trim(),
              clave: _claveController.text,
              claveConfirmacion: _claveConfirmacionController.text,
              correo: _correoController.text.trim().isEmpty
                  ? null
                  : _correoController.text.trim(),
            ),
          );
    }
  }
}
