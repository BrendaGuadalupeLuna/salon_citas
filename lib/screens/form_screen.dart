import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/cita.dart';
import '../services/cita_service.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _telefono = TextEditingController();
  final _notas = TextEditingController();
  final _service = CitaService();

  String? _servicio;
  DateTime? _fecha;
  TimeOfDay? _hora;
  bool _guardando = false;

  @override
  void dispose() {
    _nombre.dispose();
    _telefono.dispose();
    _notas.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final hoy = DateTime.now();
    final f = await showDatePicker(
      context: context,
      initialDate: hoy,
      firstDate: hoy,
      lastDate: hoy.add(const Duration(days: 180)),
    );
    if (f != null) setState(() => _fecha = f);
  }

  Future<void> _elegirHora() async {
    final h = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (h != null) setState(() => _hora = h);
  }

  void _msg(String texto, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(texto),
      backgroundColor: error ? Colors.red.shade700 : null,
    ));
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fecha == null || _hora == null) {
      _msg('Selecciona la fecha y la hora de la cita', error: true);
      return;
    }
    if (_hora!.hour < 10 || _hora!.hour >= 20) {
      _msg('El horario de atención es de 10:00 a 20:00', error: true);
      return;
    }
    final fechaHora = DateTime(
        _fecha!.year, _fecha!.month, _fecha!.day, _hora!.hour, _hora!.minute);
    if (fechaHora.isBefore(DateTime.now())) {
      _msg('La fecha y hora deben ser futuras', error: true);
      return;
    }

    setState(() => _guardando = true);
    try {
      await _service.crear(Cita(
        uid: FirebaseAuth.instance.currentUser!.uid,
        nombre: _nombre.text.trim(),
        telefono: _telefono.text.trim(),
        servicio: _servicio!,
        fecha: fechaHora,
        notas: _notas.text.trim(),
      ));
      if (!mounted) return;
      _msg('Cita registrada correctamente');
      Navigator.pop(context);
    } catch (e) {
      if (mounted) _msg(e.toString().replaceFirst('Exception: ', ''), error: true);
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fFecha = DateFormat('dd/MM/yyyy');
    return Scaffold(
      appBar: AppBar(title: const Text('Agendar cita')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombre,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person)),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  if (v.trim().length < 3) return 'Nombre demasiado corto';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _telefono,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: const InputDecoration(
                    labelText: 'Teléfono (10 dígitos)',
                    prefixIcon: Icon(Icons.phone)),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'El teléfono es obligatorio';
                  }
                  if (v.trim().length != 10) return 'Debe tener 10 dígitos';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _servicio,
                decoration: const InputDecoration(
                    labelText: 'Servicio', prefixIcon: Icon(Icons.spa)),
                items: servicios
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _servicio = v),
                validator: (v) => v == null ? 'Selecciona un servicio' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.event),
                      label: Text(_fecha == null
                          ? 'Fecha'
                          : fFecha.format(_fecha!)),
                      onPressed: _elegirFecha,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(
                          _hora == null ? 'Hora' : _hora!.format(context)),
                      onPressed: _elegirHora,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notas,
                maxLines: 3,
                maxLength: 200,
                decoration: const InputDecoration(
                    labelText: 'Notas (opcional)',
                    prefixIcon: Icon(Icons.notes)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _guardando ? null : _guardar,
                  icon: _guardando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save),
                  label: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text('Guardar cita'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
