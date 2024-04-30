// ignore_for_file: collection_methods_unrelated_type

import 'package:goshield_driver/model/ride_model.dart';
import 'package:goshield_driver/model/tax_model.dart';

class TruncationModel {
  String? success;
  dynamic error;
  String? message;
  List<TansactionData>? data;
  String? totalEarnings;

  TruncationModel(
      {this.success, this.error, this.message, this.data, this.totalEarnings});

  TruncationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TansactionData>[];
      json['data'].forEach((v) {
        data!.add(TansactionData.fromJson(v));
      });
    }
    totalEarnings = json['total_earnings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total_earnings'] = totalEarnings;
    return data;
  }
}

class TansactionData {
  String? id;
  String? idUserApp;
  String? distanceUnit;
  String? departName;
  String? destinationName;
  String? otp;
  String? latitudeDepart;
  String? longitudeDepart;
  String? latitudeArrivee;
  String? longitudeArrivee;
  String? numberPoeple;
  String? place;
  String? statut;
  String? idConducteur;
  String? creer;
  String? trajet;
  String? feelSafeDriver;
  String? nom;
  String? prenom;
  String? existingUserId;
  String? distance;
  String? rideType;
  String? phone;
  String? photoPath;
  String? nomConducteur;
  String? prenomConducteur;
  String? driverPhone;
  String? dateRetour;
  String? heureRetour;
  String? statutRound;
  String? montant;
  String? duree;
  String? userId;
  String? statutPaiement;
  String? payment;
  String? paymentImage;
  String? tripObjective;
  String? ageChildren1;
  String? ageChildren2;
  String? ageChildren3;
  List<Stops>? stops;
  List<TaxModel>? taxModel;
  String? tipAmount;
  String? discount;
  String? adminCommission;
  UserInfo? userInfo;
  String? amount;
  String? moyenneDriver;
  String? moyenne;
  String? orderType;
  String? source;
  String? destination;
  String? latSource;
  String? lngSource;
  String? latDestination;
  String? lngDestination;
  String? sourceCity;
  String? destinationCity;
  String? senderName;
  String? senderPhone;
  String? receiverName;
  String? receiverPhone;
  String? parcelWeight;
  List<String>? parcelImage;
  String? parcelType;
  String? parcelDate;
  String? parcelTime;
  String? receiveDate;
  String? receiveTime;
  String? status;
  String? reason;
  String? note;
  String? paymentStatus;
  String? idPaymentMethod;
  String? duration;
  String? tip;
  dynamic rejectedDriverId;
  String? createdAt;
  String? updatedAt;
  String? transactionAmount;
  String? libelle;
  String? userName;
  String? userPhoto;
  String? userPhotoPath;

  TansactionData(
      {this.id,
      this.idUserApp,
      this.distanceUnit,
      this.departName,
      this.destinationName,
      this.otp,
      this.latitudeDepart,
      this.longitudeDepart,
      this.latitudeArrivee,
      this.longitudeArrivee,
      this.numberPoeple,
      this.place,
      this.statut,
      this.idConducteur,
      this.creer,
      this.trajet,
      this.feelSafeDriver,
      this.nom,
      this.prenom,
      this.existingUserId,
      this.distance,
      this.rideType,
      this.phone,
      this.photoPath,
      this.nomConducteur,
      this.prenomConducteur,
      this.driverPhone,
      this.dateRetour,
      this.heureRetour,
      this.statutRound,
      this.montant,
      this.duree,
      this.userId,
      this.statutPaiement,
      this.payment,
      this.paymentImage,
      this.tripObjective,
      this.ageChildren1,
      this.ageChildren2,
      this.ageChildren3,
      this.stops,
      this.taxModel,
      this.tipAmount,
      this.discount,
      this.adminCommission,
      this.userInfo,
      this.amount,
      this.moyenneDriver,
      this.moyenne,
      this.orderType,
      this.source,
      this.destination,
      this.latSource,
      this.lngSource,
      this.latDestination,
      this.lngDestination,
      this.sourceCity,
      this.destinationCity,
      this.senderName,
      this.senderPhone,
      this.receiverName,
      this.receiverPhone,
      this.parcelWeight,
      this.parcelImage,
      this.parcelType,
      this.parcelDate,
      this.parcelTime,
      this.receiveDate,
      this.receiveTime,
      this.status,
      this.reason,
      this.note,
      this.paymentStatus,
      this.idPaymentMethod,
      this.duration,
      this.tip,
      this.rejectedDriverId,
      this.createdAt,
      this.updatedAt,
      this.transactionAmount,
      this.libelle,
      this.userName,
      this.userPhoto,
      this.userPhotoPath});

  TansactionData.fromJson(Map<String, dynamic> json) {
    List<TaxModel>? taxList = [];
    if (json['tax'] != null &&
        json['tax'] != [] &&
        json['tax'].toString().isNotEmpty) {
      taxList = <TaxModel>[];
      json['tax'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
    id = json['id'];
    idUserApp = json['id_user_app'];
    distanceUnit = json['distance_unit'];
    departName = json['depart_name'];
    destinationName = json['destination_name'];
    otp = json['otp'];
    latitudeDepart = json['latitude_depart'];
    longitudeDepart = json['longitude_depart'];
    latitudeArrivee = json['latitude_arrivee'];
    longitudeArrivee = json['longitude_arrivee'];
    numberPoeple = json['number_poeple'];
    place = json['place'];
    statut = json['statut'];
    idConducteur = json['id_conducteur'];
    creer = json['creer'];
    trajet = json['trajet'];
    feelSafeDriver = json['feel_safe_driver'];
    nom = json['nom'];
    prenom = json['prenom'];
    existingUserId = json['existing_user_id'];
    distance = json['distance'];
    rideType = json['ride_type'];
    phone = json['phone'];
    photoPath = json['photo_path'];
    nomConducteur = json['nomConducteur'];
    prenomConducteur = json['prenomConducteur'];
    driverPhone = json['driverPhone'];
    dateRetour = json['date_retour'];
    heureRetour = json['heure_retour'];
    statutRound = json['statut_round'];
    montant = json['montant'];
    duree = json['duree'];
    userId = json['userId'].toString();
    statutPaiement = json['statut_paiement'];
    payment = json['payment'];
    paymentImage = json['payment_image'];
    tripObjective = json['trip_objective'];
    ageChildren1 = json['age_children1'];
    ageChildren2 = json['age_children2'];
    ageChildren3 = json['age_children3'];
    if (json['user_info'] != null) {
      userInfo = UserInfo.fromJson(json['user_info']);
    }
    if (json['stops'] != null &&
        json['stops'] != [] &&
        json[stops].toString().isNotEmpty) {
      stops = <Stops>[];
      json['stops'].forEach((v) {
        stops!.add(Stops.fromJson(v));
      });
    } else {
      stops = [];
    }
    taxModel = taxList;
    tipAmount = json['tip_amount'];
    discount = json['discount'];
    adminCommission = json['admin_commission'];
    amount = json['amount'].toString();
    moyenneDriver = json['moyenne_driver'].toString();
    moyenne = json['moyenne'].toString();
    orderType = json['order_type'];
    source = json['source'];
    destination = json['destination'];
    latSource = json['lat_source'];
    lngSource = json['lng_source'];
    latDestination = json['lat_destination'];
    lngDestination = json['lng_destination'];
    sourceCity = json['source_city'];
    destinationCity = json['destination_city'];
    senderName = json['sender_name'];
    senderPhone = json['sender_phone'];
    receiverName = json['receiver_name'];
    receiverPhone = json['receiver_phone'];
    parcelWeight = json['parcel_weight'];
    if (json['parcel_image'] != null) {
      parcelImage = json['parcel_image'].cast<String>();
    }
    parcelType = json['parcel_type'];
    parcelDate = json['parcel_date'];
    parcelTime = json['parcel_time'];
    receiveDate = json['receive_date'];
    receiveTime = json['receive_time'];
    status = json['status'];
    reason = json['reason'];
    note = json['note'];
    paymentStatus = json['payment_status'];
    idPaymentMethod = json['id_payment_method'];
    duration = json['duration'];
    tip = json['tip'];
    rejectedDriverId = json['rejected_driver_id'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    transactionAmount = json['transactionAmount'].toString();
    libelle = json['libelle'];
    userName = json['user_name'];
    userPhoto = json['user_photo'];
    userPhotoPath = json['user_photo_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_user_app'] = idUserApp;
    data['distance_unit'] = distanceUnit;
    data['depart_name'] = departName;
    data['destination_name'] = destinationName;
    data['otp'] = otp;
    data['latitude_depart'] = latitudeDepart;
    data['longitude_depart'] = longitudeDepart;
    data['latitude_arrivee'] = latitudeArrivee;
    data['longitude_arrivee'] = longitudeArrivee;
    data['number_poeple'] = numberPoeple;
    data['place'] = place;
    data['statut'] = statut;
    data['id_conducteur'] = idConducteur;
    data['creer'] = creer;
    data['trajet'] = trajet;
    data['feel_safe_driver'] = feelSafeDriver;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['existing_user_id'] = existingUserId;
    data['distance'] = distance;
    data['ride_type'] = rideType;
    data['phone'] = phone;
    data['photo_path'] = photoPath;
    data['nomConducteur'] = nomConducteur;
    data['prenomConducteur'] = prenomConducteur;
    data['driverPhone'] = driverPhone;
    data['date_retour'] = dateRetour;
    data['heure_retour'] = heureRetour;
    data['statut_round'] = statutRound;
    data['montant'] = montant;
    data['duree'] = duree;
    data['userId'] = userId;
    data['statut_paiement'] = statutPaiement;
    data['payment'] = payment;
    data['payment_image'] = paymentImage;
    data['trip_objective'] = tripObjective;
    data['age_children1'] = ageChildren1;
    data['age_children2'] = ageChildren2;
    data['age_children3'] = ageChildren3;
    if (userInfo != null) {
      data['user_info'] = userInfo!.toJson();
    }
    if (stops!.isNotEmpty) {
      data['stops'] = stops!.map((v) => v.toJson()).toList();
    } else {
      data['stops'] = [];
    }
    data['tax'] =
        taxModel != null ? taxModel!.map((v) => v.toJson()).toList() : null;
    data['tip_amount'] = tipAmount;
    data['discount'] = discount;
    data['admin_commission'] = adminCommission;
    data['amount'] = amount;
    data['moyenne_driver'] = moyenneDriver;
    data['moyenne'] = moyenne;
    data['order_type'] = orderType;
    data['source'] = source;
    data['destination'] = destination;
    data['lat_source'] = latSource;
    data['lng_source'] = lngSource;
    data['lat_destination'] = latDestination;
    data['lng_destination'] = lngDestination;
    data['source_city'] = sourceCity;
    data['destination_city'] = destinationCity;
    data['sender_name'] = senderName;
    data['sender_phone'] = senderPhone;
    data['receiver_name'] = receiverName;
    data['receiver_phone'] = receiverPhone;
    data['parcel_weight'] = parcelWeight;
    data['parcel_image'] = parcelImage;
    data['parcel_type'] = parcelType;
    data['parcel_date'] = parcelDate;
    data['parcel_time'] = parcelTime;
    data['receive_date'] = receiveDate;
    data['receive_time'] = receiveTime;
    data['status'] = status;
    data['reason'] = reason;
    data['note'] = note;
    data['payment_status'] = paymentStatus;
    data['id_payment_method'] = idPaymentMethod;
    data['duration'] = duration;
    data['tip'] = tip;
    data['rejected_driver_id'] = rejectedDriverId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['transactionAmount'] = transactionAmount;
    data['libelle'] = libelle;
    data['user_name'] = userName;
    data['user_photo'] = userPhoto;
    data['user_photo_path'] = userPhotoPath;
    return data;
  }
}

class Tax {
  String? id;
  String? type;
  String? value;
  String? statut;
  String? country;
  String? libelle;

  Tax(
      {this.id,
      this.type,
      this.value,
      this.statut,
      this.country,
      this.libelle});

  Tax.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    value = json['value'];
    statut = json['statut'];
    country = json['country'];
    libelle = json['libelle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['value'] = value;
    data['statut'] = statut;
    data['country'] = country;
    data['libelle'] = libelle;
    return data;
  }
}
