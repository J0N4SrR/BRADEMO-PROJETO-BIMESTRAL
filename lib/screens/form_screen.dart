import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _selectedInterest;
  bool _acceptTerms = false;

  final List<String> _interests = [
    'Meditação',
    'Sono',
    'Bem-estar',
    'Música',
    'Relaxamento',
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Você precisa aceitar os termos.')),
        );
        return;
      }

      _formKey.currentState!.save();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulário enviado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Digite seu nome' : null,
                onSaved: (value) => _name = value,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value != null && value.contains('@') ? null : 'E-mail inválido',
                onSaved: (value) => _email = value,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Área de Interesse'),
                items: _interests
                    .map((interest) => DropdownMenuItem(
                          value: interest,
                          child: Text(interest),
                        ))
                    .toList(),
                validator: (value) =>
                    value == null ? 'Selecione uma opção' : null,
                onChanged: (value) {
                  setState(() => _selectedInterest = value);
                },
              ),
              const SizedBox(height: 12),
              CheckboxListTile(
                title: const Text('Aceito os termos e condições'),
                value: _acceptTerms,
                onChanged: (bool? value) {
                  setState(() => _acceptTerms = value ?? false);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
