import 'dart:math' as math;

import 'lat_lng.dart';
import '/backend/backend.dart';

double pegoLatitude(LatLng coordenadas) {
  return coordenadas.latitude;
}

double pegoLongitude(LatLng coordenadas) {
  return coordenadas.longitude;
}

String? formatDateString(String input) {
  // Supõe que o formato de entrada é 'aaaa-mm-dd hh:mm:ss'
  // Corrige a entrada para usar um espaço em vez de 'T' se estiver presente
  input = input.replaceAll('T', ' ');

  DateTime dateTime;
  try {
    dateTime = DateTime.parse(input);
  } catch (e) {
    return 'Formato de data inválido';
  }

  // Formata para 'dd/mm/aaaa hh:mm'
  String formattedDate = '${dateTime.day.toString().padLeft(2, '0')}/'
      '${dateTime.month.toString().padLeft(2, '0')}/'
      '${dateTime.year.toString()} ';

  return formattedDate;
}

String? formatDateTimeString(String input) {
  // Supõe que o formato de entrada é 'aaaa-mm-dd hh:mm:ss'
  // Corrige a entrada para usar um espaço em vez de 'T' se estiver presente
  input = input.replaceAll('T', ' ');

  DateTime dateTime;
  try {
    dateTime = DateTime.parse(input);
  } catch (e) {
    return 'Formato de data inválido';
  }

  // Formata para 'dd/mm/aaaa hh:mm'
  String formattedDate = '${dateTime.hour.toString().padLeft(2, '0')}:'
      '${dateTime.minute.toString().padLeft(2, '0')}';

  return formattedDate;
}

int calculateDistanceInMeters(
  LatLng coord1,
  double lat,
  double long,
) {
  LatLng coord2 = LatLng(lat, long);
  var earthRadius = 6371.0; // Raio da Terra em quilômetros
  var lat1 = coord1.latitude * (math.pi / 180);
  var lon1 = coord1.longitude * (math.pi / 180);
  var lat2 = coord2.latitude * (math.pi / 180);
  var lon2 = coord2.longitude * (math.pi / 180);

  var deltaLat = lat2 - lat1;
  var deltaLon = lon2 - lon1;

  var a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
      math.cos(lat1) *
          math.cos(lat2) *
          math.sin(deltaLon / 2) *
          math.sin(deltaLon / 2);
  var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  var distanceInKilometers = earthRadius * c;
  var distanceInMeters = (distanceInKilometers * 1000)
      .round(); // Conversão para metros e arredondamento
  return distanceInMeters;
}

// (int, String) calculateDistanceInMostReadableUnit(
//   LatLng coord1,
//   double lat,
//   double long,
// ) {
//   var distanceInMeters = calculateDistanceInMeters(coord1, lat, long);
//   int distance;
//   String unit;

//   if(distanceInMeters > 9999) {
//     distance = (distanceInMeters / 1000) as int;
//     unit = "Km";
//   }

//   else {
//     distance = distanceInMeters;
//     unit = "Metros";
//   }

//   return (distance, unit);
// }