import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../agencias/presentation/bloc/agencias_bloc.dart';
import '../../../agencias/presentation/bloc/agencias_event.dart';
import '../../../agencias/presentation/bloc/agencias_state.dart';
import '../../domain/usecases/create_alerta_paquete.dart';
import '../bloc/alertas_bloc.dart';
import '../bloc/alertas_event.dart';
import '../bloc/alertas_state.dart';

class CrearAlertaPage extends StatefulWidget {
  const CrearAlertaPage({super.key});

  @override
  State<CrearAlertaPage> createState() => _CrearAlertaPageState();
}

class _CrearAlertaPageState extends State<CrearAlertaPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _diaLlegada;
  final _nombreController = TextEditingController();
  final _trackingController = TextEditingController();
  int? _idCourier;
  int? _idAgencia;
  int? _idTipoalerta;
  String? _flete;
  final _cantPiezasController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _instruccionesController = TextEditingController();

  final List<Map<String, dynamic>> _couriers = const [
    {'id': 1, 'nombre': 'DHL'},
    {'id': 2, 'nombre': 'FedEx'},
    {'id': 3, 'nombre': 'UPS'},
    {'id': 4, 'nombre': 'Amazon Logistics'},
  ];

  final List<Map<String, dynamic>> _tiposAlerta = const [
    {'id': 1, 'nombre': 'Entrega'},
    {'id': 2, 'nombre': 'Retraso'},
    {'id': 3, 'nombre': 'Daño'},
    {'id': 4, 'nombre': 'Pérdida'},
  ];

  final List<String> _fletes = const ['Aéreo', 'Marítimo', 'Terrestre'];

  @override
  void initState() {
    super.initState();
    context.read<AgenciasBloc>().add(const LoadAgencias());
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _trackingController.dispose();
    _cantPiezasController.dispose();
    _descripcionController.dispose();
    _instruccionesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _diaLlegada ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _diaLlegada = picked);
    }
  }

  void _submit() {
    if (_diaLlegada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione una fecha de llegada')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final params = CreateAlertaPaqueteParams(
      diaLlegada: _diaLlegada,
      nombreCliente: _nombreController.text.trim(),
      trackingCourier: _trackingController.text.trim(),
      idCourier: _idCourier!,
      idAgencia: _idAgencia!,
      idTipoalerta: _idTipoalerta!,
      flete: _flete!,
      cantPiezas: int.parse(_cantPiezasController.text.trim()),
      descripcion: _descripcionController.text.trim(),
      instrucciones: _instruccionesController.text.trim(),
    );

    context.read<AlertasBloc>().add(CreateAlerta(params: params));
  }

  void _reset() {
    _formKey.currentState?.reset();
    setState(() {
      _diaLlegada = null;
      _idCourier = null;
      _idAgencia = null;
      _idTipoalerta = null;
      _flete = null;
    });
    _nombreController.clear();
    _trackingController.clear();
    _cantPiezasController.clear();
    _descripcionController.clear();
    _instruccionesController.clear();
    context.read<AlertasBloc>().add(const ResetAlerta());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Alerta de Paquete'),
      ),
      body: BlocBuilder<AlertasBloc, AlertasState>(
        builder: (context, state) {
          if (state is AlertasLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AlertasCreated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Alerta creada exitosamente',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _reset,
                    child: const Text('Nueva Alerta'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state is AlertasError) ...[
                    Text(
                      state.message,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Reintentar'),
                    ),
                    const SizedBox(height: 16),
                  ],
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Día de llegada',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _diaLlegada != null
                            ? DateFormat('dd/MM/yyyy').format(_diaLlegada!)
                            : 'Seleccione una fecha',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del cliente',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'El nombre del cliente es obligatorio'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _trackingController,
                    decoration: const InputDecoration(
                      labelText: 'Tracking courier',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'El tracking es obligatorio'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    key: const Key('dropdown_courier'),
                    value: _idCourier,
                    decoration: const InputDecoration(
                      labelText: 'Courier',
                      border: OutlineInputBorder(),
                    ),
                    items: _couriers.map((c) => DropdownMenuItem<int>(
                      value: c['id'] as int,
                      child: Text(c['nombre'] as String),
                    )).toList(),
                    onChanged: (value) => setState(() => _idCourier = value),
                    validator: (value) => value == null
                        ? 'Seleccione un courier'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<AgenciasBloc, AgenciasState>(
                    builder: (context, agenciasState) {
                      if (agenciasState is AgenciasLoaded) {
                        return DropdownButtonFormField<int>(
                          key: const Key('dropdown_agencia'),
                          value: _idAgencia,
                          decoration: const InputDecoration(
                            labelText: 'Agencia',
                            border: OutlineInputBorder(),
                          ),
                          items: agenciasState.agencias.map((a) =>
                            DropdownMenuItem<int>(
                              value: a.id,
                              child: Text(a.nombre),
                            ),
                          ).toList(),
                          onChanged: (value) => setState(() => _idAgencia = value),
                          validator: (value) => value == null
                              ? 'Seleccione una agencia'
                              : null,
                        );
                      }

                      if (agenciasState is AgenciasLoading) {
                        return const InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Agencia',
                            border: OutlineInputBorder(),
                          ),
                          child: SizedBox(
                            height: 20,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      }

                      return DropdownButtonFormField<int>(
                        key: const Key('dropdown_agencia'),
                        value: _idAgencia,
                        decoration: const InputDecoration(
                          labelText: 'Agencia',
                          border: OutlineInputBorder(),
                        ),
                        items: const [],
                        onChanged: null,
                        validator: (value) => value == null
                            ? 'Seleccione una agencia'
                            : null,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    key: const Key('dropdown_tipoalerta'),
                    value: _idTipoalerta,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de alerta',
                      border: OutlineInputBorder(),
                    ),
                    items: _tiposAlerta.map((t) => DropdownMenuItem<int>(
                      value: t['id'] as int,
                      child: Text(t['nombre'] as String),
                    )).toList(),
                    onChanged: (value) => setState(() => _idTipoalerta = value),
                    validator: (value) => value == null
                        ? 'Seleccione un tipo de alerta'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    key: const Key('dropdown_flete'),
                    value: _flete,
                    decoration: const InputDecoration(
                      labelText: 'Flete',
                      border: OutlineInputBorder(),
                    ),
                    items: _fletes.map((f) => DropdownMenuItem<String>(
                      value: f,
                      child: Text(f),
                    )).toList(),
                    onChanged: (value) => setState(() => _flete = value),
                    validator: (value) => value == null
                        ? 'Seleccione un tipo de flete'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cantPiezasController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad de piezas',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'La cantidad de piezas es obligatoria';
                      }
                      final n = int.tryParse(value.trim());
                      if (n == null || n <= 0) {
                        return 'Debe ser un número mayor a 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _instruccionesController,
                    decoration: const InputDecoration(
                      labelText: 'Instrucciones',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Crear Alerta'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
