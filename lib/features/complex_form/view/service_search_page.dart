// lib/features/complex_form/view/service_search_page.dart
import 'package:flutter/material.dart';
import 'package:form_gemini_tutorial/features/complex_form/data/mock_services.dart';

class ServiceSearchPage extends StatefulWidget {
  const ServiceSearchPage({super.key});

  @override
  State<ServiceSearchPage> createState() => _ServiceSearchPageState();
}

class _ServiceSearchPageState extends State<ServiceSearchPage> {
  List<String> _filteredServices = mockAvailableServices;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _filterServices();
    });
  }

  void _filterServices() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredServices = mockAvailableServices
          .where((service) => service.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Buscar servicio...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredServices.length,
        itemBuilder: (context, index) {
          final service = _filteredServices[index];
          return ListTile(
            title: Text(service),
            onTap: () {
              // Devolvemos el servicio seleccionado a la página anterior
              Navigator.of(context).pop(service);
            },
          );
        },
      ),
    );
  }
}