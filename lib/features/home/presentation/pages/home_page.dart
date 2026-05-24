import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes.dart';
import '../../../../config/theme.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Inicio'),
          ),
          drawer: _buildDrawer(context, user),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildCards(context, user),
            ),
          ),
        );
      },
    );
  }

  Drawer _buildDrawer(BuildContext context, User? user) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            currentAccountPicture: Image.asset(
              'assets/images/logo-static.png',
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.local_shipping,
                  color: Colors.white,
                ),
              ),
            ),
            accountName: Text(
              user?.nombre ?? 'Invitado',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              user != null
                  ? '@${user.usuario} · ${user.rolNombre}'
                  : 'No autenticado',
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Inicio'),
            onTap: () => Navigator.of(context).pop(),
          ),
          if (user?.canManageUsuarios ?? false)
            ListTile(
              leading: const Icon(Icons.person_add_outlined),
              title: const Text('Crear Usuario'),
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRoutes.crearUsuario);
              },
            ),
          if (user?.canViewAgencias ?? true)
            ListTile(
              leading: const Icon(Icons.business_outlined),
              title: const Text('Agencias'),
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRoutes.agencias);
              },
            ),

          if (user?.canViewTracking ?? false)
            ListTile(
              leading: const Icon(Icons.local_shipping_outlined),
              title: const Text('Tracking'),
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRoutes.tracking);
              },
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () {
              Navigator.of(context).pop();
              context.read<AuthBloc>().add(const LogoutRequested());
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context, User? user) {
    final cards = <Widget>[];

    if (user?.canManageUsuarios ?? false) {
      cards.add(_HomeCard(
        title: 'Crear Usuario',
        subtitle: 'Crear nuevos usuarios, técnicos y consignatarios',
        icon: Icons.person_add_outlined,
        onTap: () => context.push(AppRoutes.crearUsuario),
      ));
      cards.add(const SizedBox(height: 16));
    }

    if (user?.canViewAgencias ?? true) {
      cards.add(_HomeCard(
        title: 'Agencias',
        subtitle: 'Consultar catálogo de agencias y filtrar',
        icon: Icons.business_outlined,
        onTap: () => context.push(AppRoutes.agencias),
      ));
      cards.add(const SizedBox(height: 16));
    }

    if (user?.canViewTracking ?? false) {
      cards.add(_HomeCard(
        title: 'Tracking',
        subtitle: 'Consultar estado de paquetes',
        icon: Icons.local_shipping_outlined,
        onTap: () => context.push(AppRoutes.tracking),
      ));
      cards.add(const SizedBox(height: 16));
    }

    return cards;
  }
}

class _HomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _HomeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
