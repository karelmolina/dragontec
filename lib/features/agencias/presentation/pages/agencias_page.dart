import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme.dart';
import '../../../../features/auth/domain/entities/user.dart';
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/agencia.dart';
import '../bloc/agencias_bloc.dart';
import '../bloc/agencias_event.dart';
import '../bloc/agencias_state.dart';
import '../../../clientes/presentation/bloc/clientes_bloc.dart';
import '../../../clientes/presentation/bloc/clientes_event.dart';
import '../../../clientes/presentation/bloc/clientes_state.dart';

class AgenciasPage extends StatefulWidget {
  const AgenciasPage({super.key});

  @override
  State<AgenciasPage> createState() => _AgenciasPageState();
}

class _AgenciasPageState extends State<AgenciasPage> {
  final _searchController = TextEditingController();
  String? _filtroCodigo;
  String? _filtroNombre;
  int? _filtroId;
  Agencia? _selectedAgencia;

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
            id: _filtroId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClientesBloc, ClientesState>(
      listener: (context, state) {
        if (state is AgenciaAsignada) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          setState(() => _selectedAgencia = null);
        } else if (state is ClientesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
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
                  hintText: 'Buscar por ID o nombre...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _filtroCodigo = null;
                              _filtroNombre = null;
                              _filtroId = null;
                              _selectedAgencia = null;
                            });
                            _loadAgencias();
                          },
                        )
                      : null,
                ),
                onSubmitted: (value) {
                  final trimmed = value.trim();
                  if (trimmed.isEmpty) {
                    setState(() {
                      _filtroCodigo = null;
                      _filtroNombre = null;
                      _filtroId = null;
                      _selectedAgencia = null;
                    });
                  } else if (int.tryParse(trimmed) != null) {
                    setState(() {
                      _filtroId = int.parse(trimmed);
                      _filtroCodigo = null;
                      _filtroNombre = null;
                      _selectedAgencia = null;
                    });
                  } else {
                    setState(() {
                      _filtroNombre = trimmed;
                      _filtroCodigo = null;
                      _filtroId = null;
                      _selectedAgencia = null;
                    });
                  }
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
                        final isSelected = _selectedAgencia?.id == agencia.id;
                        return _AgenciaCard(
                          agencia: agencia,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedAgencia = isSelected ? null : agencia;
                            });
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            BlocBuilder<ClientesBloc, ClientesState>(
              builder: (context, clientesState) {
                return BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    final user = authState is AuthAuthenticated ? authState.user : null;
                    final canAsignar = user?.canAsignarAgencia ?? false;
                    
                    if (!canAsignar || _selectedAgencia == null) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Agencia seleccionada: ${_selectedAgencia!.nombre}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: clientesState is ClientesLoading
                                  ? null
                                  : () {
                                      context.read<ClientesBloc>().add(
                                            AsignarAgencia(
                                              idAgencia: _selectedAgencia!.id,
                                            ),
                                          );
                                    },
                              child: clientesState is ClientesLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Asignar agencia'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AgenciaCard extends StatelessWidget {
  final Agencia agencia;
  final bool isSelected;
  final VoidCallback onTap;

  const _AgenciaCard({
    required this.agencia,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isSelected
          ? AppColors.primary.withOpacity(0.1)
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                child: Text(agencia.nombre.isNotEmpty ? agencia.nombre[0] : '?'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agencia.nombre,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (agencia.codigo != null)
                      Text(
                        'Código: ${agencia.codigo}',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
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
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                )
              else
                const Icon(
                  Icons.radio_button_unchecked,
                  color: AppColors.textTertiary,
                ),
              if (agencia.status != null)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _StatusChip(active: agencia.status == 1),
                ),
            ],
          ),
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
