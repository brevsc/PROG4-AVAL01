import 'dart:math';
import 'package:flutter/material.dart';
import './models/operation.dart';
import './widgets/alert.dart';
import './utils/format_date_time.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AxiomFinance',
      theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: true),
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
        title: const Text('AxiomFinance'),
        backgroundColor: Theme.of(context).secondaryHeaderColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16.0),
            child: Text(
              'Saldo: R\$ ${balance.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Extrato da conta:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: operations.length,
              itemBuilder: (context, index) {
                Operation operation = operations[index];
                String formattedDate = formatDateTime(operation.date);
                return ListTile(
                  leading: operation.description == 'Depósito'
                      ? Icon(Icons.add, color: Colors.purple.shade700)
                      : Icon(Icons.remove, color: Colors.purple.shade700),
                  title: Text(operation.description),
                  subtitle: Text(
                    'Data: $formattedDate - Valor: R\$ ${operation.value.toStringAsFixed(2)}',
                  ),
                );
              },
            ),
          ),
        ],
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
