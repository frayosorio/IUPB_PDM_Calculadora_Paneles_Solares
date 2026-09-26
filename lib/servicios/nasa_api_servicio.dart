import "dart:convert";

import "package:http/http.dart" as http;

class NasaApiServicio {
  static const baseUrl="https://power.larc.nasa.gov/api/temporal/daily/point";

  Future<double> getRadiacionSolar(double latitud, double longitud, DateTime desde, DateTime hasta) async{

    final desdeFormateda="${desde.year}${desde.month.toString().padLeft(2,'0')}${desde.day.toString().padLeft(2,'0')}";
    final hastaFormateda="${hasta.year}${hasta.month.toString().padLeft(2,'0')}${hasta.day.toString().padLeft(2,'0')}";

    final endpoint = Uri.parse("$baseUrl?parameters=ALLSKY_SFC_SW_DWN&start=$desdeFormateda&end=$hastaFormateda&latitude=$latitud&longitude=$longitud&format=JSON&community=RE");

    final respuesta =await http.get(endpoint);
    if(respuesta.statusCode==200){
      final datosJSON = jsonDecode(respuesta.body);
      final valores=datosJSON["[properties][parameter][ALLSKY_SFC_SW_DWN]"];
      if(valores!=null && valores.isNotEmpty){
        final sumatoriaRadiacion = valores.values.reduce((suma, valor) => suma + valor);
        final promedioRadiacion = sumatoriaRadiacion/valores.length;
        return promedioRadiacion;
      }
    }
    return 0;
  }
}