import 'package:cloud_firestore/cloud_firestore.dart';

const servicios = <String>[
  'Corte de cabello',
  'Tinte',
  'Peinado',
  'Manicure',
  'Pedicure',
  'Maquillaje',
  'Tratamiento capilar',
  'Depilación',
];

class Cita {
  final String? id;
  final String uid;
  final String nombre;
  final String telefono;
  final String servicio;
  final DateTime fecha; // fecha + hora
  final String notas;
  final String estado; // pendiente | completada

  Cita({
    this.id,
    required this.uid,
    required this.nombre,
    required this.telefono,
    required this.servicio,
    required this.fecha,
    this.notas = '',
    this.estado = 'pendiente',
  });

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'nombre': nombre,
        'telefono': telefono,
        'servicio': servicio,
        'fecha': Timestamp.fromDate(fecha),
        'notas': notas,
        'estado': estado,
        'creada': FieldValue.serverTimestamp(),
      };

  factory Cita.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Cita(
      id: doc.id,
      uid: d['uid'] ?? '',
      nombre: d['nombre'] ?? '',
      telefono: d['telefono'] ?? '',
      servicio: d['servicio'] ?? '',
      fecha: (d['fecha'] as Timestamp).toDate(),
      notas: d['notas'] ?? '',
      estado: d['estado'] ?? 'pendiente',
    );
  }
}
