import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme.dart';
import '../../domain/entities/paquete.dart';
import '../bloc/tracking_bloc.dart';
import '../bloc/tracking_event.dart';
import '../bloc/tracking_state.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final _searchController = TextEditingController();
  String _lastTracking = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchTracking() {
    final tracking = _searchController.text.trim();
    if (tracking.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El número de tracking es obligatorio'),
        ),
      );
      return;
    }
    _lastTracking = tracking;
    context.read<TrackingBloc>().add(
      SearchTracking(trackingCourier: tracking),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking de Paquetes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Ingresa el número de tracking',
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (_) => _searchTracking(),
            ),
          ),
          Expanded(
            child: BlocBuilder<TrackingBloc, TrackingState>(
              builder: (context, state) {
                if (state is TrackingLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TrackingLoaded) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _PaqueteCard(paquete: state.paquete),
                  );
                }

                if (state is TrackingNotFound) {
                  return const Center(
                    child: Text('Paquete no encontrado'),
                  );
                }

                if (state is TrackingError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _lastTracking.isNotEmpty
                              ? () => context.read<TrackingBloc>().add(
                            SearchTracking(
                              trackingCourier: _lastTracking,
                            ),
                          )
                              : null,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
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

class _PaqueteCard extends StatelessWidget {
  final Paquete paquete;

  const _PaqueteCard({required this.paquete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estado badge
            _buildEstadoBadge(paquete.estado, paquete.colorEstado),
            const SizedBox(height: 16),
            // Tracking principal
            _buildSectionTitle('Tracking Interno'),
            _buildValueText(paquete.tracking),
            const SizedBox(height: 12),
            // Tracking courier
            _buildSectionTitle('Tracking Courier'),
            _buildValueText(paquete.trackingCourier),
            const SizedBox(height: 12),
            // Descripción
            _buildSectionTitle('Descripción'),
            _buildValueText(paquete.descripcion),
            const SizedBox(height: 12),
            // Consignatario
            _buildSectionTitle('Consignatario'),
            _buildValueText(paquete.consignatario),
            const SizedBox(height: 12),
            // Ubicación
            _buildSectionTitle('Ubicación'),
            _buildValueText('${paquete.nombreCiudad}, ${paquete.nombrePais}'),
            const SizedBox(height: 12),
            // Agencia
            _buildSectionTitle('Agencia'),
            _buildValueText(paquete.agencia),
            const SizedBox(height: 12),
            // Peso y piezas
            Row(
              children: [
                Expanded(
                  child: _buildInfoBox(
                    icon: Icons.scale_outlined,
                    label: 'Peso',
                    value: '${paquete.peso} kg',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoBox(
                    icon: Icons.inventory_2_outlined,
                    label: 'Piezas',
                    value: paquete.cantPieza.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Flete
            _buildSectionTitle('Tipo de Flete'),
            _buildValueText(paquete.flete),
            if (paquete.fechaAlmacen != null) ...[
              const SizedBox(height: 12),
              _buildSectionTitle('Fecha de Almacenamiento'),
              _buildValueText(paquete.fechaAlmacen!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoBadge(String estado, String colorEstado) {
    Color badgeColor = AppColors.primary;
    if (colorEstado.contains('success')) {
      badgeColor = Colors.green;
    } else if (colorEstado.contains('danger')) {
      badgeColor = Colors.red;
    } else if (colorEstado.contains('warning')) {
      badgeColor = Colors.orange;
    } else if (colorEstado.contains('info')) {
      badgeColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        estado,
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildValueText(String value) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInfoBox({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
