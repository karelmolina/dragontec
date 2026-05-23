import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/usuario.dart';
import '../bloc/usuarios_bloc.dart';
import '../bloc/usuarios_event.dart';
import '../bloc/usuarios_state.dart';
import 'usuario_form_page.dart';

class UsuariosListPage extends StatefulWidget {
  const UsuariosListPage({super.key});

  @override
  State<UsuariosListPage> createState() => _UsuariosListPageState();
}

class _UsuariosListPageState extends State<UsuariosListPage> {
  @override
  void initState() {
    super.initState();
    context.read<UsuariosBloc>().add(const LoadUsuarios());
  }

  bool get _isAdmin {
    final authState = context.read<AuthBloc>().state;
    return authState is AuthAuthenticated && authState.user.isAdmin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        actions: [
          if (_isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _navigateToForm(context),
            ),
        ],
      ),
      body: BlocConsumer<UsuariosBloc, UsuariosState>(
        listener: (context, state) {
          if (state is UsuarioOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.read<UsuariosBloc>().add(const LoadUsuarios());
          } else if (state is UsuariosError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is UsuariosLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UsuariosError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<UsuariosBloc>().add(const LoadUsuarios()),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is UsuariosLoaded) {
            if (state.usuarios.isEmpty) {
              return const Center(child: Text('No hay usuarios registrados'));
            }

            return ListView.builder(
              itemCount: state.usuarios.length,
              itemBuilder: (context, index) {
                final usuario = state.usuarios[index];
                return _UsuarioCard(
                  usuario: usuario,
                  isAdmin: _isAdmin,
                  onTap: _isAdmin
                      ? () => _navigateToForm(context, usuario: usuario)
                      : null,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _navigateToForm(BuildContext context, {Usuario? usuario}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<UsuariosBloc>(),
          child: UsuarioFormPage(usuario: usuario),
        ),
      ),
    );
  }
}

class _UsuarioCard extends StatelessWidget {
  final Usuario usuario;
  final VoidCallback? onTap;
  final bool isAdmin;

  const _UsuarioCard({
    required this.usuario,
    this.onTap,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          child: Text(usuario.nombre.isNotEmpty ? usuario.nombre[0] : '?'),
        ),
        title: Text(
          usuario.nombre,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('@${usuario.usuario}'),
            const SizedBox(height: 4),
            Row(
              children: [
                _RoleChip(label: usuario.rolNombre),
                const SizedBox(width: 8),
                _StatusChip(active: usuario.status == 1),
                if (!isAdmin) ...[
                  const SizedBox(width: 8),
                  const _ReadOnlyChip(),
                ],
              ],
            ),
          ],
        ),
        trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
        onTap: onTap,
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;

  const _RoleChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool active;

  const _StatusChip({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: active
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.error.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        active ? 'Activo' : 'Inactivo',
        style: TextStyle(
          fontSize: 12,
          color: active ? AppColors.success : AppColors.error,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ReadOnlyChip extends StatelessWidget {
  const _ReadOnlyChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.textTertiary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Solo lectura',
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
