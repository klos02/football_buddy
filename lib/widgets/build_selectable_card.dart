import 'package:flutter/material.dart';
import 'package:football_buddy/providers/location_form_provider.dart';
import 'package:provider/provider.dart';

class BuildSelectableCard {
  Widget buildSelectableCard(
    BuildContext context,
    String title,
    String selectedCard,
  ) {
    final isSelected = title == selectedCard;

    return GestureDetector(
      onTap: () {
        context.read<LocationFormProvider>().setSelectedCard(title);
      },
      child: Card(
        color: isSelected ? Colors.blue : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
