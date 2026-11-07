import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/cita.dart';
import '../services/cita_service.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = CitaService();
    final fmt = DateFormat('dd/MM/yyyy – HH:mm');
    return Scaffold(
      appBar: AppBar(title: const Text('Citas agendadas')),
      body: StreamBuilder<List<Cita>>(
        stream: service.streamCitas(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final citas = snap.data!;
          if (citas.isEmpty) {
            return const Center(child: Text('Aún no hay citas registradas'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: citas.length,
            itemBuilder: (_, i) {
              final c = citas[i];
              final hecha = c.estado == 'completada';
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: hecha ? Colors.green : Colors.pink,
                    child: Icon(hecha ? Icons.check : Icons.schedule,
                        color: Colors.white),
                  ),
                  title: Text('${c.servicio} – ${c.nombre}'),
                  subtitle: Text(
                      '${fmt.format(c.fecha)}\nTel: ${c.telefono}${c.notas.isNotEmpty ? '\n${c.notas}' : ''}'),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) async {
                      if (v == 'completar') {
                        await service.cambiarEstado(c.id!, 'completada');
                      } else if (v == 'eliminar') {
                        await service.eliminar(c.id!);
                      }
                    },
                    itemBuilder: (_) => [
                      if (!hecha)
                        const PopupMenuItem(
                            value: 'completar',
                            child: Text('Marcar como completada')),
                      const PopupMenuItem(
                          value: 'eliminar', child: Text('Eliminar')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
