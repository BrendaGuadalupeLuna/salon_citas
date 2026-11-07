import 'package:flutter/material.dart';

import 'form_screen.dart';
import 'list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.content_cut, size: 90, color: color.primary),
              const SizedBox(height: 16),
              Text('Salón de Belleza',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Agenda tu cita de forma rápida y sencilla',
                  textAlign: TextAlign.center),
              const SizedBox(height: 48),
              FilledButton.icon(
                icon: const Icon(Icons.add_circle_outline),
                label: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text('Agendar cita'),
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FormScreen())),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_month),
                label: const Padding(
                  padding: EdgeInsets.all(14),
                  child: Text('Ver citas'),
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ListScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
