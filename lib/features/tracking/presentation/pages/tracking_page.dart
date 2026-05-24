import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  return _PaqueteCard(paquete: state.paquete);
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
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              paquete.tracking,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text('Estado: ${paquete.estado}'),
            if (paquete.origen != null) Text('Origen: ${paquete.origen}'),
            if (paquete.destino != null) Text('Destino: ${paquete.destino}'),
          ],
        ),
      ),
    );
  }
}
