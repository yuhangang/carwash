import 'package:flutter/material.dart';

class TicketNumberInputDialog extends StatefulWidget {
  const TicketNumberInputDialog({super.key});

  @override
  State<TicketNumberInputDialog> createState() =>
      _TicketNumberInputDialogState();
}

class _TicketNumberInputDialogState extends State<TicketNumberInputDialog> {
  final _plateController = TextEditingController(text: "#");

  @override
  void dispose() {
    _plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Ticket Number'),
      content: TextField(
        controller: _plateController,
        keyboardType: TextInputType.number,
      ),
      actions: [
        TextButton(
          child: const Text('Submit'),
          onPressed: () {
            String plate = _plateController.text;
            // Do something with the plate, e.g. save to database
            Navigator.pop(context, plate);
          },
        ),
      ],
    );
  }
}
