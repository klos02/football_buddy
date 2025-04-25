
import 'package:flutter/material.dart';
import 'package:football_buddy/providers/location_form_provider.dart';
import 'package:provider/provider.dart';

class AddLocationSheet extends StatelessWidget {
  final double lat;
  final double lng;

  const AddLocationSheet({
    super.key,
    required this.lat,
    required this.lng,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocationFormProvider(),
      child: Consumer<LocationFormProvider>(builder: (context, provider, _) {
        return Padding(padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        

        ),
        child: Form(key: provider.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Dodaj lokalizację',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: provider.nameController,
              decoration: const InputDecoration(
                labelText: 'Nazwa lokalizacji',
                border: OutlineInputBorder(),  
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Proszę podać nazwę lokalizacji';
                }
                return null;
              },

              
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: provider.isLoading ? null : () => provider.addLocation(lat, lng, context),
            child: provider.isLoading ? const CircularProgressIndicator() : const Text('Dodaj lokalizację'),
            ),
            const SizedBox(height: 16),
          ],
        ),),);
      },),
    );
  }
}