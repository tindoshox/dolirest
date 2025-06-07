// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'package:objectbox/objectbox.dart';

@Entity()
class AddressModel {
  @Id()
  int id;

  String town;
  String address;

  AddressModel({
    this.id = 0,
    this.town = '',
    this.address = '',
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        town: json['town'],
        address: json['address'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'town': town,
        'address': address,
      };
}
