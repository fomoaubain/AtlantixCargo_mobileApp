import 'dart:convert';

class Tourne
{
  var id;
  var idTourne;
  var date_jour;

  // status = 0 tournée a venir
  // status = 1 tournée  en cour
  // status = 2 tournée terminé
  var status;


  Tourne({
      this.idTourne,
      this.date_jour,
     this.status,
     this.id
  });

  Tourne.fromMap(Map<String, dynamic> item):
        id=item["id"],
        idTourne= item["idTourne"],
        date_jour=item["date_jour"],
        status=item["status"];

  Map<String, Object> toMap(){
    return {
      'idTourne':idTourne,
      'date_jour':date_jour,
      'status': status
    };
  }

}