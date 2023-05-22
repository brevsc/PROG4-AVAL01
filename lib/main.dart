import 'dart:math';
import 'package:flutter/material.dart';
import './models/operation.dart';
import './widgets/alert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bank',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double balance = 1000.0;
  TextEditingController valueController = TextEditingController();
  List<Operation> operations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nubank 2'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                Random random = Random();
                double value = (random.nextDouble() * 999.99) + 0.01;
                value = double.parse(value.toStringAsFixed(2));
                DateTime data =
                    DateTime.now().subtract(Duration(days: random.nextInt(30)));

                setState(() {
                  balance += value;
                  operations.add(Operation('Depósito', data, value));
                });

                String formattedHour = data.toIso8601String().substring(11, 19);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Alert(
                        title: 'Sucesso',
                        description:
                            'Depósito de R\$ ${value.toStringAsFixed(2)} realizado com sucesso às $formattedHour',
                        buttonText: 'Ok');
                  },
                );
              },
              child: const Text('Depósito'),
            ),
            TextButton(
              onPressed: () {
                Random random = Random();
                double value = (random.nextDouble() * 999.99) + 0.01;
                value = double.parse(value.toStringAsFixed(2));

                if (value > balance) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const Alert(
                        title: 'Aviso',
                        description: 'O valor excede o saldo atual',
                        buttonText: 'Ok',
                      );
                    },
                  );
                } else {
                  DateTime date = DateTime.now()
                      .subtract(Duration(days: random.nextInt(30)));

                  setState(() {
                    balance -= value;
                    operations.add(Operation('Saque', date, value));
                  });

                  String formattedHour =
                      date.toIso8601String().substring(11, 19);

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Alert(
                        title: 'Sucesso',
                        description:
                            'Saque de R\$ ${value.toStringAsFixed(2)} realizado com sucesso às $formattedHour',
                        buttonText: 'Ok',
                      );
                    },
                  );
                }
              },
              child: const Text('Saque'),
            ),
          ],
        ),
      ),
    );
  }
}
