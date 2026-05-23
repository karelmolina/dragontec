import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme.dart';
import '../../domain/entities/agencia.dart';
import '../bloc/agencias_bloc.dart';
import '../bloc/agencias_event.dart';
import '../bloc/agencias_state.dart';

class AgenciasPage extends StatefulWidget {
  const AgenciasPage({super.key});

  @override
  State<AgenciasPage> createState() => _AgenciasPageState();
}

class _AgenciasPageState extends State<AgenciasPage> {
  final _searchController = TextEditingController();
  String? _filtroCodigo;
  String? _filtroNombre;

  @override
  void initState() {
    super.initState();
    _loadAgencias();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadAgencias() {
    context.read<AgenciasBloc>().add(
          LoadAgencias(
            codigo: _filtroCodigo,
            nombre: _filtroNombre,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agencias'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o código...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _filtroCodigo = null;
                            _filtroNombre = null;
                          });
                          _loadAgencias();
                        },
                      )
                    : null,
              ),
              onSubmitted: (value) {
                setState(() {
                  _filtroCodigo = value.toUpperCase();
                  _filtroNombre = value;
                });
                _loadAgencias();
              },
            ),
          ),
          Expanded(
            child: BlocConsumer<AgenciasBloc, AgenciasState>(
              listener: (context, state) {
                if (state is AgenciasError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                if (state is AgenciasLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is AgenciasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadAgencias,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is AgenciasLoaded) {
                  if (state.agencias.isEmpty) {
                    return const Center(
                      child: Text('No se encontraron agencias'),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.agencias.length,
                    itemBuilder: (context, index) {
                      final agencia = state.agencias[index];
                      return _AgenciaCard(agencia: agencia);
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AgenciaCard extends StatelessWidget {
  final Agencia agencia;

  const _AgenciaCard({required this.agencia});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          child: Text(agencia.nombre.isNotEmpty ? agencia.nombre[0] : '?'),
        ),
        title: Text(
          agencia.nombre,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (agencia.codigo != null) ...[
              Text('Código: ${agencia.codigo}'),
              const SizedBox(height: 4),
            ],
            if (agencia.direccion != null)
              Text(
                agencia.direccion!,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            if (agencia.telefono != null)
              Text(
                'Tel: ${agencia.telefono}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
          ],
        ),
        trailing: agencia.status != null
            ? _StatusChip(active: agencia.status == 1)
            : null,
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
