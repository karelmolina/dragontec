import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes.dart';
import '../../../../config/theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logo-static.png',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.local_shipping,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Horus Logistic',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Sistema de gestión',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Inicio'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Usuarios'),
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRoutes.usuarios);
              },
            ),
            ListTile(
              leading: const Icon(Icons.business_outlined),
              title: const Text('Agencias'),
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRoutes.agencias);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_ind_outlined),
              title: const Text('Asignar Agencia'),
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRoutes.asignarAgencia);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_add_outlined),
              title: const Text('Registro de Cliente'),
              onTap: () {
                Navigator.of(context).pop();
                context.push(AppRoutes.registroCliente);
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HomeCard(
              title: 'Usuarios',
              subtitle: 'Gestionar usuarios, técnicos y consignatarios',
              icon: Icons.people_outline,
              onTap: () => context.push(AppRoutes.usuarios),
            ),
            const SizedBox(height: 16),
            _HomeCard(
              title: 'Agencias',
              subtitle: 'Consultar catálogo de agencias y filtrar',
              icon: Icons.business_outlined,
              onTap: () => context.push(AppRoutes.agencias),
            ),
            const SizedBox(height: 16),
            _HomeCard(
              title: 'Asignar Agencia',
              subtitle: 'Asignar una agencia a su cuenta',
              icon: Icons.assignment_ind_outlined,
              onTap: () => context.push(AppRoutes.asignarAgencia),
            ),
            const SizedBox(height: 16),
            _HomeCard(
              title: 'Registro de Cliente',
              subtitle: 'Crear una nueva cuenta de cliente',
              icon: Icons.person_add_outlined,
              onTap: () => context.push(AppRoutes.registroCliente),
            ),
          ],
        ),
      ),
    );
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
