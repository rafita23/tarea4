import 'package:flutter/material.dart';

void main() => runApp(EventApp());

class EventApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda de Eventos',
      home: EventManager(),
    );
  }
}

class EventManager extends StatefulWidget {
  @override
  _EventManagerState createState() => _EventManagerState();
}

class _EventManagerState extends State<EventManager> {
  final List<Map<String, String>> _events = [];
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  void _addEvent() {
    if (_descriptionController.text.isNotEmpty && _selectedDate != null) {
      setState(() {
        _events.add({
          'date': _selectedDate!.toLocal().toString().split(' ')[0],
          'description': _descriptionController.text,
        });
      });
      _descriptionController.clear();
      _selectedDate = null;
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, completa todos los campos')),
      );
    }
  }

  void _deleteEvent(int index) {
    setState(() {
      _events.removeAt(index);
    });
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Registrar Evento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  _selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  setState(() {});
                },
                child: Text(
                  _selectedDate == null
                      ? 'Seleccionar Fecha'
                      : 'Fecha: ${_selectedDate!.toLocal()}'.split(' ')[0],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _addEvent,
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda de Eventos'),
      ),
      body: _events.isEmpty
          ? Center(
              child: Text(
                'No hay eventos registrados',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(event['description']!),
                    subtitle: Text('Fecha: ${event['date']}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteEvent(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
