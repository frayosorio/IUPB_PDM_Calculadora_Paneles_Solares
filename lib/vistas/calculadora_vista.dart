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
  DateTime _desde = DateTime.now();
  DateTime _hasta = DateTime.now();

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
                validator: (ciudad) => ciudad == null? "Debe seleccionar una ciudad":null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child:TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Fecha de inicio"
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: _desde.toString().substring(0,10)
                      ),
                      onTap: () async {
                        final selectorFecha = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                        initialDate: _desde);
                        if(selectorFecha!=null){
                          setState(() {
                            _desde = selectorFecha;
                          });
                        }
                      }
                    )
                  ),
                  const SizedBox(height:20),
                  Expanded(
                      child:TextFormField(
                          decoration: const InputDecoration(
                              labelText: "Fecha hasta"
                          ),
                          readOnly: true,
                          controller: TextEditingController(
                              text: _hasta.toString().substring(0,10)
                          ),
                          onTap: () async {
                            final selectorFecha = await showDatePicker(
                                context: context,
                                firstDate: _desde,
                                lastDate: DateTime.now(),
                                initialDate: _hasta);
                            if(selectorFecha!=null){
                              setState(() {
                                _hasta = selectorFecha;
                              });
                            }
                          }
                      )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
