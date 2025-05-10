import 'package:flutter/material.dart';
import 'package:projeto_bimestral/models/item.dart';
import 'package:projeto_bimestral/routes.dart';
import 'package:projeto_bimestral/widgets/custom_card.dart';
import 'package:projeto_bimestral/services/fake_data_service.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {
  final List<MeuItem> items = FakeDataService.getItems();


    return Scaffold(
      appBar: AppBar(
        title: const Text('Relax Sounds'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return CustomCard(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.detail,
                arguments: item,
              );
            },
            child: ListTile(
              leading: Image.asset(
                item.imageUrl,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
              title: Text(
                item.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                item.description,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          );
        },
      ),
    );
  }
}