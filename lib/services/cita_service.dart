import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cita.dart';

class CitaService {
  final _col = FirebaseFirestore.instance.collection('citas');

  Stream<List<Cita>> streamCitas() => _col
      .orderBy('fecha')
      .snapshots()
      .map((s) => s.docs.map(Cita.fromDoc).toList());

  /// Registra una cita. Lanza [Exception] si el horario ya está ocupado.
  Future<void> crear(Cita cita) async {
    final ocupado = await _col
        .where('fecha', isEqualTo: Timestamp.fromDate(cita.fecha))
        .where('estado', isEqualTo: 'pendiente')
        .limit(1)
        .get();
    if (ocupado.docs.isNotEmpty) {
      throw Exception('Ese horario ya está ocupado. Elige otro.');
    }
    await _col.add(cita.toMap());
  }

  Future<void> cambiarEstado(String id, String estado) =>
      _col.doc(id).update({'estado': estado});

  Future<void> eliminar(String id) => _col.doc(id).delete();
}
