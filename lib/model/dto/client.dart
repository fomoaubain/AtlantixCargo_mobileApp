class Customer
{
  var idActivities;
  var nom;
  var prenom;
  var paymentMode;
  var depart;
  var arrive;

  Customer({
    required  this.idActivities,
    required  this.nom,
    required this.prenom,
    required this.paymentMode,
    required this.depart,
    required this.arrive,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      idActivities: json['idActivities'],
      nom: json['nom'],
      prenom: json['prenom'],
      paymentMode: json['paymentMode'],
      depart: json['depart'],
      arrive: json['arrive'],
    );
  }
}