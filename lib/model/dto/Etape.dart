

import 'dart:convert';

class Etape {
  var id;
  var action;
  var finish;

  Etape({
    required this.id,
    required this.action,
    required this.finish,


  });

  factory Etape.fromJson(Map<String, dynamic> jsonData) {
    return Etape(
      action: jsonData['action'],
      finish: jsonData['finish'],
      id: jsonData['id'],
    );
  }

  static Map<String, dynamic> toMap(Etape etape) => {
    'action': etape.action,
    'finish': etape.finish,
    'id': etape.id,
  };

  static String encode(List<Etape> etapes) => json.encode(
    etapes
        .map<Map<String, dynamic>>((etape) => Etape.toMap(etape))
        .toList(),
  );

  static List<Etape> decode(String etapes) =>
      (json.decode(etapes) as List<dynamic>)
          .map<Etape>((item) => Etape.fromJson(item))
          .toList();
}