import 'dart:convert';

import 'package:calculadora_paneles_solares/modelos/ciudad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculadoraPaneles extends StatefulWidget {
  const CalculadoraPaneles({super.key});

  @override
  State<CalculadoraPaneles> createState() => _CalculadoraPanelesState();
}

class _CalculadoraPanelesState extends State<CalculadoraPaneles> {
  final _estadoFormulario = GlobalKey<FormState>();
  Ciudad? _ciudadSeleccionada;
  List<Ciudad> _ciudades = [];

  void _cargarCiudades() async {
    String datosJson = await rootBundle.loadString(
      "assets/datos/capitales_colombia.json",
    );
    final datos = jsonDecode(datosJson) as List;
    setState(() {
      _ciudades = datos.map((json) => Ciudad.fromJson(json)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarCiudades(); // Llamamos a la función al iniciar el widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Paneles Solares')),
      body: SingleChildScrollView(
        child: Form(
          key: _estadoFormulario,
          child: Column(
            children: [
              DropdownButtonFormField<Ciudad>(
                value: _ciudadSeleccionada,
                items: _ciudades.map((ciudad) {
                  return DropdownMenuItem(
                    child: Text(ciudad.nombre),
                    value: ciudad,
                  );
                }).toList(),
                onChanged: (Ciudad? ciudad) {
                  setState(() {
                    _ciudadSeleccionada = ciudad;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
