import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme.dart';
import '../../../agencias/domain/entities/agencia.dart';
import '../../../agencias/presentation/bloc/agencias_bloc.dart';
import '../../../agencias/presentation/bloc/agencias_event.dart';
import '../../../agencias/presentation/bloc/agencias_state.dart';
import '../bloc/clientes_bloc.dart';
import '../bloc/clientes_event.dart';
import '../bloc/clientes_state.dart';

class AsignarAgenciaPage extends StatefulWidget {
  const AsignarAgenciaPage({super.key});

  @override
  State<AsignarAgenciaPage> createState() => _AsignarAgenciaPageState();
}

class _AsignarAgenciaPageState extends State<AsignarAgenciaPage> {
  Agencia? _selectedAgencia;

  @override
  void initState() {
    super.initState();
    context.read<AgenciasBloc>().add(const LoadAgencias());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignar Agencia'),
      ),
      body: BlocConsumer<ClientesBloc, ClientesState>(
        listener: (context, state) {
          if (state is AgenciaAsignada) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.of(context).pop();
          } else if (state is ClientesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, clientesState) {
          return BlocBuilder<AgenciasBloc, AgenciasState>(
            builder: (context, agenciasState) {
              if (agenciasState is AgenciasLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (agenciasState is AgenciasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(agenciasState.message),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<AgenciasBloc>()
                              .add(const LoadAgencias());
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              }

              if (agenciasState is AgenciasLoaded) {
                if (agenciasState.agencias.isEmpty) {
                  return const Center(
                    child: Text('No hay agencias disponibles'),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: agenciasState.agencias.length,
                        itemBuilder: (context, index) {
                          final agencia = agenciasState.agencias[index];
                          final isSelected = _selectedAgencia?.id == agencia.id;

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : null,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                child: Text(
                                  agencia.nombre.isNotEmpty
                                      ? agencia.nombre[0]
                                      : '?',
                                ),
                              ),
                              title: Text(
                                agencia.nombre,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (agencia.codigo != null)
                                    Text('Código: ${agencia.codigo}'),
                                  if (agencia.direccion != null)
                                    Text(agencia.direccion!),
                                ],
                              ),
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: AppColors.primary,
                                    )
                                  : const Icon(Icons.radio_button_unchecked),
                              onTap: () {
                                setState(() {
                                  _selectedAgencia = agencia;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: ElevatedButton(
                        onPressed: (_selectedAgencia == null ||
                                clientesState is ClientesLoading)
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
                                ),
                              )
                            : const Text('Confirmar asignación'),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
