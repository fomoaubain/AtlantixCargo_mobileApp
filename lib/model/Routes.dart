import 'dart:convert';


class Routes
{
    var comment;
    var estimatedCost;
    var vehicleClass;
    var currentAssignment;
    Runkey runKey;
    List<Activities> activities;

  Routes({
    required  this.comment,
    required this.estimatedCost,
    required   this.vehicleClass,
    required this.currentAssignment,
    required  this.activities,
    required this.runKey

});

   factory Routes.fromJson(Map<String, dynamic> json) {

     var tagObjsJson = json['activities'] as List;
     List<Activities> _tagsActivities = tagObjsJson.map((tagJson) => Activities.fromJson(tagJson)).toList();

     return Routes(
       comment: json['comment'],
       estimatedCost: json['estimatedCost'],
       vehicleClass: json['vehicleClass'],
       currentAssignment: json['currentAssignment'],
       runKey: Runkey.fromJson(json['runKey']),
       activities: _tagsActivities,
     );
   }
}


class Activities
{
  var activityNo;
  var activityType;
  var arrivalTime;
  var departureTime;
  var earliestArrivalTime;
  var latestArrivalTime;
  var prevRunActivityNo;
  var nextRunActivityNo;
  Location location;
  TripInfo tripInfo;

  Activities({
    required  this.activityNo,
    required this.activityType,
    required   this.arrivalTime,
    required this.departureTime,
    required  this.earliestArrivalTime,
    required  this.latestArrivalTime,
    required  this.prevRunActivityNo,
    required  this.nextRunActivityNo,
    required  this.location,
    required  this.tripInfo,

  });

  factory Activities.fromJson(Map<String, dynamic> json) {
    return Activities(
      activityNo: json['activityNo'],
      activityType: json['activityType'],
      arrivalTime: json['arrivalTime'],
      departureTime: json['departureTime'],
      earliestArrivalTime: json['earliestArrivalTime'],
      latestArrivalTime: json['latestArrivalTime'],
      prevRunActivityNo: json['prevRunActivityNo'],
      nextRunActivityNo: json['nextRunActivityNo'],
      location: Location.fromJson(json['location']) ,
      tripInfo: TripInfo.fromJson(json['tripInfo']) ,
    );
  }
}



class Location
{
  var civicNumber;
  var suite;
  var building;
  var municipalityName;
  var municipalityIdentifier;
  var streetName;
  var streetOrientationCode;
  var streetOrientationName;
  var streetTypeCode;
  var streetTypeName;
  var territory;
  var intersection;
  var longitude;
  var latitude;
  var postalCode;
  var landmark;


  Location({
    required  this.civicNumber,
    required this.suite,
    required   this.building,
    required this.municipalityName,
    required  this.municipalityIdentifier,
    required  this.streetName,
    required  this.streetOrientationCode,
    required  this.streetOrientationName,
    required  this.streetTypeCode,
    required  this.streetTypeName,
    required  this.territory,
    required  this.intersection,
    required  this.longitude,
    required  this.latitude,
    required  this.postalCode,
    required  this.landmark,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      civicNumber: json['civicNumber'],
      suite: json['suite'],
      building: json['building'],
      municipalityName: json['municipalityName'],
      municipalityIdentifier: json['municipalityIdentifier'],
      streetName: json['streetName'],
      streetOrientationCode: json['streetOrientationCode'],
      streetOrientationName: json['streetOrientationName'],
      streetTypeCode: json['streetTypeCode'],
      streetTypeName: json['streetTypeName'],
      territory: json['territory'],
      intersection: json['intersection'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      landmark: json['landmark']!=null ? Landmark.fromJson(json['landmark']) : "",
      postalCode: json['postalCode'],

    );
  }
}


class Landmark
{
  var identifier;
  var description;
  var typeCode;
  var typeName;
  var operationalNote;

  Landmark({
    required  this.identifier,
    required this.description,
    required   this.typeCode,
    required this.typeName,
    required  this.operationalNote,
  });

  factory Landmark.fromJson(Map<String, dynamic> json) {
    return Landmark(
      identifier: json['identifier'],
      description: json['description'],
      typeCode: json['typeCode'],
      typeName: json['typeName'],
      operationalNote: json['operationalNote'],

    );
  }
}




class TripInfo
{
  var tripIdentifier;
  var customerIdentifier;
  var customerTitle;
  var firstName;
  var lastName;
  var seatedInFront;
  var caretakerRequirement;
  var characteristics;
  var deficience;
  var requestedTimeType;
  var assistiveDevices;
  var numberOfAmbulantCustomers;
  var numberOfWCCustomers;
  var numberOfAmbulantCompanions;
  var numberOfWCCompanions;
  var comment;
  var mustConfirmArrival;
  var groupOperationalNote;
  var attendantRequired;
  List<Passengers> passengers;


  TripInfo({
    required  this.tripIdentifier,
    required this.customerIdentifier,
    required   this.customerTitle,
    required this.firstName,
    required  this.lastName,
    required  this.seatedInFront,
    required  this.characteristics,
    required  this.caretakerRequirement,
    required  this.deficience,
    required  this.requestedTimeType,
    required  this.assistiveDevices,
    required  this.numberOfAmbulantCustomers,
    required  this.numberOfWCCustomers,
    required  this.numberOfAmbulantCompanions,
    required  this.numberOfWCCompanions,
    required  this.comment,
    required  this.mustConfirmArrival,
    required  this.groupOperationalNote,
    required  this.attendantRequired,
    required  this.passengers,
  });

  factory TripInfo.fromJson(Map<String, dynamic> json) {
    var tagObjsJson = json['passengers'] as List;
    List<Passengers> _tagsPassengers = tagObjsJson.map((tagJson) => Passengers.fromJson(tagJson)).toList();
    return TripInfo(
      tripIdentifier: json['tripIdentifier'],
      customerIdentifier: json['customerIdentifier'],
      customerTitle: json['customerTitle'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      seatedInFront: json['seatedInFront'],
      characteristics: json['characteristics'],
      caretakerRequirement: json['caretakerRequirement'],
      deficience: json['deficience'],
      requestedTimeType: json['requestedTimeType'],
      assistiveDevices: json['assistiveDevices'],
      numberOfAmbulantCustomers: json['numberOfAmbulantCustomers'],
      numberOfWCCustomers: json['numberOfWCCustomers'],
      numberOfAmbulantCompanions: json['numberOfAmbulantCompanions'],
      numberOfWCCompanions: json['numberOfWCCompanions'],
      comment: json['comment'],
      mustConfirmArrival: json['mustConfirmArrival'],
      groupOperationalNote: json['groupOperationalNote'],
      attendantRequired: json['attendantRequired'],
        passengers: _tagsPassengers,
    );
  }
}


class Runkey
{
  var scheduleIdentifier;
  var runIdentifier;


  Runkey({
    required  this.scheduleIdentifier,
    required this.runIdentifier,

  });

  factory Runkey.fromJson(Map<String, dynamic> json) {
    return Runkey(
      scheduleIdentifier: json['scheduleIdentifier'],
      runIdentifier: json['runIdentifier'],


    );
  }
}


class Passengers
{
  var passengerType;
  var paymentModes;
  var cardNumber;


  Passengers({
    required  this.passengerType,
    required this.paymentModes,
    required this.cardNumber,

  });

  factory Passengers.fromJson(Map<String, dynamic> json) {
    return Passengers(
      passengerType: json['passengerType'],
      paymentModes: json['paymentModes'],
      cardNumber: json['cardNumber'],
    );
  }
}
