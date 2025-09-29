import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async'; // Para usar StreamSubscription

class SensorsScreen extends StatefulWidget {
  const SensorsScreen({super.key});

  @override
  State<SensorsScreen> createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
  // Variáveis para armazenar os últimos valores dos sensores
  UserAccelerometerEvent? _userAccelerometerEvent;
  AccelerometerEvent? _accelerometerEvent;
  GyroscopeEvent? _gyroscopeEvent;
  MagnetometerEvent? _magnetometerEvent;

  // Lista de Streams para cancelar as inscrições quando o widget for descartado
  final List<StreamSubscription<dynamic>> _streamSubscriptions =
      <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    // Adicionar inscricões aos streams dos sensores
    _streamSubscriptions.add(
      userAccelerometerEventStream().listen(
        (UserAccelerometerEvent event) {
          setState(() {
            _userAccelerometerEvent = event;
          });
        },
      ),
    );
    _streamSubscriptions.add(
      accelerometerEventStream().listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerEvent = event;
          });
        },
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEventStream().listen(
        (GyroscopeEvent event) {
          setState(() {
            _gyroscopeEvent = event;
          });
        },
      ),
    );
    _streamSubscriptions.add(
      magnetometerEventStream().listen(
        (MagnetometerEvent event) {
          setState(() {
            _magnetometerEvent = event;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    // Cancelar todas as inscrições para evitar vazamento de memória
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  // Widget auxiliar para exibir os dados de um sensor
  Widget _buildSensorCard(String title, double? x, double? y, double? z) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('X: ${x?.toStringAsFixed(2) ?? 'N/A'}'),
            Text('Y: ${y?.toStringAsFixed(2) ?? 'N/A'}'),
            Text('Z: ${z?.toStringAsFixed(2) ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensores do Celular'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSensorCard(
              'Acelerômetro (com gravidade)',
              _accelerometerEvent?.x,
              _accelerometerEvent?.y,
              _accelerometerEvent?.z,
            ),
            _buildSensorCard(
              'Acelerômetro (sem gravidade)',
              _userAccelerometerEvent?.x,
              _userAccelerometerEvent?.y,
              _userAccelerometerEvent?.z,
            ),
            _buildSensorCard(
              'Giroscópio',
              _gyroscopeEvent?.x,
              _gyroscopeEvent?.y,
              _gyroscopeEvent?.z,
            ),
            _buildSensorCard(
              'Magnetômetro',
              _magnetometerEvent?.x,
              _magnetometerEvent?.y,
              _magnetometerEvent?.z,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Mova o celular para ver as leituras dos sensores mudarem em tempo real.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}