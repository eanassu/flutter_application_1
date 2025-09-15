import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segunda Tela'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Você está na Segunda Tela!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 90),
            ElevatedButton(
              onPressed: () {
                // Volta para a tela anterior
                Navigator.pop(context);
              },
              child: const Text('Voltar para a Tela Principal'),
            ),
          ],
        ),
      ),
    );
  }
}